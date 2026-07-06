import 'package:elhanbly/core/widgets/app_buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/widget_test_app.dart';

void main() {
  testWidgets('CustomButton renders text and handles taps', (tester) async {
    var tapped = false;

    await pumpWidgetTestApp(
      tester,
      Scaffold(
        body: CustomButton(
          text: 'Continue',
          onTap: () => tapped = true,
        ),
      ),
    );

    expect(find.text('Continue'), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
