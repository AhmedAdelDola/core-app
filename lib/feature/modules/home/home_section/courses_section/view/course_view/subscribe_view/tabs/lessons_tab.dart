import 'package:elhanbly/models/home_entities/courses/get_course_data_response_model.dart';
import 'package:elhanbly/core/theme/colors/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../../../../core/widgets/loader/app_loader.dart';
import '../../../../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../../cubit/courses_section_cubit.dart';
import 'package:flutter/material.dart';
import '../../course_view_widgets/course_lessons_section/course_lessons_card.dart';

class LessonsTab extends StatefulWidget {
  const LessonsTab({super.key});

  @override
  State<LessonsTab> createState() => _LessonsTabState();
}

class _LessonsTabState extends State<LessonsTab> {
  int _expandedIndex = 0; // Default to expanding the first chapter for instant visibility

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesSectionCubit, CoursesSectionState>(
      builder: (context, state) {
        final cubit = CoursesSectionCubit.of(context);
        final model = cubit.courseData;
        if (state is GetCourseChapterLoadingState) return const AppLoader();

        final List<Chapter> chapters = model?.course?.chapters ?? [];

        int totalLessons = 0;
        int totalSessions = 0;
        for (final Chapter ch in chapters) {
          final List<Lesson> lessons = ch.lessons ?? [];
          totalLessons += lessons.length;
          for (final Lesson l in lessons) {
            totalSessions += (l.sessions?.length ?? 0);
          }
        }

        if (chapters.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70.r,
                    height: 70.r,
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.menu_book_rounded,
                      size: 34.sp,
                      color: AppColors.kPrimary,
                    ),
                  ),
                  16.sbH,
                  AppText(
                    'لا توجد أبواب أو دروس بعد',
                    size: 15.sp,
                    weight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                  6.sbH,
                  AppText(
                    'سيتم نشر محتوى الدروس فور إضافتها من المعلم',
                    size: 12.sp,
                    color: AppColors.textColor4,
                    align: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
              child: Row(
                children: [
                  Icon(Icons.layers_outlined, size: 18.sp, color: AppColors.kPrimary),
                  8.sbW,
                  AppText(
                    'الأبواب والمحتوى',
                    style: TextStyle(
                      fontSize: 14.5.sp,
                      fontWeight: w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: AppText(
                      '${chapters.length} ${chapters.length == 1 ? "باب" : "أبواب"} • $totalLessons ${totalLessons == 1 ? "درس" : "دروس"}',
                      size: 11.sp,
                      weight: FontWeight.w600,
                      color: AppColors.textColor2,
                    ),
                  ),
                ],
              ),
            ),
            4.sbH,
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: chapters.length,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 20.h),
                separatorBuilder: (c, i) => 4.sbH,
                itemBuilder: (c, courseIndex) {
                  return CourseLessonsCard(
                    onTap: () {
                      setState(() {
                        _expandedIndex =
                            (_expandedIndex == courseIndex) ? -1 : courseIndex;
                      });
                    },
                    name: chapters[courseIndex].title ?? '',
                    description: '',
                    courseIndex: courseIndex,
                    model: chapters,
                    isExpanded: _expandedIndex == courseIndex,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
