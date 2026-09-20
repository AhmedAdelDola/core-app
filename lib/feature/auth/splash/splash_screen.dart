import 'package:cached_network_image/cached_network_image.dart';
import 'package:elhanbly/core/services/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/consts/client_config.dart';
import '../../../core/consts/images.dart';
import '../../../core/local/user_preferences/user_preferences_helper.dart';
import '../../../core/navigator/named_navigator_impl.dart';
import '../../../core/navigator/named_navigator_routes.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/theme.dart';
import 'cubit/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _logoScale;
  late final Animation<double> _titleFade;
  late final Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoScale = Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.55, 0.85, curve: Curves.easeIn),
      ),
    );
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is UnAuthenticatedState) {
            final seenOnBoarding = UserPreferencesHelper().getSeenOnBoarding();
            if (seenOnBoarding == false) {
              NamedNavigatorImpl.pushNamed(Routes.onBoarding, clean: true);
            } else {
              NamedNavigatorImpl.pushNamed(Routes.login, clean: true);
            }
          }

          if (state is AuthenticatedState) {
            NamedNavigatorImpl.pushNamed(Routes.homePage, clean: true);
          }
        },
        builder: (context, state) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.kWhite,
                  AppColors.kWhite.withOpacity(0.9),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.scale(
                          scale: _logoScale.value,
                          child: Container(
                            width: 160.w,
                            height: 160.w,
                            decoration: BoxDecoration(
                              color: AppColors.kBlack,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 24,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(28.w),
                            child: appSettings?.branding?.logoUrl == null ? Image.asset(
                              AppImages.logoPng,
                              fit: BoxFit.contain,
                            ):CachedNetworkImage(imageUrl: appSettings?.branding?.logoUrl ?? ''),
                          ),
                        ),
                        SizedBox(height: 26.h),
                        Opacity(
                          opacity: _titleFade.value,
                          child: Text(
                            appSettings?.branding?.displayName ?? ClientConfig.appName,
                            style: TextStyles.textViewSemiBold(
                              fontSize: 28.sp,
                              color: AppColors.kBlack,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Opacity(
                          opacity: _taglineFade.value,
                          child: Text(
                            appSettings?.branding?.slogan ?? ClientConfig.slogan,
                            style: TextStyles.textViewRegular(
                              fontSize: 14.sp,
                              color: AppColors.kBlack.withOpacity(0.84),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Opacity(
                          opacity: _taglineFade.value,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              3,
                              (index) => Container(
                                width: 10.w,
                                height: 10.w,
                                margin: EdgeInsets.symmetric(horizontal: 6.w),
                                decoration: BoxDecoration(
                                  color: AppColors.kBlack.withOpacity(
                                      0.4 + (index * 0.2)),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
