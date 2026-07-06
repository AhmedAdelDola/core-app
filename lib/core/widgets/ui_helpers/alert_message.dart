import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../theme/colors/app_colors.dart';

showToast(String? message) {
  Fluttertoast.showToast(
    backgroundColor: AppColors.hintColor,
    textColor: Colors.white,
    msg: message.toString(),
    toastLength: Toast.LENGTH_SHORT,
    timeInSecForIosWeb: 2,
    gravity: ToastGravity.BOTTOM,
  );
}

showErrorToast(String? message) {
  Fluttertoast.showToast(
    backgroundColor: Colors.red,
    textColor: Colors.white,
    msg: message.toString(),
    toastLength: Toast.LENGTH_SHORT,
    timeInSecForIosWeb: 2,
    gravity: ToastGravity.BOTTOM,
  );
}

showSuccessToast(String? message) {
  Fluttertoast.showToast(
    backgroundColor: AppColors.kPrimary,
    textColor: Colors.white,
    msg: message.toString(),
    toastLength: Toast.LENGTH_SHORT,
    timeInSecForIosWeb: 2,
    gravity: ToastGravity.BOTTOM,
  );
}
