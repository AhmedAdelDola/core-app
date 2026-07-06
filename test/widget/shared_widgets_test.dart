import 'package:elhanbly/core/widgets/app_buttons/custom_button.dart';
import 'package:elhanbly/core/widgets/text_field/master_text_field.dart';
import 'package:elhanbly/core/widgets/ui_helpers/app_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/widget_test_app.dart';

void main() {
  testWidgets('CustomButton shows loader and disables tap while loading', (tester) async {
    var tapped = false;

    await pumpWidgetTestApp(
      tester,
      Scaffold(
        body: CustomButton(
          text: 'Submit',
          isLoading: true,
          onTap: () => tapped = true,
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton), warnIfMissed: false);
    await tester.pump();

    expect(tapped, isFalse);
  });

  testWidgets('MasterTextField validates and toggles password visibility', (tester) async {
    final controller = TextEditingController();

    await pumpWidgetTestApp(
      tester,
      Scaffold(
        body: Form(
          child: MasterTextField(
            controller: controller,
            isPassword: true,
            hintText: 'Password',
            validate: (value) => value == null || value.isEmpty ? 'required' : null,
          ),
        ),
      ),
    );

    final field = tester.widget<EditableText>(find.byType(EditableText));
    expect(field.obscureText, isTrue);

    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump();

    final updatedField = tester.widget<EditableText>(find.byType(EditableText));
    expect(updatedField.obscureText, isFalse);

    controller.dispose();
  });

  testWidgets('MasterTextField can be tapped without an explicit controller', (tester) async {
    await pumpWidgetTestApp(
      tester,
      const Scaffold(
        body: MasterTextField(
          hintText: 'Optional',
        ),
      ),
    );

    await tester.tap(find.byType(TextFormField));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets('AppDropdown renders items and calls onChanged', (tester) async {
    String? selected;

    await pumpWidgetTestApp(
      tester,
      Scaffold(
        body: AppDropdown(
          hintText: 'Choose',
          value: null,
          items: const ['One', 'Two'],
          onChanged: (value) => selected = value,
        ),
      ),
    );

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Two').last);
    await tester.pumpAndSettle();

    expect(selected, 'Two');
  });
}
