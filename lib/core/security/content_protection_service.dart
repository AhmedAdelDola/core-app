import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:logger/logger.dart';

import '../../models/security/security_config_response.dart';
import '../../models/security/content_access_response.dart';
import '../local/cache_helper.dart';
import '../local/enum_init.dart';
import '../network/repository/repository_imports.dart';
import 'device_attestation_service.dart';

class ContentProtectionException implements Exception {
  final String code;
  final String message;

  ContentProtectionException(this.code, this.message);

  @override
  String toString() => 'ContentProtectionException($code): $message';
}

class ContentProtectionService {
  final Repository repository;
  final DeviceAttestationService attestationService;
  final CacheHelper cacheHelper;
  final Logger _logger = Logger();

  ContentProtectionService({
    required this.repository,
    required this.attestationService,
    required this.cacheHelper,
  });

  String? get enrolledDeviceId =>
      cacheHelper.get<String>(CachingKey.securityDeviceId);

  String get securityMode =>
      cacheHelper.get<String>(CachingKey.securityMode) ?? 'off';

  int? get cloudProjectNumber {
    final raw = cacheHelper.get<dynamic>(CachingKey.cloudProjectNumber);
    if (raw is int) return raw;
    if (raw != null) {
      final parsed = int.tryParse(raw.toString());
      if (parsed != null) return parsed;
    }
    final envVal = dotenv.env['PLAY_INTEGRITY_CLOUD_PROJECT_NUMBER'];
    if (envVal != null && envVal.isNotEmpty) {
      return int.tryParse(envVal);
    }
    return null;
  }

  /// Fetches security configuration from /api/mobile/v2/security/config
  Future<SecurityConfigResponse> getSecurityConfig() async {
    final result = await repository.getSecurityConfig();

    SecurityConfigResponse? parsedConfig;
    result.fold(
      (error) {
        _logger.e('Failed to fetch security config: $error');
      },
      (config) {
        parsedConfig = config;
      },
    );

    final config = parsedConfig ?? SecurityConfigResponse(mode: 'off');

    if (parsedConfig != null) {
      _logger.i(
        'Security config received: mode=${config.mode}, cloudProject=${config.cloudProjectNumber}, deviceId=${config.deviceId}',
      );
      cacheHelper.put(CachingKey.securityMode, config.mode);
      if (config.cloudProjectNumber != null) {
        final pNumber = int.tryParse(config.cloudProjectNumber!);
        if (pNumber != null) {
          cacheHelper.put(CachingKey.cloudProjectNumber, pNumber);
          if (Platform.isAndroid) {
            await attestationService.prepareIntegrity(pNumber);
          }
        }
      }
      if (config.deviceId != null && config.deviceId!.isNotEmpty) {
        cacheHelper.put(CachingKey.securityDeviceId, config.deviceId);
      }
    }
    return config;
  }

  /// Enrolls the device using Android Key Attestation & Play Integrity
  Future<String> enrollDevice({bool force = false}) async {
    if (!Platform.isAndroid) {
      throw ContentProtectionException(
        'PLATFORM_NOT_SUPPORTED',
        'Device attestation is only supported on Android.',
      );
    }

    final existingDeviceId = enrolledDeviceId;
    final hasKey = await attestationService.hasAttestationKey();

    if (!force && existingDeviceId != null && hasKey) {
      return existingDeviceId;
    }

    _logger.i('Starting Android device enrollment...');

    // 0. Ensure security config is loaded so cloudProjectNumber is available
    if (cloudProjectNumber == null) {
      _logger.i('cloudProjectNumber is null, fetching security config first...');
      await getSecurityConfig();
    }

    // 1. Get attestation challenge
    final challengeResult = await repository.getAttestationChallenge();
    final challenge = challengeResult.fold(
      (error) => throw ContentProtectionException(
        'CHALLENGE_FAILED',
        error?.toString() ?? 'Failed to get attestation challenge.',
      ),
      (c) => c,
    );

    // If challenge provides cloudProjectNumber, save and prepare it
    if (challenge.cloudProjectNumber != null) {
      final pNum = int.tryParse(challenge.cloudProjectNumber!);
      if (pNum != null) {
        cacheHelper.put(CachingKey.cloudProjectNumber, pNum);
        if (Platform.isAndroid) {
          await attestationService.prepareIntegrity(pNum);
        }
      }
    }

    // 2. Generate ECDSA P-256 key with attestation challenge in Keystore
    final certChain = await attestationService.generateAttestationKey(
      challenge.payloadToSign,
    );
    if (certChain.isEmpty) {
      throw ContentProtectionException(
        'KEY_GENERATION_FAILED',
        'Failed to generate hardware-backed attestation key.',
      );
    }

    // 3. Request Play Integrity token
    final projectNum = cloudProjectNumber;
    if (projectNum == null) {
      _logger.w('Warning: cloudProjectNumber is still null before requesting Play Integrity token.');
    }
    final integrityToken = await attestationService.requestPlayIntegrityToken(
      challenge.playIntegrityRequestHash,
      cloudProjectNumber: projectNum,
    );

    // 4. Sign the decoded payload bytes using SHA256withECDSA
    final signature = await attestationService.signPayload(
      challenge.payloadToSign,
    );

    // 5. Gather device model and app version
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    final packageInfo = await PackageInfo.fromPlatform();

    final model = '${deviceInfo.brand} ${deviceInfo.model}';
    final appVersion = packageInfo.version;

    // 6. Complete attestation
    final completeResult = await repository.completeAttestation(
      challengeId: challenge.challengeId,
      signature: signature,
      certificateChain: certChain,
      playIntegrityToken: integrityToken,
      model: model,
      appVersion: appVersion,
    );

    final deviceId = completeResult.fold(
      (error) {
        final errorStr = error.toString();
        if (errorStr.contains('DEVICE_NOT_TRUSTED')) {
          throw ContentProtectionException(
            'DEVICE_NOT_TRUSTED',
            'This device cannot be trusted for protected content.',
          );
        } else if (errorStr.contains('APP_INTEGRITY_FAILED')) {
          throw ContentProtectionException(
            'APP_INTEGRITY_FAILED',
            'Application integrity check failed.',
          );
        }
        throw ContentProtectionException(
          'ENROLLMENT_FAILED',
          errorStr,
        );
      },
      (id) => id,
    );

    if (deviceId.isEmpty) {
      throw ContentProtectionException(
        'ENROLLMENT_FAILED',
        'Device enrollment returned an empty device ID.',
      );
    }

    cacheHelper.put(CachingKey.securityDeviceId, deviceId);
    cacheHelper.put(
      CachingKey.lastAttestationTime,
      DateTime.now().toIso8601String(),
    );

    _logger.i('Device successfully enrolled with deviceId: $deviceId');
    return deviceId;
  }

  /// Requests access to session media (video/audio).
  Future<ContentAccessResponse> requestMediaAccess({
    required int sessionId,
  }) async {
    if (cacheHelper.get<String>(CachingKey.securityMode) == null) {
      await getSecurityConfig();
    }

    // If security is off or not Android, fallback to legacy getvideo
    if (securityMode == 'off' || !Platform.isAndroid) {
      final legacy = await repository.getvideo(sessionId.toString());
      return legacy.fold(
        (error) => throw ContentProtectionException('ACCESS_FAILED', error.toString()),
        (v) => ContentAccessResponse(playerUrl: v.playerUrl),
      );
    }

    // In monitor mode, attempt protected access; if it fails, fallback gracefully
    if (securityMode == 'monitor') {
      try {
        return await _executeContentAccess(
          sessionId: sessionId,
          contentKind: 'session_media',
        );
      } catch (e) {
        _logger.w('Monitor mode: protected media access failed, falling back to legacy: $e');
        final legacy = await repository.getvideo(sessionId.toString());
        return legacy.fold(
          (error) => throw ContentProtectionException('ACCESS_FAILED', error.toString()),
          (v) => ContentAccessResponse(playerUrl: v.playerUrl),
        );
      }
    }

    // In enforce mode, strictly require protected access with retry
    try {
      return await _executeContentAccess(
        sessionId: sessionId,
        contentKind: 'session_media',
      );
    } on ContentProtectionException catch (e) {
      if (e.code == 'DEVICE_ATTESTATION_REQUIRED' || e.code == 'DEVICE_REVOKED') {
        _logger.w('Attestation required or revoked. Re-enrolling device...');
        cacheHelper.clear(CachingKey.securityDeviceId);
        await attestationService.deleteAttestationKey();
        await enrollDevice(force: true);

        // Retry once after re-enrollment
        return await _executeContentAccess(
          sessionId: sessionId,
          contentKind: 'session_media',
        );
      }
      rethrow;
    }
  }

  /// Requests access to session PDF file.
  Future<ContentAccessResponse> requestPdfAccess({
    required int sessionId,
    String? fallbackUrl,
  }) async {
    if (cacheHelper.get<String>(CachingKey.securityMode) == null) {
      await getSecurityConfig();
    }

    // If security is off or not Android, return direct PDF URL
    if (securityMode == 'off' || !Platform.isAndroid) {
      return ContentAccessResponse(pdfUrl: fallbackUrl);
    }

    // In monitor mode, attempt protected access; if it fails, fallback gracefully
    if (securityMode == 'monitor') {
      try {
        return await _executeContentAccess(
          sessionId: sessionId,
          contentKind: 'session_pdf',
        );
      } catch (e) {
        _logger.w('Monitor mode: protected PDF access failed, falling back to direct URL: $e');
        return ContentAccessResponse(pdfUrl: fallbackUrl);
      }
    }

    // In enforce mode, strictly require protected access with retry
    try {
      return await _executeContentAccess(
        sessionId: sessionId,
        contentKind: 'session_pdf',
      );
    } on ContentProtectionException catch (e) {
      if (e.code == 'DEVICE_ATTESTATION_REQUIRED' || e.code == 'DEVICE_REVOKED') {
        _logger.w('Attestation required or revoked. Re-enrolling device...');
        cacheHelper.clear(CachingKey.securityDeviceId);
        await attestationService.deleteAttestationKey();
        await enrollDevice(force: true);

        return await _executeContentAccess(
          sessionId: sessionId,
          contentKind: 'session_pdf',
        );
      }
      rethrow;
    }
  }

  /// Core content challenge -> sign -> access flow
  Future<ContentAccessResponse> _executeContentAccess({
    required int sessionId,
    required String contentKind,
  }) async {
    final deviceId = await enrollDevice();

    // 1. Create content challenge
    final challengeResult = await repository.createContentChallenge(
      deviceId: deviceId,
      sessionId: sessionId,
      contentKind: contentKind,
    );

    final challenge = challengeResult.fold(
      (error) {
        final err = error.toString();
        if (err.contains('426') || err.contains('MOBILE_APP_UPDATE_REQUIRED')) {
          throw ContentProtectionException(
            'MOBILE_APP_UPDATE_REQUIRED',
            'Mobile app update is required to access protected content.',
          );
        }
        if (err.contains('DEVICE_ATTESTATION_REQUIRED')) {
          throw ContentProtectionException(
            'DEVICE_ATTESTATION_REQUIRED',
            'Device attestation required.',
          );
        }
        throw ContentProtectionException('CHALLENGE_FAILED', err);
      },
      (c) => c,
    );

    // 2. Obtain Play Integrity token if refresh is due
    String? playIntegrityToken;
    if (challenge.needsPlayIntegrityToken &&
        challenge.playIntegrityRequestHash != null) {
      try {
        playIntegrityToken = await attestationService.requestPlayIntegrityToken(
          challenge.playIntegrityRequestHash!,
          cloudProjectNumber: cloudProjectNumber,
        );
      } catch (e) {
        _logger.w('Play Integrity token fetch failed: $e');
        // When Google is temporarily unavailable, pass null so grace period applies if eligible
      }
    }

    // 3. Sign the challenge payload with the enrolled key
    final signature = await attestationService.signPayload(
      challenge.payloadToSign,
    );

    // 4. Request content access
    final accessResult = await repository.accessContent(
      challengeId: challenge.challengeId,
      deviceId: deviceId,
      signature: signature,
      playIntegrityToken: playIntegrityToken,
    );

    return accessResult.fold(
      (error) {
        final err = error.toString();
        if (err.contains('426') || err.contains('MOBILE_APP_UPDATE_REQUIRED')) {
          throw ContentProtectionException(
            'MOBILE_APP_UPDATE_REQUIRED',
            'Mobile app update is required to access protected content.',
          );
        }
        if (err.contains('DEVICE_ATTESTATION_REQUIRED')) {
          throw ContentProtectionException(
            'DEVICE_ATTESTATION_REQUIRED',
            'Device attestation required.',
          );
        }
        if (err.contains('DEVICE_NOT_TRUSTED')) {
          throw ContentProtectionException(
            'DEVICE_NOT_TRUSTED',
            'Device is not trusted.',
          );
        }
        if (err.contains('DEVICE_REVOKED')) {
          throw ContentProtectionException(
            'DEVICE_REVOKED',
            'Device has been revoked.',
          );
        }
        if (err.contains('SIGNATURE_INVALID')) {
          throw ContentProtectionException(
            'SIGNATURE_INVALID',
            'Attestation signature is invalid.',
          );
        }
        if (err.contains('CHALLENGE_EXPIRED')) {
          throw ContentProtectionException(
            'CHALLENGE_EXPIRED',
            'Content access challenge expired.',
          );
        }
        throw ContentProtectionException('ACCESS_DENIED', err);
      },
      (access) => access,
    );
  }
}
