import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/widgets/app_texts/app_text.dart';

class QuestionPalette extends StatelessWidget {
  final int totalQuestions;
  final int currentIndex;
  final Function(int) onSelectQuestion;
  final bool Function(int) isAnswered;
  final bool Function(int) isFlagged;

  const QuestionPalette({
    super.key,
    required this.totalQuestions,
    required this.currentIndex,
    required this.onSelectQuestion,
    required this.isAnswered,
    required this.isFlagged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalQuestions <= 0) return const SizedBox.shrink();

    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: totalQuestions,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final bool isCurrent = index == currentIndex;
          final bool answered = isAnswered(index);
          final bool flagged = isFlagged(index);

          Color bgColor = const Color(0xFFF8FAFC);
          Color borderColor = const Color(0xFFCBD5E1);
          Color textColor = AppColors.textColor;

          if (isCurrent) {
            bgColor = AppColors.kPrimary;
            borderColor = AppColors.kPrimary;
            textColor = AppColors.kWhite;
          } else if (flagged) {
            bgColor = const Color(0xFFFFFBEB);
            borderColor = const Color(0xFFF59E0B);
            textColor = const Color(0xFFD97706);
          } else if (answered) {
            bgColor = const Color(0xFFECFDF5);
            borderColor = const Color(0xFF10B981);
            textColor = const Color(0xFF059669);
          }

          return GestureDetector(
            onTap: () => onSelectQuestion(index),
            child: Container(
              width: 42.w,
              height: 42.h,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: isCurrent ? 2 : 1.5),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: AppColors.kPrimary.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AppText(
                    '${index + 1}',
                    size: 14.sp,
                    weight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                    color: textColor,
                  ),
                  if (flagged && !isCurrent)
                    Positioned(
                      top: 4.h,
                      right: 4.w,
                      child: Container(
                        width: 7.r,
                        height: 7.r,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF59E0B),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
