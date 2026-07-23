// ignore_for_file: avoid_print
// =============================================================================
// test_driver/screenshot_driver.dart
//
// Uses FlutterDriver to capture REAL screenshots from the running app.
// Supports both authenticated (logged in) and guest flows.
//
// Target output files (matched by frame_screenshots.dart):
//   01_splash.png
//   02_onboarding_or_login.png
//   03_guest_home.png
//   04_main_screen.png   (Home tab)
//   05_library_screen.png (Library tab)
//   06_profile_screen.png (Profile/More tab)
// =============================================================================

import 'dart:async';
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
      await _waitForAppReady(driver);
    });

    tearDownAll(() async {
      await driver.close();
    });

    Future<void> snap(String filename, {int delayMs = 2000}) async {
      await Future<void>.delayed(Duration(milliseconds: delayMs));
      final bytes = await driver.screenshot();
      final file = File('${outputDir.path}/$filename');
      await file.writeAsBytes(bytes);
      print('📸 Saved: ${file.path} (${bytes.length} bytes)');
    }

    // 01 — Splash
    test('01 – Splash screen', () async {
      await snap('01_splash.png', delayMs: 800);
    });

    // 02 — Onboarding or Login
    test('02 – Onboarding or Login screen', () async {
      await Future<void>.delayed(const Duration(seconds: 3));
      await snap('02_onboarding_or_login.png', delayMs: 500);
    });

    // 03 — Guest Home / Welcome
    test('03 – Guest Home screen', () async {
      try {
        await driver.tap(find.text('تخطي'), timeout: const Duration(seconds: 3));
      } catch (_) {}
      await snap('03_guest_home.png', delayMs: 1500);
    });

    // 04 — Main Home Screen (Home tab)
    test('04 – Main screen (Home tab)', () async {
      try {
        await driver.tap(find.text('الرئيسية'), timeout: const Duration(seconds: 3));
      } catch (_) {}
      await snap('04_main_screen.png', delayMs: 3000);
    });

    // 05 — Library Screen (Library tab)
    test('05 – Library screen (Library tab)', () async {
      try {
        await driver.tap(find.text('المكتبة'), timeout: const Duration(seconds: 4));
      } catch (_) {}
      await snap('05_library_screen.png', delayMs: 3000);
    });

    // 06 — Profile Screen (More tab)
    test('06 – Profile screen (More tab)', () async {
      try {
        await driver.tap(find.text('المزيد'), timeout: const Duration(seconds: 4));
      } catch (_) {}
      await snap('06_profile_screen.png', delayMs: 3000);
    });
  }, timeout: const Timeout(Duration(minutes: 15)));
}

Future<void> _waitForAppReady(FlutterDriver driver) async {
  const maxWait = Duration(seconds: 90);
  final deadline = DateTime.now().add(maxWait);

  while (DateTime.now().isBefore(deadline)) {
    try {
      await driver
          .waitUntilFirstFrameRasterized()
          .timeout(const Duration(seconds: 10));
      return;
    } on TimeoutException {
      print('Waiting for first frame to rasterize...');
      await Future<void>.delayed(const Duration(seconds: 2));
    }
  }

  print('First frame wait exhausted after 90s; continuing with fallback delay.');
  await Future<void>.delayed(const Duration(seconds: 5));
}
