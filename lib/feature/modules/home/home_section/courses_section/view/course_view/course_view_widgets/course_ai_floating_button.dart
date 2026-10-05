import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../core/widgets/app_texts/app_text.dart';

class CourseAiFloatingButton extends StatelessWidget {
  final VoidCallback onTap;

  const CourseAiFloatingButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.kPrimary,
                AppColors.kPrimary.withValues(alpha: 0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.kPrimary.withValues(alpha: 0.35),
                blurRadius: 14,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '✨',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              SizedBox(width: 8.w),
              AppText(
                'المساعد الذكي',
                color: AppColors.kWhite,
                weight: w700,
                size: 13.5.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
