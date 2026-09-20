import 'dart:io';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class DeviceAttestationService {
  static const MethodChannel _channel =
      MethodChannel('leader.aplus.com/content_protection');
  final Logger _logger = Logger();

  bool get isAndroid => Platform.isAndroid;

  /// Prepares the Standard Play Integrity token provider with the given cloud project number.
  Future<bool> prepareIntegrity(int cloudProjectNumber) async {
    if (!isAndroid) return false;
    try {
      final result = await _channel.invokeMethod<bool>('prepareIntegrity', {
        'cloudProjectNumber': cloudProjectNumber,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      _logger.e('Failed to prepare Play Integrity: ${e.message}');
      return false;
    }
  }

  /// Generates an ECDSA P-256 key pair in Android KeyStore using the attestation challenge.
  /// Prefers StrongBox and falls back to TEE, never software.
  /// Returns the leaf-first certificate chain as a list of base64-encoded strings.
  Future<List<String>> generateAttestationKey(String challengeBase64) async {
    if (!isAndroid) {
      throw UnsupportedError(
          'Device attestation is only supported on Android devices.');
    }
    try {
      final dynamic result =
          await _channel.invokeMethod('generateAttestationKey', {
        'challenge': challengeBase64,
      });
      if (result is List) {
        return result.map((e) => e.toString()).toList();
      }
      return [];
    } on PlatformException catch (e) {
      _logger.e('Failed to generate attestation key: ${e.message}');
      rethrow;
    }
  }

  /// Signs the payload bytes using SHA256withECDSA with the enrolled private key.
  /// Returns the ASN.1 DER signature encoded as base64 string.
  Future<String> signPayload(String payloadBase64) async {
    if (!isAndroid) {
      throw UnsupportedError(
          'Payload signing is only supported on Android devices.');
    }
    try {
      final String? signature =
          await _channel.invokeMethod<String>('signPayload', {
        'payload': payloadBase64,
      });
      if (signature == null || signature.isEmpty) {
        throw StateError('Empty signature returned from native keystore.');
      }
      return signature;
    } on PlatformException catch (e) {
      _logger.e('Failed to sign payload: ${e.message}');
      rethrow;
    }
  }

  /// Requests a Standard Play Integrity token using the provided requestHash.
  Future<String> requestPlayIntegrityToken(
    String requestHash, {
    int? cloudProjectNumber,
  }) async {
    if (!isAndroid) {
      throw UnsupportedError(
          'Play Integrity is only supported on Android devices.');
    }
    try {
      final String? token =
          await _channel.invokeMethod<String>('requestPlayIntegrityToken', {
        'requestHash': requestHash,
        if (cloudProjectNumber != null)
          'cloudProjectNumber': cloudProjectNumber,
      });
      if (token == null || token.isEmpty) {
        throw StateError('Empty Play Integrity token returned.');
      }
      return token;
    } on PlatformException catch (e) {
      _logger.e('Failed to request Play Integrity token: ${e.message}');
      rethrow;
    }
  }

  /// Checks if the attestation key already exists in AndroidKeyStore.
  Future<bool> hasAttestationKey() async {
    if (!isAndroid) return false;
    try {
      final bool? exists =
          await _channel.invokeMethod<bool>('hasAttestationKey');
      return exists ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Deletes the enrolled attestation key.
  Future<bool> deleteAttestationKey() async {
    if (!isAndroid) return false;
    try {
      final bool? deleted =
          await _channel.invokeMethod<bool>('deleteAttestationKey');
      return deleted ?? false;
    } on PlatformException {
      return false;
    }
  }
}
