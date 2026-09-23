import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../core/consts/images.dart';
import '../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/widgets/app_bar/custom_curved_appbar.dart';
import '../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../cubit/home_cubit/home_cubit.dart';
import '../widgets/course_card_item.dart';

import '../../../../../../core/util/responsive/responsive_helper.dart';

class AllRecommendedCoursesScreen extends StatelessWidget {
  const AllRecommendedCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'الكورسات المقترحة'),
      body: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state) {
          final cubit = HomeCubit.of(context);
          final courses = cubit.home?.recommendedCourses;

          if (courses == null || courses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 180.h,
                    child: LottieBuilder.asset(
                      AppJsonFiles.emptyState,
                      fit: BoxFit.contain,
                    ),
                  ),
                  16.sbH,
                  AppText(
                    'لا توجد كورسات متاحة حالياً',
                    style: TextStyles.textViewRegular(
                      fontSize: 16.sp,
                      color: AppColors.textColor2,
                    ),
                  ),
                ],
              ),
            );
          }

          final isTablet = AppResponsive.isTabletOrLarger(context);
          final isDesktop = AppResponsive.isDesktop(context);
          final isMobileLandscape = AppResponsive.isMobileLandscape(context);
          final crossAxisCount = AppResponsive.gridColumns(
            context,
            mobile: 2,
            mobileLandscape: 3,
            tabletPortrait: 3,
            tabletLandscape: 3,
            desktop: 4,
          );

          final double spacing = isDesktop ? 16.0 : (isTablet ? 12.0 : 10.0);
          final double paddingVal = isDesktop ? 24.0 : (isTablet ? 16.0 : 12.0);

          return AdaptiveContainer(
            maxWidth: ResponsiveBreakpoints.maxContentWidth,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth =
                    (constraints.maxWidth -
                        paddingVal * 2 -
                        (crossAxisCount - 1) * spacing) /
                    crossAxisCount;
                final detailsHeight = isTablet ? 94.0 : (isMobileLandscape ? 84.0 : 88.0);
                final cardHeight = cardWidth * (9 / 16) + detailsHeight;

                return GridView.builder(
                  padding: EdgeInsets.all(paddingVal),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    mainAxisExtent: cardHeight,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    return CourseCardItem(
                      model: courses[index],
                      inGrid: true,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
