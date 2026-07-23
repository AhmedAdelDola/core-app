// =============================================================================
// test_driver/screenshot_driver.dart
//
// Uses FlutterDriver (not integration_test) to connect to the running app
// via Dart VM service and take REAL screenshots.
//
// FlutterDriver.screenshot() captures via _flutter.screenshot VM extension —
// this works even on software-rendered emulators (no GPU required).
//
// Run with:
//   flutter drive \
//     --driver=test_driver/screenshot_driver.dart \
//     --target=lib/main_screenshot.dart \
//     --dart-define=TAKING_SCREENSHOTS=true \
//     -d <device-id>
// =============================================================================

import 'dart:io';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Store screenshots', () {
    late FlutterDriver driver;
    final outputDir = Directory('raw_screenshots');

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      if (!outputDir.existsSync()) {
        outputDir.createSync(recursive: true);
      }
      // Let the app fully load
      await driver.waitUntilFirstFrameRasterized();
    });

    tearDownAll(() async {
      await driver.close();
    });

    /// Waits [ms] milliseconds then saves a screenshot.
    Future<void> snap(String filename, {int delayMs = 2500}) async {
      await Future<void>.delayed(Duration(milliseconds: delayMs));
      final bytes = await driver.screenshot();
      final file = File('${outputDir.path}/$filename');
      await file.writeAsBytes(bytes);
      print('📸 Saved: ${file.path} (${bytes.length} bytes)'); // ignore: avoid_print
    }

    test('01 – Splash screen', () async {
      // App starts on splash; capture immediately
      await snap('01_splash.png', delayMs: 1500);
    });

    test('02 – Onboarding / Login screen', () async {
      // Splash auto-navigates to onboarding or guest home after ~2 s
      await snap('02_onboarding.png', delayMs: 4000);
    });

    test('03 – Guest Home screen', () async {
      // Try tapping the "تسجيل الدخول" button area to reach login,
      // but first check if we are already on guest home
      try {
        // If onboarding is visible, swipe through it to reach guest home
        final skipBtn = find.text('تخطي');
        await driver.tap(skipBtn, timeout: const Duration(seconds: 3));
      } catch (_) {
        // Not on onboarding — already on guest home or login
      }
      await snap('03_guest_home.png', delayMs: 3000);
    });

    test('04 – Login screen', () async {
      try {
        final loginBtn = find.text('تسجيل الدخول');
        await driver.tap(loginBtn, timeout: const Duration(seconds: 3));
      } catch (_) {
        // login button not found — already on login page
      }
      await snap('04_login.png', delayMs: 2000);
    });

    test('05 – Library screen', () async {
      try {
        // Go back to guest home if a dialog appeared
        await driver.tap(find.text('إلغاء'), timeout: const Duration(seconds: 2));
      } catch (_) {}
      try {
        // Tap المكتبة tab in bottom nav (tab index 1)
        await driver.tap(find.text('المكتبة'), timeout: const Duration(seconds: 3));
      } catch (_) {}
      await snap('05_library.png', delayMs: 2500);
    });

    test('06 – More / Profile screen', () async {
      try {
        await driver.tap(find.text('المزيد'), timeout: const Duration(seconds: 3));
      } catch (_) {}
      await snap('06_profile.png', delayMs: 2000);
    });
  });
}
