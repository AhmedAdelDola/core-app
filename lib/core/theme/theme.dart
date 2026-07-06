import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/colors/app_colors.dart';
import '../widgets/app_texts/app_text.dart';

const String fontFamilyDINNextLT = 'DINNextLT';

abstract class TextStyles {
  static TextStyle textViewBold({FontWeight? fontWeight, Color? color, double? size}) => TextStyle(
        fontSize: size ?? 20.sp,
        fontFamily: fontFamilyDINNextLT,
        color: color,
        fontWeight: fontWeight ?? bold,
      );
  static TextStyle textViewSemiBold({FontWeight? fontWeight, Color? color, double? fontSize}) =>
      TextStyle(
        fontSize: fontSize ?? 20.sp,
        fontFamily: fontFamilyDINNextLT,
        color: color,
        fontWeight: fontWeight ?? w800,
      );
  static TextStyle textViewMedium({FontWeight? fontWeight, Color? color, double? fontSize}) =>
      TextStyle(
        fontSize: fontSize ?? 16.sp,
        fontFamily: fontFamilyDINNextLT,
        color: color,
        fontWeight: fontWeight ?? w700,
      );
  static TextStyle textViewRegular({FontWeight? fontWeight, Color? color, double? fontSize}) =>
      TextStyle(
        fontSize: fontSize ?? 14.sp,
        fontFamily: fontFamilyDINNextLT,
        color: color,
        fontWeight: fontWeight ?? w400,
      );
}

abstract class CustomMaterialAppTheme {
  static ButtonStyle elevatedButtonTheme = ElevatedButton.styleFrom(
      foregroundColor: AppColors.kWhite,
      elevation: 0.0,
      backgroundColor: AppColors.kPrimary,
      textStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: w600,
        fontFamily: fontFamilyDINNextLT,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)));
  static ButtonStyle outlineButtonTheme = OutlinedButton.styleFrom(
      elevation: 0.0,
      textStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: w600,
        fontFamily: fontFamilyDINNextLT,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)));
  static AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.kBlack,
    centerTitle: false,
    titleTextStyle: TextStyle(
        fontSize: 16.sp, color: AppColors.kBlack, fontFamily: fontFamilyDINNextLT, fontWeight: bold),
    elevation: 0.0,
    toolbarHeight: 75.h,
  );

  static ThemeData mainThemeData = ThemeData(
    useMaterial3: false,
    hoverColor: AppColors.kPrimary,
    primaryColorLight: AppColors.kPrimary,
    outlinedButtonTheme: OutlinedButtonThemeData(style: outlineButtonTheme),
    elevatedButtonTheme: ElevatedButtonThemeData(style: CustomMaterialAppTheme.elevatedButtonTheme),
    appBarTheme: CustomMaterialAppTheme.appBarTheme,
    scaffoldBackgroundColor: AppColors.kBackground,
    primaryColor: AppColors.kPrimary,
    fontFamily: fontFamilyDINNextLT,
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      headerBackgroundColor: AppColors.kPrimary,
      // headerForegroundColor: AppColors.kPrimary,
      headerHelpStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: bold,
      ),
      headerHeadlineStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: bold,
      ),
      rangeSelectionBackgroundColor: AppColors.kPrimary,
      rangeSelectionOverlayColor: WidgetStateProperty.all(AppColors.kPrimary),
      cancelButtonStyle: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        foregroundColor: WidgetStateProperty.all(AppColors.kPrimary),
      ),
      confirmButtonStyle: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        foregroundColor: WidgetStateProperty.all(AppColors.kPrimary),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),

    // stepper theme
  );
}
