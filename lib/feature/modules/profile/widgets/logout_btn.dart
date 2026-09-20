part of '../profile_imports.dart';

class LogoutBtn extends StatelessWidget {
  const LogoutBtn({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppImages.logout,
                    height: 24.h,
                    width: 24.w,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFDC2626),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              14.sbH,
              AppText(
                'تسجيل الخروج',
                style: TextStyles.textViewBold(
                  size: 17.sp,
                  color: AppColors.textColor,
                ),
              ),
              8.sbH,
              AppText(
                'هل أنت متأكد من رغبتك في تسجيل الخروج من التطبيق؟',
                style: TextStyles.textViewRegular(
                  fontSize: 13.sp,
                  color: AppColors.textColor4,
                ),
                align: TextAlign.center,
              ),
              20.sbH,
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: AppText(
                        'إلغاء',
                        style: TextStyles.textViewMedium(
                          fontSize: 14.sp,
                          color: AppColors.textColor5,
                        ),
                      ),
                    ),
                  ),
                  10.sbW,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        di<GetProfileCubit>().logout();
                        UserPreferencesHelper().clearUserPreference();
                        di<BottomBarCubit>().updatePageIndex(0);
                        NamedNavigatorImpl.pushNamed(Routes.login, clean: true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        elevation: 0,
                      ),
                      child: AppText(
                        'خروج',
                        style: TextStyles.textViewBold(
                          size: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetProfileCubit, GetProfileState>(
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is LogoutLoading,
          builder: (context) => const AppLoader(),
          fallback: (context) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              width: double.infinity,
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: const Color(0xFFFCA5A5).withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(14.r),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14.r),
                  onTap: () => _showLogoutDialog(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppImages.logout,
                        height: 18.h,
                        width: 18.w,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFDC2626),
                          BlendMode.srcIn,
                        ),
                      ),
                      8.sbW,
                      AppText(
                        'تسجيل الخروج',
                        style: TextStyle(
                          color: const Color(0xFFDC2626),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
