class Validator {
  static String? defaultValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  static String? name(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return 'هذا الحقل مطلوب';
      }
      if (value.length < 2) {
        return 'يجب ان يحتوى الاسم على اكثر من 2 حروف';
      }
    }
    return null;
  }

  static String? text(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return 'هذا الحقل مطلوب';
      } else if (!RegExp('[a-zA-Z]').hasMatch(value)) {
        return 'يجب ان يحتوى النص على حروف فقط';
      }
    }
    return null;
  }

  static String? defaultEmptyValidator(String? value) {
    return null;
  }

  static String? email(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return 'هذا الحقل مطلوب';
      } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value)) {
        return 'البريد الالكترونى غير صحيح';
      }
    } else {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  static String? password(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return 'هذا الحقل مطلوب';
      }
      if (value.length < 8) {
        return 'يجب ان تحتوى كلمة المرور على 8 احرف على الاقل';
      }
    }
    return null;
  }

  static String? confirmPassword(String? confirmPassword, String? password) {
    if (confirmPassword != null) {
      confirmPassword = confirmPassword.trim();
      if (confirmPassword.isEmpty) {
        return 'هذا الحقل مطلوب';
      } else if (confirmPassword != password) {
        return 'كلمة المرور غير متطابقة';
      }
    } else {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  static String? numbers(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return 'هذا الحقل مطلوب';
      }
      if (value.startsWith('+')) {
        value = value.replaceFirst(r'+', '');
      }
      final int? number = int.tryParse(value);
      if (number == null) {
        return 'يجب ان يحتوى الحقل على ارقام فقط';
      }
    } else {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  static String? walletCode(String? value) {
    if (value != null) {
      value = value.trim().toUpperCase();
      if (value.isEmpty) {
        return 'هذا الحقل مطلوب';
      }
      if (!RegExp(r'^[A-Z0-9]{4}(?:-[A-Z0-9]{4}){2}$').hasMatch(value)) {
        return 'يجب أن يكون الكود بالشكل 1TM2-N1JT-CLSD';
      }
    } else {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty || value.length != 10) {
        return '';
      }
    } else {
      return 'ادخل رقم الهاتف';
    }
    return null;
  }
}
