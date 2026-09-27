import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../core/navigator/named_navigator_impl.dart';
import '../../../core/services/di.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/widgets/app_texts/app_text.dart';
import '../../../core/widgets/loader/app_loader.dart';
import '../../../core/widgets/ui_helpers/extensions.dart';
import '../../../models/exams/exam_attempt_response.dart';
import 'cubits/exam_attempt_cubit.dart';
import 'cubits/exam_attempt_state.dart';
import 'exam_screen.dart';

class ExamResultScreen extends StatelessWidget {
  final dynamic attemptId;
  final int? examId;
  final String? examTitle;

  const ExamResultScreen({
    super.key,
    required this.attemptId,
    this.examId,
    this.examTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExamAttemptCubit>(
      create: (context) => di<ExamAttemptCubit>()..loadResult(attemptId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: AppColors.kWhite,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: AppText(
            'نتيجة الامتحان',
            size: 18.sp,
            weight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
        body: BlocBuilder<ExamAttemptCubit, ExamAttemptState>(
          builder: (context, state) {
            if (state.status == ExamSessionStatus.loading) {
              return const Center(child: AppLoader());
            }

            if (state.status == ExamSessionStatus.error) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
                      12.sbH,
                      AppText(
                        state.errorMessage ?? 'حدث خطأ أثناء تحميل النتيجة',
                        size: 14.sp,
                        color: AppColors.textColor2,
                        align: TextAlign.center,
                      ),
                      16.sbH,
                      ElevatedButton(
                        onPressed: () => ExamAttemptCubit.of(context).loadResult(attemptId),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.kPrimary),
                        child: AppText('إعادة المحاولة', color: AppColors.kWhite),
                      ),
                    ],
                  ),
                ),
              );
            }

            final result = state.resultData;
            if (result == null) {
              return const SizedBox.shrink();
            }

            final bool isPassed = result.passed == true;
            final double percentage = result.percentage ?? 0.0;
            final int score = (result.score ?? 0).toInt();
            final int maxScore = (result.maxScore ?? 0).toInt();
            final int totalQuestions = result.questionsCount ?? 0;
            final int correctCount = result.correctAnswersCount ?? 0;
            final int wrongCount = totalQuestions - correctCount;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Hero Result Banner
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: isPassed ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isPassed ? const Color(0xFF10B981).withOpacity(0.3) : const Color(0xFFEF4444).withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 64.r,
                          height: 64.r,
                          decoration: BoxDecoration(
                            color: isPassed ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isPassed ? Icons.emoji_events_rounded : Icons.cancel_rounded,
                            size: 36.sp,
                            color: AppColors.kWhite,
                          ),
                        ),
                        14.sbH,
                        AppText(
                          isPassed ? 'مبروك، لقد اجتزت الامتحان بنجاح! 🎉' : 'للأسف، لم تجتز الامتحان هذه المرة',
                          size: 18.sp,
                          weight: FontWeight.w700,
                          color: isPassed ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                          align: TextAlign.center,
                        ),
                        8.sbH,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            AppText(
                              '${percentage.toStringAsFixed(1)}%',
                              size: 32.sp,
                              weight: FontWeight.w800,
                              color: isPassed ? const Color(0xFF047857) : const Color(0xFFB91C1C),
                            ),
                            8.sbW,
                            AppText(
                              '($score من $maxScore درجة)',
                              size: 15.sp,
                              weight: FontWeight.w600,
                              color: isPassed ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                            ),
                          ],
                        ),
                        6.sbH,
                        AppText(
                          'درجة النجاح المطلوبة: ${result.passingPercentage ?? 50}%',
                          size: 13.sp,
                          color: AppColors.textColor2,
                        ),
                      ],
                    ),
                  ),
                  16.sbH,

                  // Summary Metrics Grid
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: AppColors.kWhite,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _metricBox(
                                'إجمالي الأسئلة',
                                '$totalQuestions',
                                Icons.format_list_numbered,
                                AppColors.textColor,
                                const Color(0xFFF1F5F9),
                              ),
                            ),
                            12.sbW,
                            Expanded(
                              child: _metricBox(
                                'الإجابات الصحيحة',
                                '$correctCount',
                                Icons.check_circle_outline,
                                const Color(0xFF10B981),
                                const Color(0xFFECFDF5),
                              ),
                            ),
                          ],
                        ),
                        12.sbH,
                        Row(
                          children: [
                            Expanded(
                              child: _metricBox(
                                'الإجابات الخاطئة',
                                '$wrongCount',
                                Icons.highlight_off,
                                const Color(0xFFEF4444),
                                const Color(0xFFFEF2F2),
                              ),
                            ),
                            12.sbW,
                            Expanded(
                              child: _metricBox(
                                'رقم المحاولة',
                                '${result.attemptNumber ?? 1} من ${result.maxAttempts ?? 1}',
                                Icons.repeat,
                                AppColors.kPrimary,
                                AppColors.kPrimary.withOpacity(0.08),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  16.sbH,

                  // Retake Button if allowed
                  if (result.canRetake == true && examId != null) ...[
                    ElevatedButton(
                      onPressed: () {
                        NamedNavigatorImpl.push(
                          ExamAttemptScreen(
                            examId: examId!,
                            examTitle: examTitle ?? '',
                          ),
                          replace: true,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kPrimary,
                        foregroundColor: AppColors.kWhite,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.replay_rounded, size: 20.sp),
                          8.sbW,
                          AppText(
                            'إعادة الامتحان (${result.remainingAttempts} محاولة متبقية)',
                            size: 15.sp,
                            weight: FontWeight.w700,
                            color: AppColors.kWhite,
                          ),
                        ],
                      ),
                    ),
                    16.sbH,
                  ],

                  // Question Breakdown Header
                  if (result.canReviewAnswers == true && (result.questions?.isNotEmpty ?? false)) ...[
                    Row(
                      children: [
                        Icon(Icons.rate_review_outlined, size: 20.sp, color: AppColors.kPrimary),
                        8.sbW,
                        AppText(
                          'مراجعة الأسئلة والإجابات',
                          size: 17.sp,
                          weight: FontWeight.w700,
                          color: AppColors.textColor,
                        ),
                      ],
                    ),
                    12.sbH,

                    // Questions List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: result.questions!.length,
                      separatorBuilder: (_, __) => 12.sbH,
                      itemBuilder: (context, index) {
                        return _buildReviewQuestionCard(result.questions![index], index + 1);
                      },
                    ),
                  ] else if (result.canReviewAnswers == false) ...[
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 22.sp, color: AppColors.textColor4),
                          10.sbW,
                          Expanded(
                            child: AppText(
                              result.reviewAvailableAt != null
                                  ? 'ستكون مراجعة الإجابات متاحة في ${result.reviewAvailableAt}'
                                  : 'مراجعة الإجابات النموذجية غير مفعلة لهذا الامتحان.',
                              size: 13.sp,
                              color: AppColors.textColor2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  24.sbH,
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _metricBox(String label, String value, IconData icon, Color color, Color bg) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: color),
          10.sbW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  label,
                  size: 11.sp,
                  color: AppColors.textColor2,
                ),
                4.sbH,
                AppText(
                  value,
                  size: 15.sp,
                  weight: FontWeight.w700,
                  color: color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewQuestionCard(ExamQuestionItem question, int questionNumber) {
    final bool isCorrect = question.isCorrect == true;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isCorrect ? const Color(0xFF10B981).withOpacity(0.4) : const Color(0xFFEF4444).withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Question number + points + status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: AppText(
                      'سؤال $questionNumber',
                      size: 13.sp,
                      weight: FontWeight.w700,
                      color: AppColors.kPrimary,
                    ),
                  ),
                  8.sbW,
                  AppText(
                    '(${question.awardedPoints ?? 0} / ${question.maxPoints ?? 1} درجة)',
                    size: 12.sp,
                    color: AppColors.textColor2,
                    weight: FontWeight.w600,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: isCorrect ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      size: 14.sp,
                      color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    ),
                    4.sbW,
                    AppText(
                      isCorrect ? 'صحيحة' : 'خاطئة',
                      size: 12.sp,
                      weight: FontWeight.w700,
                      color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.sbH,

          // Question Body
          HtmlWidget(
            question.body ?? '',
            textStyle: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          if (question.imageUrl != null && question.imageUrl!.isNotEmpty) ...[
            10.sbH,
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.network(
                question.imageUrl!,
                fit: BoxFit.contain,
                height: 180.h,
                width: double.infinity,
              ),
            ),
          ],
          14.sbH,

          // Options List
          Column(
            children: (question.options ?? []).map((option) {
              final bool isSelected = option.isSelected == true;
              final bool isOptCorrect = option.isCorrect == true;

              Color optBg = const Color(0xFFF8FAFC);
              Color optBorder = const Color(0xFFE2E8F0);
              Color optText = AppColors.textColor;
              IconData? optIcon;
              Color? optIconColor;

              if (isOptCorrect) {
                optBg = const Color(0xFFECFDF5);
                optBorder = const Color(0xFF10B981);
                optText = const Color(0xFF065F46);
                optIcon = Icons.check_circle;
                optIconColor = const Color(0xFF10B981);
              } else if (isSelected && !isOptCorrect) {
                optBg = const Color(0xFFFEF2F2);
                optBorder = const Color(0xFFEF4444);
                optText = const Color(0xFF991B1B);
                optIcon = Icons.cancel;
                optIconColor = const Color(0xFFEF4444);
              }

              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: optBg,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: optBorder, width: isSelected || isOptCorrect ? 1.5 : 1),
                ),
                child: Row(
                  children: [
                    if (optIcon != null) ...[
                      Icon(optIcon, size: 18.sp, color: optIconColor),
                      8.sbW,
                    ],
                    Expanded(
                      child: AppText(
                        option.body ?? '',
                        size: 14.sp,
                        weight: isSelected || isOptCorrect ? FontWeight.w600 : FontWeight.w500,
                        color: optText,
                      ),
                    ),
                    if (option.imageUrl != null && option.imageUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: Image.network(
                          option.imageUrl!,
                          width: 40.r,
                          height: 40.r,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),

          // Explanation box
          if (question.explanation != null && question.explanation!.isNotEmpty) ...[
            8.sbH,
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb_outline, size: 18.sp, color: const Color(0xFF2563EB)),
                  8.sbW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          'توضيح المدرس للإجابة:',
                          size: 12.sp,
                          weight: FontWeight.w700,
                          color: const Color(0xFF1E40AF),
                        ),
                        4.sbH,
                        AppText(
                          question.explanation!,
                          size: 13.sp,
                          color: const Color(0xFF1E3A8A),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
