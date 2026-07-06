import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/widgets/app_bar/custom_curved_appbar.dart';
import '../../../cubit/home_cubit/home_cubit.dart';
import '../widgets/course_card_item.dart';

class AllRecommendedCoursesScreen extends StatelessWidget {
  const AllRecommendedCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600 && screenWidth < 900;
    final bool isDesktop = screenWidth >= 900;
    final bool isLargeScreen = isTablet || isDesktop;

    // Determine grid columns based on screen size
    int crossAxisCount = 1;
    if (isDesktop) {
      crossAxisCount = 4;
    } else if (isTablet) {
      crossAxisCount = 3;
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'الكورسات المقترحة'),
      body: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state) {
          final cubit = HomeCubit.of(context);

          return isLargeScreen
              ? GridView.builder(
                  padding: EdgeInsets.all(isDesktop ? 24 : 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: isDesktop ? 20 : 16,
                    mainAxisSpacing: isDesktop ? 20 : 16,
                  ),
                  itemCount: cubit.home?.recommendedCourses?.length ?? 0,
                  itemBuilder: (context, index) {
                    return CourseCardItem(
                      model: cubit.home?.recommendedCourses?[index],
                    );
                  },
                )
              : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: cubit.home?.recommendedCourses?.length ?? 0,
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  itemBuilder: (context, index) {
                    return Container(
                      height: 310.h,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 5,
                      ),
                      child: CourseCardItem(
                        model: cubit.home?.recommendedCourses?[index],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
