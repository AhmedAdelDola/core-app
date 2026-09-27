import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/navigator/named_navigator_impl.dart';
import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/widgets/app_texts/app_text.dart';
import '../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../../models/exams/course_exams_response.dart';
import '../exam_screen.dart';
import '../exam_result_screen.dart';

class CourseExamCard extends StatelessWidget {
  final CourseExamItem exam;
  final VoidCallback? onExamFinished;

  const CourseExamCard({
    super.key,
    required this.exam,
    this.onExamFinished,
  });

  @override
  Widget build(BuildContext context) {
    final attempt = exam.attempt;
    final bool isInProgress = attempt?.status == 'in_progress';
    final bool isSubmitted = attempt != null && attempt.status != 'in_progress';
    final bool isPassed = attempt?.passed == true;

    String scopeText = 'امتحان كورس شامل';
    if (exam.lesson != null && (exam.lesson?.title?.isNotEmpty ?? false)) {
      scopeText = 'الدرس: ${exam.lesson!.title}';
    } else if (exam.chapter != null && (exam.chapter?.title?.isNotEmpty ?? false)) {
      scopeText = 'الباب: ${exam.chapter!.title}';
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isInProgress
              ? const Color(0xFFF59E0B).withOpacity(0.5)
              : isSubmitted
                  ? (isPassed ? const Color(0xFF10B981).withOpacity(0.4) : const Color(0xFFEF4444).withOpacity(0.4))
                  : const Color(0xFFE2E8F0),
          width: isInProgress || isSubmitted ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Scope badge + Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.kPrimary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.layers_outlined,
                      size: 14.sp,
                      color: AppColors.kPrimary,
                    ),
                    4.sbW,
                    AppText(
                      scopeText,
                      size: 12.sp,
                      weight: FontWeight.w600,
                      color: AppColors.kPrimary,
                    ),
                  ],
                ),
              ),
              if (isInProgress)
                _statusBadge('جاري الحل', const Color(0xFFF59E0B), const Color(0xFFFFFBEB))
              else if (isSubmitted)
                _statusBadge(
                  isPassed ? 'ناجح (${attempt.percentage?.toStringAsFixed(0) ?? 0}%)' : 'راسب (${attempt.percentage?.toStringAsFixed(0) ?? 0}%)',
                  isPassed ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  isPassed ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                ),
            ],
          ),
          12.sbH,

          // Exam Title
          AppText(
            exam.title ?? 'بدون عنوان',
            size: 17.sp,
            weight: FontWeight.w700,
            color: AppColors.textColor,
          ),
          if (exam.description != null && exam.description!.isNotEmpty) ...[
            6.sbH,
            AppText(
              exam.description!,
              size: 13.sp,
              color: AppColors.textColor2,
              maxLines: 2,
            ),
          ],
          12.sbH,

          // Metrics Pills Wrap
          Wrap(
            spacing: 12.w,
            runSpacing: 8.h,
            children: [
              _metricItem(
                Icons.timer_outlined,
                '${exam.durationMinutes ?? 0} دقيقة',
              ),
              _metricItem(
                Icons.help_outline,
                '${exam.questionsCount ?? 0} سؤال',
              ),
              _metricItem(
                Icons.star_outline,
                '${exam.totalPoints ?? 0} درجة',
              ),
              _metricItem(
                Icons.check_circle_outline,
                'النجاح: ${exam.passingPercentage ?? 50}%',
              ),
            ],
          ),
          16.sbH,

          // Bottom Action Row
          Row(
            children: [
              if (isSubmitted) ...[
                // View Result button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      if (attempt.id != null) {
                        await NamedNavigatorImpl.push(
                          ExamResultScreen(attemptId: attempt.id!),
                        );
                        onExamFinished?.call();
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.kPrimary,
                      side: BorderSide(color: AppColors.kPrimary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_turned_in_outlined, size: 16.sp),
                        6.sbW,
                        AppText(
                          'عرض النتيجة',
                          size: 14.sp,
                          weight: FontWeight.w600,
                          color: AppColors.kPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
                if (exam.canRetake == true) ...[
                  10.sbW,
                  // Retake button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (exam.id != null) {
                          await NamedNavigatorImpl.push(
                            ExamAttemptScreen(
                              examId: exam.id!,
                              examTitle: exam.title ?? '',
                            ),
                          );
                          onExamFinished?.call();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kPrimary,
                        foregroundColor: AppColors.kWhite,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh_rounded, size: 16.sp),
                          6.sbW,
                          AppText(
                            'إعادة المحاولة',
                            size: 14.sp,
                            weight: FontWeight.w600,
                            color: AppColors.kWhite,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ] else if (isInProgress) ...[
                // Resume Attempt button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (exam.id != null) {
                        await NamedNavigatorImpl.push(
                          ExamAttemptScreen(
                            examId: exam.id!,
                            attemptId: attempt?.id,
                            examTitle: exam.title ?? '',
                          ),
                        );
                        onExamFinished?.call();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B),
                      foregroundColor: AppColors.kWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow_rounded, size: 18.sp),
                        6.sbW,
                        AppText(
                          'استكمال الامتحان',
                          size: 14.sp,
                          weight: FontWeight.w600,
                          color: AppColors.kWhite,
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // Start Exam button
                Expanded(
                  child: ElevatedButton(
                    onPressed: exam.isAvailableNow == false
                        ? null
                        : () async {
                            if (exam.id != null) {
                              await NamedNavigatorImpl.push(
                                ExamAttemptScreen(
                                  examId: exam.id!,
                                  examTitle: exam.title ?? '',
                                ),
                              );
                              onExamFinished?.call();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kPrimary,
                      disabledBackgroundColor: const Color(0xFFE2E8F0),
                      foregroundColor: AppColors.kWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          exam.isAvailableNow == false
                              ? Icons.lock_outline
                              : Icons.play_arrow_rounded,
                          size: 18.sp,
                        ),
                        6.sbW,
                        AppText(
                          exam.isAvailableNow == false
                              ? 'غير متاح الآن'
                              : 'ابدأ الامتحان',
                          size: 14.sp,
                          weight: FontWeight.w600,
                          color: exam.isAvailableNow == false
                              ? AppColors.textColor4
                              : AppColors.kWhite,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String text, Color color, Color bg) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: AppText(
        text,
        size: 12.sp,
        weight: FontWeight.w700,
        color: color,
      ),
    );
  }

  Widget _metricItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: AppColors.textColor4),
        4.sbW,
        AppText(
          text,
          size: 12.sp,
          color: AppColors.textColor2,
          weight: FontWeight.w500,
        ),
      ],
    );
  }
}
