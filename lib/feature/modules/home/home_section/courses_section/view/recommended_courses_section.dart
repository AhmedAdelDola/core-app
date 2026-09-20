import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../core/consts/images.dart';
import '../../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../core/widgets/ui_helpers/extensions.dart';

import '../../../cubit/home_cubit/home_cubit.dart';
import '../../../widgets/show_all_widget.dart';
import '../widgets/course_card_item.dart';
import 'all_recommended_courses.dart';

class RecommendedCoursesSection extends StatelessWidget {
  const RecommendedCoursesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1200;
    final bool isDesktop = screenWidth >= 1200;
    final bool isLargeScreen = isTablet || isDesktop;

    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final cubit = HomeCubit.of(context);
        final courses = cubit.home?.recommendedCourses;
        final isEmpty = courses == null || courses.isEmpty;

        return Column(
          children: [
            ShowAllWidget(
              'الكورسات المقترحة',
              isEmpty
                  ? null
                  : () {
                      NamedNavigatorImpl.push(
                        BlocProvider.value(
                          value: cubit,
                          child: const AllRecommendedCoursesScreen(),
                        ),
                      );
                    },
            ),
            SizedBox(height: isLargeScreen ? 14.h : 10.h),
            if (isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 120.h,
                      child: LottieBuilder.asset(
                        AppJsonFiles.emptyState,
                        fit: BoxFit.contain,
                      ),
                    ),
                    8.sbH,
                    AppText(
                      'لا توجد كورسات متاحة حالياً',
                      style: TextStyles.textViewRegular(
                        fontSize: 14.sp,
                        color: AppColors.textColor2,
                      ),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                height: isLargeScreen ? 220.h : 200.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: isLargeScreen ? 20.w : 16.w,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (c, i) => CourseCardItem(
                    model: courses[i],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
