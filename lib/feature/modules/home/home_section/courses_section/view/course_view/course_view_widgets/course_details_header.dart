import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';

import '../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../core/theme/theme.dart';
import '../../../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../../../core/widgets/loader/app_loader.dart';
import '../../../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../cubit/courses_section_cubit.dart';
import 'course_details_instructor.dart';

class CourseHeader extends StatelessWidget {
  const CourseHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesSectionCubit, CoursesSectionState>(
      builder: (context, state) {
        final cubit = CoursesSectionCubit.of(context);
        final model = cubit.courseData;
        final description = model?.course?.description?.trim();
        final hasDescription = description != null && description.isNotEmpty && description != '0';

        if (state is GetCourseRateReviewLoadingState) {
          return const AppLoader();
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.sbH,
              AppText(
                model?.course?.title ?? '',
                color: AppColors.textColor,
                size: 22.sp,
                weight: FontWeight.bold,
                align: TextAlign.start,
              ),
              if (model?.course?.stage?.name != null || model?.course?.level?.name != null) ...[
                10.sbH,
                Wrap(
                  spacing: 8.w,
                  runSpacing: 6.h,
                  children: [
                    if (model?.course?.stage?.name != null)
                      _buildChip(model!.course!.stage!.name!, AppColors.kPrimary.withOpacity(0.1), AppColors.kPrimary),
                    if (model?.course?.level?.name != null)
                      _buildChip(model!.course!.level!.name!, Colors.grey.shade100, AppColors.textColor2),
                  ],
                ),
              ],
              if (model?.course?.teacher != null) ...[
                12.sbH,
                CourseInstructor(
                  avatar: model?.course?.teacher?.imageUrl ?? '',
                  name: model?.course?.teacher?.name ?? '',
                ),
              ],
              if (hasDescription) ...[
                12.sbH,
                AppText(
                  'عن الكورس',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                6.sbH,
                ReadMoreText(
                  description,
                  trimMode: TrimMode.Line,
                  trimLines: 3,
                  colorClickableText: AppColors.kPrimary,
                  trimCollapsedText: 'عرض المزيد',
                  trimExpandedText: 'عرض أقل',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor2,
                    height: 1.5,
                  ),
                  moreStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kPrimary,
                  ),
                  lessStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kPrimary,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip(String label, Color bg, Color textCol) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          color: textCol,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
