import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';

import '../../../../../../../../core/consts/strings.dart';
import '../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../core/theme/theme.dart';
import '../../../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../../../core/widgets/loader/app_loader.dart';
import '../../../../../../../../core/widgets/ui_helpers/app_rating_bar.dart';
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
       // final courseRate = cubit.courseRateReview?.data;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              23.sbH,
              state is GetCourseRateReviewLoadingState
                  ? const AppLoader():
                  // : Row(
                  //     children: [
                  //       AppRatingBar(
                  //         size: 20,
                  //         initialRating:
                  //             double.tryParse('${courseRate?.rate ?? 0.0}'),
                  //         onRatingUpdate: null,
                  //       ),
                  //       8.sbW,
                  //       AppText(
                  //         '${courseRate?.rate.toDouble() ?? 0.0} (${courseRate?.numberOfReviews ?? 0.0})',
                  //         textDirection: TextDirection.ltr,
                  //         style: TextStyles.textViewMedium(
                  //             color: AppColors.textColor5),
                  //       ),
                  //     ],
                  //   ),
              AppText(
                model?.course?.title ?? '',
                color: AppColors.textColor,
                size: 24.sp,
                weight: FontWeight.bold,
                centerText: false,
              ),
              10.sbH,
              CourseInstructor(
                avatar:
                    model?.course?.teacher?.imageUrl ?? '',
                name: model?.course?.teacher?.name ?? '',
                ),
              10.sbH,
              ReadMoreText(
                '${model?.course?.description ?? 0}',
                trimMode: TrimMode.Line,
                trimLines: 2,
                colorClickableText: AppColors.textColor2,
                trimCollapsedText: 'عرض المزيد',
                trimExpandedText: 'عرض أقل',
                textAlign: TextAlign.start,
                moreStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor2,
                  fontFamily: fontFamilyDINNextLT,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
