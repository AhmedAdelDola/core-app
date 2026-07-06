import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../core/services/di.dart';
import '../../../core/widgets/loader/app_loader.dart';
import '../../../core/widgets/ui_helpers/extensions.dart';
import 'cubit/home_cubit/home_cubit.dart';
import 'home_section/courses_section/view/recommended_courses_section.dart';
import 'home_section/files_section/view/recommended_files.dart';
import 'home_section/lessons_section/view/recommended_lessons_section.dart';
import 'home_section/subjects_section/view/subjects_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<HomeCubit>()..getData(),
      child: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state) {
          final cubit = HomeCubit.of(context);
          if (state is GetHomeLoadingState) return const AppLoader();
         
          return SmartRefresher(
            controller: cubit.refreshController,
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 500));
              cubit.getData();
              cubit.refreshController.refreshCompleted();
            },
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  // SizedBox(height: 15.h),
                  // const SubjectsSection(),
                  SizedBox(height: 24.h),
                  const RecommendedCoursesSection(),
                  SizedBox(height: 24.h),
                  const RecommendedLessonsSection(),
                  SizedBox(height: 24.h),
                  const RecommendedFiles(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
