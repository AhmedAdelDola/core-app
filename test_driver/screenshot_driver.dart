// ignore_for_file: avoid_print
// =============================================================================
// test_driver/screenshot_driver.dart
//
// Uses FlutterDriver to capture REAL screenshots from the running app.
// Expects authenticated session when TEST_PHONE/TEST_PASS are provided.
//
// Target output files (matched by frame_screenshots.dart):
//   01_splash.png
//   02_onboarding_or_login.png   → home overview
//   03_guest_home.png            → home content
//   04_main_screen.png           → home tab
//   05_library_screen.png        → library tab
//   06_profile_screen.png        → profile tab
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

    test('01 – Splash screen', () async {
      await snap('01_splash.png', delayMs: 800);
    });

    test('02 – Home overview', () async {
      await _waitForAuthenticatedHome(driver);
      await snap('02_onboarding_or_login.png', delayMs: 1500);
    });

    test('03 – Home content', () async {
      await snap('03_guest_home.png', delayMs: 2000);
    });

    test('04 – Main screen (Home tab)', () async {
      await _tapNavTab(driver, 0);
      await snap('04_main_screen.png', delayMs: 2500);
    });

    test('05 – Library screen (Library tab)', () async {
      await _tapNavTab(driver, 1);
      await snap('05_library_screen.png', delayMs: 3000);
    });

    test('06 – Profile screen (More tab)', () async {
      await _tapNavTab(driver, 2);
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

Future<void> _waitForAuthenticatedHome(FlutterDriver driver) async {
  const maxWait = Duration(seconds: 45);
  final deadline = DateTime.now().add(maxWait);

  while (DateTime.now().isBefore(deadline)) {
    try {
      await driver.waitFor(
        find.byValueKey('nav_tab_0'),
        timeout: const Duration(seconds: 3),
      );
      print('Authenticated home detected.');
      await Future<void>.delayed(const Duration(seconds: 2));
      return;
    } catch (_) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
  }

  print('Warning: home tab not detected; continuing with current screen.');
}

Future<void> _tapNavTab(FlutterDriver driver, int index) async {
  try {
    await driver.tap(
      find.byValueKey('nav_tab_$index'),
      timeout: const Duration(seconds: 5),
    );
    await Future<void>.delayed(const Duration(milliseconds: 1200));
  } catch (_) {
    final labels = ['الرئيسية', 'المكتبة', 'المزيد'];
    if (index < labels.length) {
      try {
        await driver.tap(
          find.text(labels[index]),
          timeout: const Duration(seconds: 3),
        );
        await Future<void>.delayed(const Duration(milliseconds: 1200));
      } catch (_) {}
    }
  }
}
