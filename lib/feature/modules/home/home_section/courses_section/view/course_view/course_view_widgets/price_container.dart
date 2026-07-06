import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../core/widgets/app_texts/app_text.dart';

class PriceContainer extends StatelessWidget {
  final String title;

  const PriceContainer({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: AppColors.kPrimary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: AppText(
        title,
        color: AppColors.kWhite,
        size: 14.sp,
        weight: w700,
      ),
    );
  }
}
