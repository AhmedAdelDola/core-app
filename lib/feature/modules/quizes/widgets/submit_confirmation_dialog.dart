import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/widgets/app_texts/app_text.dart';
import '../../../../core/widgets/ui_helpers/extensions.dart';

class SubmitConfirmationDialog extends StatelessWidget {
  final int totalQuestions;
  final int answeredCount;
  final int unansweredCount;
  final int flaggedCount;
  final VoidCallback onConfirm;

  const SubmitConfirmationDialog({
    super.key,
    required this.totalQuestions,
    required this.answeredCount,
    required this.unansweredCount,
    required this.flaggedCount,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      backgroundColor: AppColors.kWhite,
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 56.r,
              height: 56.r,
              decoration: BoxDecoration(
                color: unansweredCount > 0
                    ? const Color(0xFFFEF3C7)
                    : const Color(0xFFECFDF5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                unansweredCount > 0
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_outline,
                size: 32.sp,
                color: unansweredCount > 0
                    ? const Color(0xFFD97706)
                    : const Color(0xFF10B981),
              ),
            ),
            16.sbH,

            // Title
            AppText(
              'تأكيد إنهاء وتسليم الامتحان',
              size: 18.sp,
              weight: FontWeight.w700,
              color: AppColors.textColor,
            ),
            8.sbH,

            // Description
            AppText(
              'هل أنت متأكد من رغبتك في إنهاء الامتحان وتسليم الإجابات؟',
              size: 14.sp,
              color: AppColors.textColor2,
              align: TextAlign.center,
            ),
            16.sbH,

            // Summary Stats Card
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _statRow('إجمالي الأسئلة', '$totalQuestions', AppColors.textColor),
                  8.sbH,
                  _statRow('الأسئلة التي تم حلها', '$answeredCount', const Color(0xFF10B981)),
                  if (unansweredCount > 0) ...[
                    8.sbH,
                    _statRow('أسئلة لم يتم حلها', '$unansweredCount', const Color(0xFFEF4444)),
                  ],
                  if (flaggedCount > 0) ...[
                    8.sbH,
                    _statRow('أسئلة مميزة للمراجعة 🚩', '$flaggedCount', const Color(0xFFF59E0B)),
                  ],
                ],
              ),
            ),
            20.sbH,

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: AppText(
                      'متابعة الحل',
                      size: 14.sp,
                      weight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                12.sbW,
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kPrimary,
                      foregroundColor: AppColors.kWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: AppText(
                      'تأكيد التسليم',
                      size: 14.sp,
                      weight: FontWeight.w700,
                      color: AppColors.kWhite,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          label,
          size: 13.sp,
          color: AppColors.textColor2,
          weight: FontWeight.w500,
        ),
        AppText(
          value,
          size: 14.sp,
          color: valueColor,
          weight: FontWeight.w700,
        ),
      ],
    );
  }
}
