import 'package:elhanbly/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/colors/app_colors.dart';

class EmulatorBlockedScreen extends StatelessWidget {
  const EmulatorBlockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.kWhite,
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phonelink_erase,
                  size: 100.r,
                  color: AppColors.red,
                ),
                SizedBox(height: 24.h),
                Text(
                  'تم اكتشاف محاكي Android',
                  style: TextStyles.textViewBold(
                    size: 22.sp,
                    color: AppColors.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                Text(
                  'لا يمكن استخدام التطبيق إلا على أجهزة الهواتف الذكية الحقيقية لضمان الحماية والأمان.',
                  style: TextStyles.textViewRegular(
                    fontSize: 16.sp,
                    color: AppColors.textColor2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
