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

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashCubit, SplashState>(
      builder: (context, state) {
        final cubit = SplashCubit.of(context);
        return Container(
          color: AppColors.kWhite,
          child: Scaffold(
            backgroundColor: AppColors.kPrimary,
            body: Column(
              children: [
                60.sbH,
                SkipBtn(cubit.isLast),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: PageView.builder(
                      controller: cubit.controller,
                      // physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: cubit.onPageChanged,
                      itemCount: 3,
                      itemBuilder: (context, i) =>
                          SvgPicture.asset(OnBoardingModel.images[i]),
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Center(
                        child: Card(
                          margin: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  20.sbH,
                                  AppText(
                                    OnBoardingModel.titleIntro[cubit.pageIndex],
                                    style: TextStyle(
                                      fontSize: 28.sp,
                                      fontWeight: w700,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                  17.sbH,
                                  AppText(
                                    OnBoardingModel.bodyIntro[cubit.pageIndex],
                                    align: TextAlign.center,
                                    style: TextStyles.textViewRegular()
                                        .copyWith(color: AppColors.textColor2),
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
                        ),
                      ),
                      Positioned(
                        top: -15,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 65,
                          width: 65,
                          decoration:  BoxDecoration(
                            color: AppColors.kPrimary,
                            shape: BoxShape.circle,
                            border: Border.fromBorderSide(
                              BorderSide(
                                color: AppColors.kWhite,
                                width: 5,
                              ),
                            ),
                          ),
                          child: Center(
                              child: SvgPicture.asset(
                                  OnBoardingModel.icons[cubit.pageIndex])),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
