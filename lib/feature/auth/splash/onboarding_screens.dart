import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/local/user_preferences/user_preferences_helper.dart';
import '../../../core/navigator/named_navigator_impl.dart';
import '../../../core/navigator/named_navigator_routes.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_buttons/custom_button.dart';
import '../../../core/widgets/app_buttons/master_button.dart';
import '../../../core/widgets/app_texts/app_text.dart';
import '../../../core/widgets/ui_helpers/extensions.dart';
import 'cubit/onboarding_models.dart';
import 'cubit/splash_cubit.dart';

import '../../../core/util/responsive/responsive_helper.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashCubit, SplashState>(
      builder: (context, state) {
        final cubit = SplashCubit.of(context);
        final isTablet = AppResponsive.isTabletOrLarger(context);

        return Container(
          color: AppColors.kWhite,
          child: Scaffold(
            backgroundColor: AppColors.kPrimary,
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: isTablet ? 20.h : 16.h),
                  SkipBtn(cubit.isLast),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40.w : 20,
                      ),
                      child: PageView.builder(
                        controller: cubit.controller,
                        onPageChanged: cubit.onPageChanged,
                        itemCount: 3,
                        itemBuilder: (context, i) => Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: isTablet ? 320.h : double.infinity,
                              maxWidth: isTablet ? 450 : double.infinity,
                            ),
                            child: SvgPicture.asset(
                              OnBoardingModel.images[i],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AdaptiveContainer(
                    maxWidth: ResponsiveBreakpoints.maxFormWidth,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 24 : 16,
                      vertical: isTablet ? 12 : 8,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(isTablet ? 24.0 : 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                20.sbH,
                                AppText(
                                  OnBoardingModel.titleIntro[cubit.pageIndex],
                                  style: TextStyle(
                                    fontSize: isTablet ? 22.sp : 28.sp,
                                    fontWeight: w700,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                17.sbH,
                                AppText(
                                  OnBoardingModel.bodyIntro[cubit.pageIndex],
                                  align: TextAlign.center,
                                  style: TextStyles.textViewRegular()
                                      .copyWith(
                                        color: AppColors.textColor2,
                                        fontSize: isTablet ? 14.sp : 15.sp,
                                      ),
                                  maxLines: 10,
                                ),
                                24.sbH,
                                _indecator(cubit),
                                24.sbH,
                                CustomButton(
                                  text:
                                      cubit.isLast ? 'انضم الينا' : 'التالى',
                                  onTap: () => cubit.changePage(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: -15,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              height: 65,
                              width: 65,
                              decoration: BoxDecoration(
                                color: AppColors.kPrimary,
                                shape: BoxShape.circle,
                                border: const Border.fromBorderSide(
                                  BorderSide(
                                    color: AppColors.kWhite,
                                    width: 5,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  OnBoardingModel.icons[cubit.pageIndex],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Row _indecator(SplashCubit cubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        OnBoardingModel.images.length,
        (index) => Container(
          height: 6,
          width: 24,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: cubit.pageIndex == index ? AppColors.kPrimary : Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class SkipBtn extends StatelessWidget {
  final bool isLast;
  const SkipBtn(this.isLast, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MasterButton(
            textColor: AppColors.kPrimary,
            minimumSize: Size(93.w, 48.h),
            buttonColor: AppColors.kWhite,
            borderColor: AppColors.kWhite,
            buttonRadius: 20.r,
            text: 'تخطي',
            onPressed: () async {
              UserPreferencesHelper().saveSeenOnBoarding(true);
              NamedNavigatorImpl.pushNamed(Routes.login, clean: true);
            },
          ),
        ],
      ),
    );
  }
}
