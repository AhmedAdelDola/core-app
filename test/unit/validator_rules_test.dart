import 'package:elhanbly/core/util/validator/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextValidationRule validators', () {
    test('returns required error for null input when IsRequired is present', () {
      final validate = validators([IsRequired('required')]);

      expect(validate(null), 'required');
    });

    test('allows optional empty input', () {
      final validate = validators([
        IsOptional(),
        MinLength(4, 'too short'),
      ]);

      expect(validate(''), isNull);
    });

    test('returns first failing rule message', () {
      final validate = validators([
        IsRequired('required'),
        MinLength(4, 'too short'),
        MaxLength(8, 'too long'),
      ]);

      expect(validate('abc'), 'too short');
      expect(validate('abcdefghi'), 'too long');
      expect(validate('abcd'), isNull);
    });

    test('validates Egyptian phone numbers', () {
      final validate = validators([IsPhoneNumber('invalid phone')]);

      expect(validate('1000000000'), isNull);
      expect(validate('+201000000000'), isNull);
      expect(validate('123'), 'invalid phone');
    });
  });
}
