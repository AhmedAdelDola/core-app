import 'package:elhanbly/core/util/text_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ArabicNumberTextInputFormatter', () {
    test('converts Arabic-Indic digits to English digits', () {
      final formatter = ArabicNumberTextInputFormatter();

      final result = formatter.formatEditUpdate(
        const TextEditingValue(),
        const TextEditingValue(text: '١٢٣45'),
      );

      expect(result.text, '12345');
    });
  });

  group('WalletCodeTextInputFormatter', () {
    test('uppercases, removes invalid characters, and limits length', () {
      final formatter = WalletCodeTextInputFormatter();

      final result = formatter.formatEditUpdate(
        const TextEditingValue(),
        const TextEditingValue(text: 'ab12@@cd34ef56zz'),
      );

      expect(result.text, 'AB12-CD34-EF56');
      expect(result.selection.baseOffset, result.text.length);
    });
  });
}
