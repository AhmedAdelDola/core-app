class MinMath extends TextValidationRule {
  final int min;

  MinMath(this.min, [String? error]) : super(error);

  @override
  bool isValid(String input) {
    return (int.tryParse(input.trim()) ?? 0) >= min;
  }
}

class MinLength extends TextValidationRule {
  final int min;

  MinLength(this.min, [String? error]) : super(error);

  @override
  bool isValid(String input) {
    return input.trim().length >= min;
  }
}

class MaxLength extends TextValidationRule {
  final int max;

  MaxLength(this.max, [String? error]) : super(error);

  @override
  bool isValid(String input) => input.trim().length <= max;
}

class StartsWith extends TextValidationRule {
  final Pattern pattern;

  StartsWith(this.pattern, [String? error]) : super(error);

  @override
  bool isValid(String input) => input.trim().startsWith(pattern);
}

class NegativeSign extends TextValidationRule {
  NegativeSign([super.error]);

  @override
  bool isValid(String input) => input.trim() != '-';
}

class IsArabicNum extends TextValidationRule {
  IsArabicNum([super.error]);

  @override
  bool isValid(String input) => _isArabicNum(input);

  bool _isArabicNum(String input) {
    return RegExp(r'^\d+|-\d+|-|\+').hasMatch(input);
  }
}

class IsPhoneNumber extends TextValidationRule {
  IsPhoneNumber([super.error]);

  @override
  bool isValid(String input) => _isPhone(input);

  bool _isPhone(String input) {
    input = input.toEnglishNum();
    input = input.trim().replaceAll(' ', '');
    if (RegExp(r'^(\+201|1|00201)[0-2,5]').hasMatch(input)) {
      return RegExp(r'^(\+201|1|00201)[0-2,5][0-9]{8}$').hasMatch(input);
      // if (RegExp(r'^(\+201|01|00201)[0-2,5]{1}').hasMatch(input)) {
      //   return RegExp(r'^(\+201|01|00201)[0-2,5]{1}[0-9]{8}$').hasMatch(input);
    } else {
      return RegExp(r'^(\+0|0)[0-9]{9}$').hasMatch(input) &&
          !RegExp(r'^(\+0|0)0{9}$').hasMatch(input);
    }
  }
}

class IsRequired extends TextValidationRule {
  IsRequired([super.error]);

  @override
  bool isValid(String input) => _isNotEmpty(input);

  bool _isNotEmpty(String? string) {
    return string?.trim().isNotEmpty ?? false;
  }
}

class IsOptional extends TextValidationRule {
  IsOptional() : super('');

  @override
  bool isValid(String input) => true;
}

///*   Abstraction   *//
abstract class TextValidationRule {
  const TextValidationRule(this.error);

  bool isValid(String input);

  final String? error;
}

String? Function(String?) validators(
  List<TextValidationRule> rules,
) {
  return (String? input) {
    if (input == null) {
      return rules.whereType<IsRequired>().first.error;
    }
    var isOptional = false;
    String? msg;
    for (final rule in rules) {
      if (rule is IsOptional && input.trim().isEmpty) isOptional = true;
      msg = rule.isValid(input) ? null : rule.error;
      if (msg != null) {
        break;
      }
    }
    if (isOptional) return null;
    return msg;
  };
}

extension ReplaceEnglish on String {
  String toArabicNum() {
    var input = this;
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], arabic[i]);
    }

    return input;
  }

  String toEnglishNum() {
    var input = this;
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    for (int i = 0; i < arabic.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }
    return input;
  }
}
