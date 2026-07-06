import 'validators.dart';

abstract class AppValidators {
  static final codeRequired = validators([
    IsRequired('لا يمكن ترك الحقل فارغا'),
    MinLength(7, 'الكود يجب أن يكون أكثر من 7 أرقام'),
    MaxLength(15, 'الكود يجب أن يكون أقل من ١٥ رقم'),
  ]);

  static final codeOptional = validators([
    IsOptional(),
    MinLength(3, 'فضلاً ادخل علي الاقل 3 حروف'),
    MaxLength(15, 'الكود يجب أن يكون أقل من ١٥ رقم'),
  ]);

  static final secondClient = validators([
    IsOptional(),
    MinLength(3, 'فضلاً ادخل علي الاقل 3 حروف'),
    MaxLength(100, 'لا يمكن أن يتعدي الحد الأقصي 100 حرف'),
  ]);

  static final receiverOptional = validators([
    IsOptional(),
    MinLength(3, 'فضلاً ادخل علي الاقل 3 حروف'),
    MaxLength(100, 'لا يمكن أن يتعدي الحد الأقصي 100 حرف'),
  ]);

  static final receiver = validators([
    IsRequired('لا يمكن ترك الحقل فارغا'),
    MinLength(3, 'فضلاً ادخل علي الاقل 3 حروف'),
    MaxLength(100, 'لا يمكن أن يتعدي الحد الأقصي 100 حرف'),
  ]);

  static final phone = validators([
    IsRequired('ادخل رقم هاتف صحيح'),
    IsPhoneNumber('ادخل رقم هاتف صحيح'),
  ]);

  static final number = validators([
    IsRequired('لا يمكن ترك الحقل فارغا'),
    MinLength(3, 'الرقم يجب أن يكون أكثر من ٣ أرقام'),
    // MaxLength(15, 'الرقم يجب أن يكون أقل من ١٥ رقم'),
  ]);
  static final phoneOptional = validators([
    IsOptional(),
    IsPhoneNumber('ادخل رقم هاتف صحيح'),
  ]);

  static final requiredOnly = validators([
    IsRequired('لا يمكن ترك الحقل فارغا'),
  ]);

  static final areaOptional = validators([
    IsOptional(),
    MinLength(3, 'فضلاً ادخل علي الاقل 3 حروف'),
    MaxLength(14, 'لا يمكن أن يتعدي الحد الأقصي 14 حرف'),
  ]);

  static final area = validators([
    IsRequired('لا يمكن ترك الحقل فارغا'),
    MinLength(3, 'فضلاً ادخل علي الاقل 3 حروف'),
    MaxLength(16, 'لا يمكن أن يتعدي الحد الأقصي 16 حرف'),
  ]);

  static final address = validators([
    IsRequired('لا يمكن ترك الحقل فارغا'),
    MinLength(3, 'فضلاً ادخل علي الاقل 3 حروف'),
    MaxLength(100, 'لا يمكن أن يتعدي الحد الأقصي 100 حرف'),
  ]);

  static final reason = validators([
    IsRequired('لا يمكن ترك الحقل فارغا'),
    MinLength(10, 'فضلاً ادخل علي الاقل 10 حروف'),
    MaxLength(250, 'لا يمكن أن يتعدي الحد الأقصي 250 حرف'),
  ]);

  static final notes = validators([
    IsOptional(),
  ]);

  static final requiredToCollect = validators([
    IsRequired('لا يمكن ترك الحقل فارغا'),
    MinMath(0, 'لا يمكن كتابة أقل من صفر'),
    NegativeSign('فضلاً ادخل رقم صحيح'),
    IsArabicNum('فضلاً ادخل ارقام  إنجليزية فقط'),
    MinLength(1, 'فضلاً ادخل المطلوب تحصيله (شامل الشحن)'),
    MaxLength(20, 'لا يمكن أن يتعدي الحد الأقصي 20 رقم'),
  ]);

  static final requiredToRefund = validators([
    IsRequired('لا يمكن ترك الحقل فارغا'),
    MinMath(0, 'لا يمكن كتابة أقل من صفر'),
    NegativeSign('فضلاً ادخل رقم صحيح'),
    IsArabicNum('فضلاً ادخل أرقام انجليزية فقط'),
    MinLength(1, 'فضلاً ادخل قيمة الإرتجاع (تكفلة الشحن)'),
    MaxLength(20, 'لا يمكن أن يتعدي الحد الأقصي 20 رقم'),
  ]);

  static final orderContent = validators([
    IsRequired('لا يمكن ترك الحقل فارغا'),
  ]);

  static final invoiceNumber = validators([
    IsOptional(),
    MaxLength(20, 'لا يمكن أن يتعدي الحد الأقصي 20 رقم'),
  ]);
  static final internationalOrderInvoiceNumber = validators([
    IsRequired('برجاء ادخال رقم الفاتورة اولاً'),
    MaxLength(20, 'لا يمكن أن يتعدي الحد الأقصي 20 رقم'),
  ]);
}
