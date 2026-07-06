import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/navigator/named_navigator_impl.dart';
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
        return Column(
          children: [
            ShowAllWidget(
              'الكورسات المقترحة',
              () {
                NamedNavigatorImpl.push(BlocProvider.value(
                    value: cubit, child: const AllRecommendedCoursesScreen()));
              },
            ),
            SizedBox(height: isLargeScreen ? 32.h : 24.h),
            SizedBox(
              height: isLargeScreen ? 320.h : 295.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  horizontal: isLargeScreen ? 12 : 0,
                ),
                itemCount: cubit.home?.recommendedCourses?.length,
                itemBuilder: (c, i) =>
                    CourseCardItem(model: cubit.home?.recommendedCourses?[i]),
              ),
            ),
          ],
        );
      },
    );
  }
}
