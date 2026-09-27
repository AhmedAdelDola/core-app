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
import 'cubits/exam_attempt_cubit.dart';
import 'cubits/exam_attempt_state.dart';
import 'exam_result_screen.dart';
import 'widgets/question_palette.dart';
import 'widgets/submit_confirmation_dialog.dart';

class ExamAttemptScreen extends StatelessWidget {
  final dynamic examId;
  final dynamic attemptId;
  final String examTitle;

  const ExamAttemptScreen({
    super.key,
    required this.examId,
    this.attemptId,
    this.examTitle = 'الامتحان',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExamAttemptCubit>(
      create: (context) {
        final cubit = di<ExamAttemptCubit>();
        if (attemptId != null) {
          cubit.resumeAttempt(attemptId);
        } else {
          cubit.startExam(examId);
        }
        return cubit;
      },
      child: BlocConsumer<ExamAttemptCubit, ExamAttemptState>(
        listener: (context, state) {
          if (state.status == ExamSessionStatus.completed && state.resultData != null) {
            NamedNavigatorImpl.push(
              ExamResultScreen(
                attemptId: state.resultData!.attemptId ?? state.attemptData?.id ?? 0,
                examId: int.tryParse('$examId'),
                examTitle: examTitle,
              ),
              replace: true,
            );
          }
        },
        builder: (context, state) {
          final cubit = ExamAttemptCubit.of(context);

          return PopScope(
            canPop: state.status != ExamSessionStatus.inProgress,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              _showExitConfirmation(context, cubit, state);
            },
            child: Scaffold(
              backgroundColor: const Color(0xFFF8FAFC),
              appBar: AppBar(
                backgroundColor: AppColors.kWhite,
                elevation: 0.5,
                leading: IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textColor),
                  onPressed: () => _showExitConfirmation(context, cubit, state),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      examTitle,
                      size: 16.sp,
                      weight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                    if (state.status == ExamSessionStatus.inProgress && state.totalQuestions > 0)
                      AppText(
                        'السؤال ${state.currentQuestionIndex + 1} من ${state.totalQuestions}',
                        size: 12.sp,
                        color: AppColors.textColor2,
                      ),
                  ],
                ),
                actions: [
                  if (state.status == ExamSessionStatus.inProgress)
                    _buildTimerWidget(state.timeRemainingSeconds),
                ],
              ),
              body: _buildBody(context, cubit, state),
              bottomNavigationBar: state.status == ExamSessionStatus.inProgress
                  ? _buildBottomBar(context, cubit, state)
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ExamAttemptCubit cubit, ExamAttemptState state) {
    if (state.status == ExamSessionStatus.loading || state.status == ExamSessionStatus.submitting) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLoader(),
            16.sbH,
            AppText(
              state.status == ExamSessionStatus.submitting
                  ? 'جاري تسليم وتصحيح الامتحان...'
                  : 'جاري تحميل أسئلة الامتحان...',
              size: 14.sp,
              color: AppColors.textColor2,
            ),
          ],
        ),
      );
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
                state.errorMessage ?? 'حدث خطأ غير متوقع',
                size: 14.sp,
                color: AppColors.textColor2,
                align: TextAlign.center,
              ),
              16.sbH,
              ElevatedButton(
                onPressed: () {
                  if (attemptId != null) {
                    cubit.resumeAttempt(attemptId);
                  } else {
                    cubit.startExam(examId);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.kPrimary),
                child: AppText('إعادة المحاولة', color: AppColors.kWhite),
              ),
            ],
          ),
        ),
      );
    }

    final questions = state.attemptData?.questions ?? [];
    if (questions.isEmpty) {
      return const Center(child: AppText('لا توجد أسئلة في هذا الامتحان'));
    }

    final int currentIndex = state.currentQuestionIndex.clamp(0, questions.length - 1);
    final question = questions[currentIndex];
    final questionId = question.questionId ?? 0;
    final selectedOptionIds = state.selectedAnswers[questionId] ?? [];
    final isFlagged = state.isQuestionFlagged(questionId);

    return Column(
      children: [
        // Top Question Palette
        QuestionPalette(
          totalQuestions: questions.length,
          currentIndex: currentIndex,
          onSelectQuestion: (index) => cubit.goToQuestion(index),
          isAnswered: (index) {
            final qId = questions[index].questionId ?? 0;
            return state.isQuestionAnswered(qId);
          },
          isFlagged: (index) {
            final qId = questions[index].questionId ?? 0;
            return state.isQuestionFlagged(qId);
          },
        ),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),

        // Question Content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Header: Points & Flag Button
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
                        children: [
                          Icon(Icons.star_rounded, size: 16.sp, color: AppColors.kPrimary),
                          4.sbW,
                          AppText(
                            '${question.maxPoints ?? 1} درجات',
                            size: 13.sp,
                            weight: FontWeight.w600,
                            color: AppColors.kPrimary,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => cubit.toggleFlag(questionId),
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: isFlagged ? const Color(0xFFFFFBEB) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: isFlagged ? const Color(0xFFF59E0B) : const Color(0xFFCBD5E1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isFlagged ? Icons.flag : Icons.flag_outlined,
                              size: 16.sp,
                              color: isFlagged ? const Color(0xFFF59E0B) : AppColors.textColor4,
                            ),
                            4.sbW,
                            AppText(
                              isFlagged ? 'مميز للمراجعة' : 'تمييز للمراجعة',
                              size: 12.sp,
                              weight: FontWeight.w600,
                              color: isFlagged ? const Color(0xFFD97706) : AppColors.textColor2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                16.sbH,

                // Question Text
                HtmlWidget(
                  question.body ?? '',
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                    height: 1.5,
                  ),
                ),
                if (question.imageUrl != null && question.imageUrl!.isNotEmpty) ...[
                  12.sbH,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      question.imageUrl!,
                      fit: BoxFit.contain,
                      height: 200.h,
                      width: double.infinity,
                    ),
                  ),
                ],
                20.sbH,

                // Question Options
                Column(
                  children: (question.options ?? []).map((option) {
                    final optId = option.id ?? 0;
                    final isSelected = selectedOptionIds.contains(optId);
                    final isMultiple = question.questionType == 'multiple_choice';

                    return GestureDetector(
                      onTap: () {
                        cubit.selectOption(questionId, optId, question.questionType);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.kPrimary.withOpacity(0.08) : AppColors.kWhite,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isSelected ? AppColors.kPrimary : const Color(0xFFCBD5E1),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Radio or Checkbox icon
                            Container(
                              width: 22.r,
                              height: 22.r,
                              decoration: BoxDecoration(
                                shape: isMultiple ? BoxShape.rectangle : BoxShape.circle,
                                borderRadius: isMultiple ? BorderRadius.circular(4.r) : null,
                                color: isSelected ? AppColors.kPrimary : Colors.transparent,
                                border: Border.all(
                                  color: isSelected ? AppColors.kPrimary : const Color(0xFF94A3B8),
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Icon(
                                      isMultiple ? Icons.check : Icons.circle,
                                      size: isMultiple ? 14.sp : 8.sp,
                                      color: AppColors.kWhite,
                                    )
                                  : null,
                            ),
                            12.sbW,
                            Expanded(
                              child: AppText(
                                option.body ?? '',
                                size: 14.sp,
                                weight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected ? AppColors.textColor : AppColors.textColor5,
                              ),
                            ),
                            if (option.imageUrl != null && option.imageUrl!.isNotEmpty) ...[
                              8.sbW,
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6.r),
                                child: Image.network(
                                  option.imageUrl!,
                                  width: 48.r,
                                  height: 48.r,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimerWidget(int remainingSeconds) {
    final int minutes = remainingSeconds ~/ 60;
    final int seconds = remainingSeconds % 60;
    final String formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    Color timerColor = const Color(0xFF10B981);
    Color timerBg = const Color(0xFFECFDF5);
    if (remainingSeconds < 60) {
      timerColor = const Color(0xFFEF4444);
      timerBg = const Color(0xFFFEF2F2);
    } else if (remainingSeconds < 300) {
      timerColor = const Color(0xFFF59E0B);
      timerBg = const Color(0xFFFFFBEB);
    }

    return Container(
      margin: EdgeInsets.only(left: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: timerBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: timerColor.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 16.sp, color: timerColor),
          4.sbW,
          AppText(
            formattedTime,
            size: 13.sp,
            weight: FontWeight.w700,
            color: timerColor,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, ExamAttemptCubit cubit, ExamAttemptState state) {
    final bool isFirst = state.currentQuestionIndex == 0;
    final bool isLast = state.currentQuestionIndex == (state.totalQuestions - 1);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Previous button
            if (!isFirst)
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () => cubit.previousQuestion(),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_forward_ios, size: 14.sp, color: AppColors.textColor),
                      4.sbW,
                      AppText(
                        'السابق',
                        size: 14.sp,
                        weight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ],
                  ),
                ),
              ),
            if (!isFirst) 10.sbW,

            // Next button
            if (!isLast)
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => cubit.nextQuestion(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimary,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        'التالي',
                        size: 14.sp,
                        weight: FontWeight.w700,
                        color: AppColors.kWhite,
                      ),
                      4.sbW,
                      Icon(Icons.arrow_back_ios, size: 14.sp, color: AppColors.kWhite),
                    ],
                  ),
                ),
              ),

            // Submit Button
            if (isLast)
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => _openSubmitDialog(context, cubit, state),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, size: 18.sp, color: AppColors.kWhite),
                      6.sbW,
                      AppText(
                        'إنهاء وتسليم الامتحان',
                        size: 14.sp,
                        weight: FontWeight.w700,
                        color: AppColors.kWhite,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openSubmitDialog(BuildContext context, ExamAttemptCubit cubit, ExamAttemptState state) {
    showDialog(
      context: context,
      builder: (dialogContext) => SubmitConfirmationDialog(
        totalQuestions: state.totalQuestions,
        answeredCount: state.answeredQuestionsCount,
        unansweredCount: state.unansweredQuestionsCount,
        flaggedCount: state.flaggedQuestionsCount,
        onConfirm: () => cubit.submitExam(),
      ),
    );
  }

  void _showExitConfirmation(BuildContext context, ExamAttemptCubit cubit, ExamAttemptState state) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: AppText(
          'مغادرة الامتحان؟',
          size: 17.sp,
          weight: FontWeight.w700,
          color: AppColors.textColor,
        ),
        content: AppText(
          'يمكنك العودة لاحقاً واستكمال الامتحان طالما أن وقت الامتحان لم ينتهِ بعد.',
          size: 14.sp,
          color: AppColors.textColor2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: AppText('البقاء في الامتحان', color: AppColors.textColor),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              elevation: 0,
            ),
            child: AppText('مغادرة', color: AppColors.kWhite),
          ),
        ],
      ),
    );
  }
}
