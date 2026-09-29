import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_texts/app_text.dart';
import '../../../../core/widgets/ui_helpers/extensions.dart';

class NoResultsWidget extends StatelessWidget {
  final Color color;
  const NoResultsWidget({super.key, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.r,
              height: 100.r,
              decoration: BoxDecoration(
                color: AppColors.kPrimary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: 50.r,
                color: AppColors.kPrimary,
              ),
            ),
            20.sbH,
            AppText(
              'لا يوجد إشعارات حالياً',
              style: TextStyles.textViewBold(
                size: 16.sp,
                color: AppColors.textColor,
              ),
            ),
            8.sbH,
            AppText(
              'ستظهر هنا جميع الإشعارات والتنبيهات الخاصة بك',
              style: TextStyles.textViewRegular(
                fontSize: 13.sp,
                color: AppColors.hintColor,
              ),
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
