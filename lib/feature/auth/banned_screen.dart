import 'package:elhanbly/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/widgets/app_buttons/custom_button.dart';
import '../../../core/local/cache_helper.dart';
import '../../../core/local/enum_init.dart';
import '../../../core/local/user_preferences/user_preferences_helper.dart';
import '../../../core/navigator/named_navigator_impl.dart';
import '../../../core/navigator/named_navigator_routes.dart';
import '../../../core/services/di.dart';

class BannedScreen extends StatelessWidget {
  final String? banMessage;
  
  const BannedScreen({super.key, this.banMessage});

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
                  Icons.block_rounded,
                  size: 100.r,
                  color: AppColors.red,
                ),
                SizedBox(height: 24.h),
                Text(
                  'تم تعليق حسابك',
                  style: TextStyles.textViewBold(
                    size: 22.sp,
                    color: AppColors.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                Text(
                  banMessage ?? 'لقد تم حظر حسابك مؤقتاً لمخالفة سياسة الاستخدام أو تسجيل الدخول من أجهزة متعددة. للتواصل مع الدعم يرجى المراسلة.',
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
                    text: 'تسجيل الخروج',
                    onTap: () {
                      UserPreferencesHelper().clearUserPreference();
                      di<CacheHelper>().clear(CachingKey.userData);
                      di<CacheHelper>().put(CachingKey.isLogged, false);
                      NamedNavigatorImpl.pushNamed(Routes.login, clean: true);
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
