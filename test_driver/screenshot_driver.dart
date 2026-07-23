// =============================================================================
// test_driver/screenshot_driver.dart
//
// Uses FlutterDriver to capture REAL screenshots from the running app.
// FlutterDriver.screenshot() captures via Dart VM service — works on
// software-rendered emulators (no GPU required).
//
// Journey (all in Guest/unauthenticated mode — no credentials needed):
//   01_splash         → Splash screen
//   02_onboarding_1   → Onboarding page 1
//   03_onboarding_2   → Onboarding page 2
//   04_login          → Login screen (after tapping تخطي)
//   05_guest_home     → Guest home with featured courses loaded
//   06_guest_dialog   → Login-required dialog (after tapping a course card)
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
      // Wait for the very first frame to be rendered
      await driver.waitUntilFirstFrameRasterized();
    });

    tearDownAll(() async {
      await driver.close();
    });

    /// Waits [ms] ms then saves a screenshot named [filename].
    Future<void> snap(String filename, {int delayMs = 2000}) async {
      await Future<void>.delayed(Duration(milliseconds: delayMs));
      final bytes = await driver.screenshot();
      final file = File('${outputDir.path}/$filename');
      await file.writeAsBytes(bytes);
      // ignore: avoid_print
      print('📸 Saved: ${file.path} (${bytes.length} bytes)');
    }

    // ------------------------------------------------------------------
    // 01 — Splash screen
    // App starts here automatically. Splash auto-navigates after ~2 s.
    // ------------------------------------------------------------------
    test('01 – Splash screen', () async {
      await snap('01_splash.png', delayMs: 800);
    });

    // ------------------------------------------------------------------
    // 02 — Onboarding page 1
    // Splash navigates to onboarding (first time) or guest home.
    // ------------------------------------------------------------------
    test('02 – Onboarding page 1', () async {
      // Wait for onboarding to appear (splash auto-navigates in ~2 s)
      await Future<void>.delayed(const Duration(seconds: 3));

      // If already past onboarding, we may be on guest home / login.
      // In either case, take the screenshot.
      await snap('02_onboarding_1.png', delayMs: 500);
    });

    // ------------------------------------------------------------------
    // 03 — Onboarding page 2
    // Tap "التالى" to advance the page view.
    // ------------------------------------------------------------------
    test('03 – Onboarding page 2', () async {
      try {
        // "التالى" button on onboarding cards
        await driver.tap(find.text('التالى'),
            timeout: const Duration(seconds: 4));
      } catch (_) {
        // Not on onboarding — already past it
      }
      await snap('03_onboarding_2.png', delayMs: 1200);
    });

    // ------------------------------------------------------------------
    // 04 — Login screen
    // Tap "تخطي" to skip onboarding and land on the login screen.
    // ------------------------------------------------------------------
    test('04 – Login screen', () async {
      try {
        await driver.tap(find.text('تخطي'),
            timeout: const Duration(seconds: 4));
      } catch (_) {
        // Already past onboarding or on login
      }
      // Wait for login screen to settle and load the logo/form
      await snap('04_login.png', delayMs: 2500);
    });

    // ------------------------------------------------------------------
    // 05 — Guest Home (with courses)
    // From login screen, go back to navigate as guest.
    // The guest home shows featured courses loaded from the API.
    // ------------------------------------------------------------------
    test('05 – Guest Home screen', () async {
      try {
        // Pop back from login to guest home (if navigated from guest)
        await driver.tap(find.pageBack(),
            timeout: const Duration(seconds: 3));
      } catch (_) {
        // Not on login, try navigating via the browser back or ignore
      }

      // Wait for guest home courses to load from API (up to 6 s)
      try {
        await driver.waitFor(
          find.text('الدورات المميزة'),
          timeout: const Duration(seconds: 8),
        );
      } catch (_) {
        // Courses might be empty or screen is different — proceed anyway
      }

      await snap('05_guest_home.png', delayMs: 1500);
    });

    // ------------------------------------------------------------------
    // 06 — Course enrollment dialog
    // Tap the first course card — triggers "يرجى تسجيل الدخول" dialog.
    // This showcases the course content and UX flow.
    // ------------------------------------------------------------------
    test('06 – Course dialog', () async {
      try {
        // Find the first course card by its parent type and tap it
        // The card is inside a GestureDetector in a GridView
        final firstCard = find.byType('GestureDetector');
        await driver.tap(firstCard, timeout: const Duration(seconds: 4));
      } catch (_) {
        // Courses not loaded or already showing something else
      }

      await snap('06_course_dialog.png', delayMs: 2000);
    });
  });
}
