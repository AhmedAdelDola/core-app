import 'package:elhanbly/core/consts/images.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../../../../core/consts/strings.dart';
import '../../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../../../../core/widgets/ui_helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../course_view_widgets/course_rate_section/course_comments_section.dart';

class AboutCourseTab extends StatelessWidget {
  const AboutCourseTab({super.key, required this.Description});
  final String? Description;
  @override
  Widget build(BuildContext context) {
    if (Description == ''){
      return LottieBuilder.asset(AppJsonFiles.emptyState);
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppText(
                    'عن الكورس',
                    weight: w700,
                    size: 16.sp,
                    color: AppColors.textColor,
                  ),
                ],
              ),
              19.sbH,
              AppText(
                Description ?? 'لا يوجد وصف للكورس',
                size: 16.sp,
                align: TextAlign.start,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                weight: FontWeight.w400,
                color: AppColors.textColor2,
              ),
              32.sbH,
              // const CourseInstructor(),
            ],
          ),
        ),
        10.sbH,
        // const CourseComments(),
      ],
    );
  }
}
