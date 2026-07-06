import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

extension EmptyPadding on num {
  SizedBox get sbH => SizedBox(height: toDouble().h);
  SizedBox get sbW => SizedBox(width: toDouble().w);
}

extension DateHelpers on DateTime {
  String toDateFormat({String? format, String? locale}) {
    final formatter = DateFormat(format ?? 'EE, d MMM hh:mm', locale ?? 'ar');
    return formatter.format(this);
  }
}
