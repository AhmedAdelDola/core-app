// ignore_for_file: avoid_print
// ignore: depend_on_referenced_packages
import 'dart:async';

import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter/material.dart';
import 'core/app/app.dart';
import 'core/app/init_services.dart';
import 'core/services/di.dart';
import 'core/network/repository/repository_imports.dart';
import 'core/local/cache_helper.dart';
import 'core/local/enum_init.dart';

/// Special entrypoint used ONLY for automated screenshot capture.
/// Enables FlutterDriver extension so [test_driver/screenshot_driver.dart]
/// can connect and take real screenshots via the Dart VM service.
///
/// If --dart-define=TEST_PHONE=... is provided, auto-logs in before runApp
/// so Home, Library, and Profile screens render fully authenticated.
Future<void> main() async {
  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();

  const phone = String.fromEnvironment('TEST_PHONE', defaultValue: '');
  const pass = String.fromEnvironment('TEST_PASS', defaultValue: '');

  di<CacheHelper>().put(CachingKey.onBoarding, true);

  if (phone.isNotEmpty) {
    await _screenshotAutoLogin(phone: phone, pass: pass);
  }

  runApp(const MyApp());
}

Future<void> _screenshotAutoLogin({
  required String phone,
  required String pass,
}) async {
  try {
    await _performScreenshotLogin(phone: phone, pass: pass).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        print('Screenshot auto-login timed out after 30s');
      },
    );
  } catch (e) {
    print('Screenshot auto-login exception: $e');
  }
}

Future<void> _performScreenshotLogin({
  required String phone,
  required String pass,
}) async {
  final repo = di<Repository>();
  final fullPhone = phone.startsWith('+') ? phone : '+20$phone';
  final res = await repo.login(
    phone: fullPhone,
    password: pass.isNotEmpty ? pass : null,
  );
  res.fold(
    (l) => print('Screenshot auto-login error: $l'),
    (r) {
      di<CacheHelper>().put(CachingKey.isLogged, true);
      di<CacheHelper>().put(CachingKey.userData, r.toJson());
      print('✅ Screenshot auto-login successful for $fullPhone');
    },
  );
}
