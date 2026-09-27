import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/services/di.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/widgets/app_texts/app_text.dart';
import '../../../core/widgets/loader/app_loader.dart';
import '../../../core/widgets/ui_helpers/extensions.dart';
import 'cubits/course_exams_cubit.dart';
import 'cubits/course_exams_state.dart';
import 'widgets/course_exam_card.dart';

class CourseExamsTab extends StatelessWidget {
  final dynamic courseId;

  const CourseExamsTab({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CourseExamsCubit>(
      create: (context) => di<CourseExamsCubit>()..getCourseExams(courseId),
      child: BlocBuilder<CourseExamsCubit, CourseExamsState>(
        builder: (context, state) {
          if (state is CourseExamsLoading) {
            return const Center(child: AppLoader());
          }

          if (state is CourseExamsError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 48.sp,
                      color: const Color(0xFFEF4444),
                    ),
                    12.sbH,
                    AppText(
                      state.message,
                      size: 14.sp,
                      color: AppColors.textColor2,
                      align: TextAlign.center,
                    ),
                    16.sbH,
                    ElevatedButton(
                      onPressed: () {
                        CourseExamsCubit.of(context).getCourseExams(courseId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: AppText(
                        'إعادة المحاولة',
                        size: 14.sp,
                        color: AppColors.kWhite,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CourseExamsSuccess) {
            final exams = state.exams;
            if (exams.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(32.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 80.r,
                        height: 80.r,
                        decoration: BoxDecoration(
                          color: AppColors.kPrimary.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.assignment_outlined,
                          size: 40.sp,
                          color: AppColors.kPrimary,
                        ),
                      ),
                      16.sbH,
                      AppText(
                        'لا توجد امتحانات متاحة حالياً',
                        size: 16.sp,
                        weight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                      8.sbH,
                      AppText(
                        'سيتم إضافة الامتحانات والاختبارات الدورية لهذا الكورس قريباً',
                        size: 13.sp,
                        color: AppColors.textColor2,
                        align: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await CourseExamsCubit.of(context).getCourseExams(courseId);
              },
              child: ListView.builder(
                padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
                itemCount: exams.length,
                itemBuilder: (context, index) {
                  return CourseExamCard(
                    exam: exams[index],
                    onExamFinished: () {
                      CourseExamsCubit.of(context).getCourseExams(courseId);
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
