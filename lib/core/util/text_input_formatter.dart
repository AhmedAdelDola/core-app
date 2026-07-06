import 'package:flutter/services.dart';

class ArabicNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    bool containsArabicNumber = false;
    for (int i = 0; i < newText.length; i++) {
      if (newText.codeUnitAt(i) >= 0x0660 && newText.codeUnitAt(i) <= 0x0669) {
        containsArabicNumber = true;
        break;
      }
    }

    if (containsArabicNumber) {
      String englishNumbers = '';
      for (int i = 0; i < newText.length; i++) {
        int codeUnit = newText.codeUnitAt(i);
        if (codeUnit >= 0x0660 && codeUnit <= 0x0669) {
          englishNumbers += String.fromCharCode(codeUnit - 0x0630);
        } else {
          englishNumbers += String.fromCharCode(codeUnit);
        }
      }
      newText = englishNumbers;
    }

    return TextEditingValue(
      text: newText,
      selection: newValue.selection,
      composing: TextRange.empty,
    );
  }
}

class WalletCodeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final sanitizedText = newValue.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    String formattedText = '';

    for (int i = 0; i < sanitizedText.length; i++) {
      if (i == 4 || i == 8) {
        formattedText += '-';
      }
      formattedText += sanitizedText[i];
    }

    formattedText = formattedText.substring(0, formattedText.length > 14 ? 14 : formattedText.length);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
      composing: TextRange.empty,
    );
  }
}
