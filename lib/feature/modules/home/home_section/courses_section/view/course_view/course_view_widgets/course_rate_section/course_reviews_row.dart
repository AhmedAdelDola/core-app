import '../../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../../core/widgets/app_texts/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseReviewsRow extends StatelessWidget {
  final String title, userNumber;
  final double percentage;

  const CourseReviewsRow({
    super.key,
    required this.title,
    required this.percentage,
    required this.userNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 70.w,
            child: AppText(
              userNumber,
              size: 15.sp,
              weight: w500,
              align: TextAlign.start,
              color: AppColors.textColor2,
            ),
          ),
          Container(
            height: 8.h,
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
              color: AppColors.kPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              widthFactor: double.parse(percentage.toString()) / 100,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.kPrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 70.w,
            child: AppText(
              title,
              size: 15.sp,
              weight: w500,
              align: TextAlign.end,
              color: AppColors.textColor2,
            ),
          ),
        ],
      ),
    );
  }
}
