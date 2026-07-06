import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../../../../../core/widgets/ui_helpers/extensions.dart';

class LessonProfileItem extends StatelessWidget {
  final String title, subTitle;
  final String? icon;
  final Icon? icons;

  LessonProfileItem(
      {super.key,
      required this.title,
      required this.subTitle,
      this.icon,
      this.icons});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: AppColors.kPrimary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.all(5),
          child:
              icons ?? SvgPicture.asset(icon ?? '', height: 24.h, width: 24.w),
        ),
        5.sbW,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title,
              size: 16.sp,
              align: TextAlign.start,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              weight: w400,
              color: AppColors.textColor2,
            ),
            AppText(
              subTitle,
              size: 16.sp,
              align: TextAlign.start,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              weight: w400,
              color: AppColors.textColor2,
            ),
          ],
        ),
      ],
    );
  }
}
