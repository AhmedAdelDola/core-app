// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../../../../core/widgets/loader/app_loader.dart';
import '../../../../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../../cubit/courses_section_cubit.dart';
import 'course_lessons_card.dart';

class CourseLessonsSection extends StatefulWidget {
  const CourseLessonsSection({super.key});

  @override
  State<CourseLessonsSection> createState() => _CourseLessonsSectionState();
}

class _CourseLessonsSectionState extends State<CourseLessonsSection> {
  int _expandedIndex = -1; // Track which item is expanded

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return BlocBuilder<CoursesSectionCubit, CoursesSectionState>(
      builder: (context, state) {
        final cubit = CoursesSectionCubit.of(context);
        final model = cubit.courseData?.course?.chapters ?? [];

        if (state is GetCourseChapterLoadingState) return const AppLoader();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: AppText(
                'الأبواب (${model.length})',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: w700,
                ),
              ),
            ),
            10.sbH,
            isTablet
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 300,
                      mainAxisSpacing: 16.w,
                    ),
                    shrinkWrap: true,
                    itemCount: model.length,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    itemBuilder: (c, courseIndex) {
                      bool isExpanded = _expandedIndex == courseIndex;
                      return GestureDetector(
                        child: Row(
                          children: [
                            AppText('${courseIndex + 1}.'),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_expandedIndex == courseIndex) {
                                    _expandedIndex =
                                        -1; // Collapse if same item clicked
                                  } else {
                                    _expandedIndex =
                                        courseIndex; // Expand new item
                                  }
                                });
                              },
                              child: CourseLessonsCard(
                                onTap: () {
                                  setState(() {
                                    if (_expandedIndex == courseIndex) {
                                      _expandedIndex =
                                          -1; // Collapse if same item clicked
                                    } else {
                                      _expandedIndex =
                                          courseIndex; // Expand new item
                                    }
                                  });
                                },
                                name: model[courseIndex]?.title ?? '',
                                description:
                                    '',
                                courseIndex: courseIndex,
                                model: model,
                                isExpanded: isExpanded,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        model.length,
                        (courseIndex) {
                          bool isExpanded = _expandedIndex == courseIndex;
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_expandedIndex == courseIndex) {
                                    _expandedIndex =
                                        -1; // Collapse if clicked again
                                  } else {
                                    _expandedIndex =
                                        courseIndex; // Expand new one
                                  }
                                });
                              },
                              child: CourseLessonsCard(
                                onTap: () {
                                  setState(() {
                                    if (_expandedIndex == courseIndex) {
                                      _expandedIndex =
                                          -1; // Collapse if clicked again
                                    } else {
                                      _expandedIndex =
                                          courseIndex; // Expand new one
                                    }
                                  });
                                },
                                name: model[courseIndex]?.title ?? '',
                                description:
                                    '',
                                courseIndex: courseIndex,
                                model: model,
                                isExpanded: isExpanded,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
