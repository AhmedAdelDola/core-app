import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../navigator/named_navigator_impl.dart';
import '../../theme/colors/app_colors.dart';
import '../app_buttons/custom_button.dart';
import 'extensions.dart';

class ShowAppDialog {
  static gShowDialog(
    BuildContext context, {
    required Widget content,
    String? title,
    String? confirmText,
    String? canselText,
    VoidCallback? onConfirm,
    VoidCallback? onCansel,
    bool? barrierDismissible,
  }) {
    showDialog(
      // barrierDismissible: barrierDismissible ?? false,
      useSafeArea: true,
      context: context,
      builder: (context) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceIn,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Dialog(
          insetPadding: EdgeInsets.all(20.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 20.h),
                child: InkWell(
                  onTap: () => NamedNavigatorImpl.pop(),
                  child: const Icon(
                    Icons.close,
                    color: Color(0xff999999),
                    size: 16,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 323.h,
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    30.sbH,
                    content,
                    16.sbH,
                    if (confirmText != null)
                      CustomButton(
                        text: confirmText,
                        onTap: onConfirm ?? () => log('Button Click'),
                      ),
                    if (canselText != null) 8.sbH,
                    if (canselText != null)
                      CustomButton(
                        text: canselText,
                        onTap: () => NamedNavigatorImpl.pop(),
                        color: AppColors.kWhite,
                        textColor: AppColors.textColor,
                        borderColor: AppColors.kWhite,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<bool?> showAppDialog(
    BuildContext context, {
    required Widget child,
    double? borderRadius,
    bool isDismissible = false,
  }) {
    return showDialog<bool?>(
      context: context,
      barrierDismissible: isDismissible,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          ),
          child: child,
        );
      },
    );
  }
}
