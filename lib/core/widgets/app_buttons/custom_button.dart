import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors/app_colors.dart';
import '../app_texts/app_text.dart';
import '../loader/app_loader.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  // final Widget? icon;
  final Color? color, borderColor, textColor;
  // final bool? withMargin, withPadding;
  final double? width;
  final bool? isLoading;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    // this.icon,
    this.color,
    this.borderColor,
    this.textColor,
    // this.withMargin,
    // this.withPadding,
    this.width,
    this.isLoading = false,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading == true ? null : onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor ?? AppColors.kWhite,
        minimumSize: Size(width ?? 380.w, 52.h),
        // NEW
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        backgroundColor: color ?? AppColors.kPrimary,
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.r))),
        textStyle:
            TextStyle(color: textColor ?? AppColors.kWhite, fontSize: 14.sp, fontWeight: w600),
        side: BorderSide(color: borderColor ?? AppColors.kPrimary),
      ),
      child: isLoading == true
          ? const AppLoader()
          : AppText(
              text,
              style: textStyle ??
                  TextStyle(
                    color: textColor ?? AppColors.kWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
            ),
    );
  }
}
