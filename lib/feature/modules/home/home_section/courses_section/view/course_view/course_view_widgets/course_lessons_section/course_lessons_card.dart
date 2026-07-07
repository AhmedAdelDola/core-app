import 'package:elhanbly/models/home_entities/courses/get_course_data_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../../../../../core/services/di.dart';
import '../../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../../../../core/widgets/app_texts/text_scroll.dart';
import '../../../../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../../cubit/courses_section_cubit.dart';
import 'lesson_profile/lesson_profile.dart';

class CourseLessonsCard extends StatelessWidget {
  final void Function() onTap;
  final String name, description;
  final int courseIndex;
  final List<Chapter>? model;
  final bool isExpanded; // Add this

  const CourseLessonsCard({
    super.key,
    required this.onTap,
    required this.name,
    required this.description,
    required this.courseIndex,
    required this.model,
    required this.isExpanded, // Accept expansion state
  });

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isTablet ? 300.w : MediaQuery.of(context).size.width * 3 / 4,
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppText(
                    name,
                    size: 18.sp,
                    weight: w500,
                    overflow: TextOverflow.ellipsis,
                    align: TextAlign.start,
                    color: AppColors.textColor,
                  ),
                ),
                IconButton(
                  onPressed: onTap,
                  icon: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
            AppTextScroll(
              description,
              size: 14.sp,
              weight: w400,
              align: TextAlign.end,
              color: AppColors.textColor2,
            ),
            8.sbH,
            if (isExpanded) ...[
              ...List.generate(
                model?[courseIndex].lessons?.length ?? 0,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      NamedNavigatorImpl.push(
                        LessonProfile(
                          lesson: model![courseIndex].lessons![index],
                          title2: model![courseIndex].title ?? '',
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.kWhite,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 4.h),
                      padding: EdgeInsets.symmetric(horizontal: 6.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppTextScroll(
                              align: TextAlign.right,
                              model?[courseIndex].lessons?[index].title ?? '',
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              NamedNavigatorImpl.push(
                                LessonProfile(
                                  lesson: model![courseIndex].lessons![index],
                                  title2: model![courseIndex].title ?? '',
                                ),
                              );
                            },
                            icon: const Icon(Icons.keyboard_arrow_left_rounded),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
