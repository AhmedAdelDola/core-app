import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:elhanbly/core/app/app.dart';
import 'package:elhanbly/core/app/init_services.dart';

void main() {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Automated Multi-Tenant Navigation & Screenshot Capture',
      (WidgetTester tester) async {
    // 1. Initialize App Services
    await initServices();

    // 2. Pump main application
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Capture 01: Splash / Initial Screen
    await binding.convertFlutterSurfaceToImage();
    await binding.takeScreenshot('01_splash');

    // 3. Wait for Splash animation / transition
    await tester.pumpAndSettle(const Duration(seconds: 4));
    await binding.convertFlutterSurfaceToImage();
    await binding.takeScreenshot('02_onboarding_or_login');

    // 4. Try finding phone field or guest button to navigate further
    final Finder guestBtn = find.byKey(const Key('guest_button'));
    final Finder nextBtn = find.widgetWithText(ElevatedButton, 'التالي');

    if (guestBtn.evaluate().isNotEmpty) {
      await tester.tap(guestBtn);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await binding.convertFlutterSurfaceToImage();
      await binding.takeScreenshot('03_guest_home');
    } else if (nextBtn.evaluate().isNotEmpty) {
      await binding.convertFlutterSurfaceToImage();
      await binding.takeScreenshot('03_login_form');
    }

    // 5. Navigate to Home Layout if possible
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await binding.convertFlutterSurfaceToImage();
    await binding.takeScreenshot('04_main_screen');

    // 6. Navigate through Bottom Navigation Bar items if visible
    final Finder bottomNav = find.byType(BottomNavigationBar);
    if (bottomNav.evaluate().isNotEmpty) {
      try {
        await tester.tap(find.byIcon(Icons.library_books).first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        await binding.convertFlutterSurfaceToImage();
        await binding.takeScreenshot('05_library_screen');
      } catch (_) {}

      try {
        await tester.tap(find.byIcon(Icons.person).first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        await binding.convertFlutterSurfaceToImage();
        await binding.takeScreenshot('06_profile_screen');
      } catch (_) {}
    }
  });
}
