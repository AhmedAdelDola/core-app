import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../../../../../../../models/home_entities/files/course_attachment.dart';

class CourseFilesCard extends StatelessWidget {
  final CourseAttachmentData model;
  const CourseFilesCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600 && screenWidth < 900;
    final bool isDesktop = screenWidth >= 900;
    final bool isLargeScreen = isTablet || isDesktop;

    return Container(
      width: isLargeScreen ? (isDesktop ? 250 : 240) : 230.w,
      height: isLargeScreen ? 90 : 80.h,
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(isLargeScreen ? 12 : 12.r),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isLargeScreen ? 10 : 6,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: isLargeScreen ? (isDesktop ? 26 : 24) : null,
            ),
            SizedBox(width: isLargeScreen ? (isDesktop ? 14 : 12) : 0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isLargeScreen ? 8 : 12,
                      vertical: isLargeScreen ? 6 : 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          model.name ?? '',
                          size: isLargeScreen ? (isDesktop ? 15 : 14) : 16.sp,
                          weight: w700,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.textColor,
                        ),
                        SizedBox(height: isLargeScreen ? 6 : 8.h),
                        AppText(
                          model.attachmentCount.toString() ?? '',
                          size: isLargeScreen ? (isDesktop ? 13 : 12) : 14.sp,
                          weight: w400,
                          color: AppColors.textColor4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
