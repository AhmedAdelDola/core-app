part of '../profile_imports.dart';

class LogoutBtn extends StatelessWidget {
  const LogoutBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetProfileCubit, GetProfileState>(
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is LogoutLoading,
          builder: (context) => const AppLoader(),
          fallback: (context) {
            return GestureDetector(
              onTap: () {
                di<GetProfileCubit>().logout();
                UserPreferencesHelper().clearUserPreference();
                di<BottomBarCubit>().updatePageIndex(0);
                NamedNavigatorImpl.pushNamed(Routes.login, clean: true);
              },
              child: Container(
                height: 42.h,
                width: 132.w,
                decoration: BoxDecoration(
                  color: AppColors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppText(
                      'تسجيل الخروج',
                      style: TextStyle(
                        color: AppColors.red,
                        fontSize: 14.sp,
                        fontWeight: w600,
                      ),
                    ),
                    SvgPicture.asset(
                      AppImages.logout,
                      height: 20.h,
                      width: 20.w,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
