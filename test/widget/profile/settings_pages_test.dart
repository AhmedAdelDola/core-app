import 'package:elhanbly/feature/modules/profile/profile_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/widget_test_app.dart';

void main() {
  testWidgets('AboutAppScreen renders scaffold and body text', (tester) async {
    await pumpWidgetTestApp(tester, const AboutAppScreen());

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(Text), findsWidgets);
  });

  testWidgets('TermsOfUseScreen renders a scrollable terms list', (tester) async {
    await pumpWidgetTestApp(tester, const TermsOfUseScreen());

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byIcon(Icons.circle), findsWidgets);
  });
}
