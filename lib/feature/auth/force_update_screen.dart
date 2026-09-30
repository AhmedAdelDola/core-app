import 'package:elhanbly/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/widgets/app_buttons/custom_button.dart';
import '../../../core/security/widgets/security_alert_dialogs.dart';

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});

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
                  Icons.system_update_alt_rounded,
                  size: 100.r,
                  color: AppColors.kPrimary,
                ),
                SizedBox(height: 24.h),
                Text(
                  'تحديث التطبيق مطلوب',
                  style: TextStyles.textViewBold(
                    size: 22.sp,
                    color: AppColors.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                Text(
                  'عفواً، الإصدار الحالي من التطبيق قديم ولم يعد مدعوماً. يرجى تحديث التطبيق إلى أحدث إصدار من المتجر لمتابعة الاستخدام.',
                  style: TextStyles.textViewRegular(
                    fontSize: 16.sp,
                    color: AppColors.textColor2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'تحديث الآن',
                    onTap: () {
                      SecurityAlertDialogs.openStore();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
