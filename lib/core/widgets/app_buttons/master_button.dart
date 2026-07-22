import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors/app_colors.dart';
import '../../theme/theme.dart';
import '../app_texts/app_text.dart';
import '../loader/app_loader.dart';
import '../ui_helpers/extensions.dart';

class MasterButton extends StatelessWidget {
  final Color? buttonColor, borderColor, iconColor, textColor;
  final Size? minimumSize, maximumSize;
  final bool? isLoading;
  final double? buttonRadius,
      height,
      width,
      sidePadding,
      verticalPadding,
      horizontalPadding,
      iconSize;
  final String? text;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final String? icon;
  final EdgeInsetsGeometry? padding, margin;
  final Widget? child;
  const MasterButton({
    super.key,
    this.buttonColor,
    this.margin,
    this.borderColor,
    this.iconColor,
    this.minimumSize,
    this.maximumSize,
    this.buttonRadius,
    this.sidePadding,
    this.verticalPadding,
    this.horizontalPadding,
    this.iconSize,
    this.icon,
    this.text,
    this.textStyle,
    this.onPressed,
    this.textColor,
    this.padding,
    this.child,
    this.height,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sidePadding ?? 0),
        child: ElevatedButton(
          onPressed: isLoading == true ? null : onPressed,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: AppColors.kPrimary,
            padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            foregroundColor: AppColors.kWhite,
            backgroundColor: buttonColor ?? AppColors.kPrimary,
            side: borderColor != null ? BorderSide(color: borderColor ?? AppColors.kPrimary) : null,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(buttonRadius == null ? 16.r : buttonRadius!.r)),
            ),
            minimumSize: minimumSize,
            maximumSize: maximumSize,
          ),
          child: isLoading == true
              ? const AppLoader()
              : child ??
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      AppText(
                        text ?? '',
                        style: textStyle ??
                            TextStyles.textViewMedium(fontSize: 16.sp)
                                .copyWith(color: textColor ?? AppColors.kWhite),
                        align: TextAlign.center,
                      ),
                      if (icon != null)
                        Row(
                          children: [
                            10.sbW,
                            Image.asset(
                              icon!,
                              height: iconSize,
                              color: iconColor,
                            ),
                          ],
                        ),
                      if (icon != null) 10.sbW,
                    ],
                  ),
        ),
      ),
    );
  }
}
