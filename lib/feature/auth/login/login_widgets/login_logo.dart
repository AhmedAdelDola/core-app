part of '../login_imports.dart';

class AuthBg extends StatelessWidget {
  final Widget child;

  const AuthBg({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.kWhite,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: child,
    );
  }
}

Widget get loginLogo {
  final SettingsResponse? settings = UserPreferencesHelper().getAppSettings();
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 20.sp),
    child: SizedBox(
      height: 180.sp,
      child: Hero(
        tag: 'logo',
        child: CachedNetworkImage(
          imageUrl: settings?.branding?.logoUrl ?? '',
          fit: BoxFit.contain,
          errorWidget: (context, url, error) => Image.asset(
            AppImages.logoSvg,
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
  );
}
