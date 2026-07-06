import 'package:cached_network_image/cached_network_image.dart';
import 'package:elhanbly/models/home_entities/courses/get_course_data_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../../../../../../../core/consts/images.dart';
import '../../../../../../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../../../../../core/widgets/app_texts/text_scroll.dart';
import '../../../../../../../../../../core/widgets/network_img.dart';
import '../../../../../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../../../../lessons_section/widgets/lesson_screen.dart';
import '../../../../../../lessons_section/widgets/session_screen.dart';
import '../../../../../../lessons_section/widgets/sheet_screen.dart';

class LessonCard extends StatelessWidget {
  final Session? model;
  const LessonCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return InkWell(
      onTap: () {
        if (
            model?.isPublished != 0 ||
            model?.isPublished != 0) {
          // Attachment
          switch (model?.type) {
            case 'Attachment':
              // NamedNavigatorImpl.push(LessonDetailsScreen(
              //   id: model?.id ?? 0,
              //   title: model?.title ?? '',
              //   subTitle: model?.type ?? '',
              // ));
              break;
            // case 'Sheet':
            //   NamedNavigatorImpl.push(SheetDetailsScreen(model?.id ?? 0));
            //   break;
            case 'Homework':
              //
              break;
            case 'recorded_video':
              NamedNavigatorImpl.push(SessionDetilesScreen(
                id: model?.id ?? 0,
                title: model?.title ?? '',
                subTitle: model?.type ?? '',
              ));
              break;
          }
        }
      },
      child: Container(
        width: double.infinity, // Changed: Use full width
        margin: EdgeInsets.symmetric(
            vertical: 8.h, horizontal: 4.w), // Added horizontal margin
        padding: EdgeInsets.all(12.w), // Added padding
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.textFieldBorderColor, width: 1),
        ),
        child: isTablet
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: 120.w, // Adjusted for tablets
                        height: 120.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                              color: AppColors.textFieldBorderColor, width: 1),
                        ),
                        child: Image.asset(AppImages.playStore, fit: BoxFit.fill)
                            
                      ),
                      // if (model?.isFree == 1)
                      //   Positioned(
                      //     bottom: 8.h,
                      //     child: Container(
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: 8.w, vertical: 4.h),
                      //       decoration: BoxDecoration(
                      //         color: AppColors.kPrimary,
                      //         borderRadius: BorderRadius.circular(8.r),
                      //         border: Border.all(color: AppColors.kPrimary),
                      //       ),
                      //       child: AppText(
                      //         'مجاني',
                      //         size: 12.sp,
                      //         color: AppColors.kWhite,
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                  16.sbW, // Increased spacing
                  Expanded(
                    // This will take remaining space
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: AppText(
                                model?.type ?? '',
                                size: 14.sp,
                                color: AppColors.textColor2,
                              ),
                            ),
                            if (model?.type != 'Attachment')
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: AppColors.kGreen.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: AppColors.kGreen.withOpacity(0.2),
                                  ),
                                ),
                                child: AppText(
                                  "${model?.durationMinutes ?? 0} دقيقة",
                                  size: 12.sp,
                                  color: AppColors.kGreen,
                                ),
                              ),
                          ],
                        ),
                        8.sbH,
                        AppTextScroll(
                          model?.title ?? '',
                          size: 16.sp,
                          weight: w500,
                        ),
                        16.sbH,
                        if (model?.type != 'Attachment') ...[
                          Row(
                            children: [
                              AppText(
                                'مستوي التقدم',
                                size: 14.sp,
                                color: AppColors.textColor2,
                                weight: w500,
                              ),
                              8.sbW,
                              AppText(
                                '${model?.progressPercent ?? 0}%',
                                size: 14.sp,
                                weight: w500,
                                color: AppColors.textColor2,
                              ),
                            ],
                          ),
                          8.sbH,
                          LinearPercentIndicator(
                            lineHeight: 4.h,
                            percent: (double.tryParse(
                                        model?.progressPercent.toString() ?? '0') ??
                                    0.0) /
                                100,
                            barRadius: Radius.circular(12.r),
                            isRTL: true,
                            progressColor: AppColors.kPrimary,
                            backgroundColor: AppColors.textFieldBorderColor,
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: 80.w, // Smaller for mobile
                        height: 80.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                              color: AppColors.textFieldBorderColor, width: 1),
                        ),
                        child:  Image.asset(AppImages.playStore, fit: BoxFit.fill)
                           
                      ),
                      // if (model?.isFree == 1)
                      //   Positioned(
                      //     bottom: 4.h,
                      //     child: Container(
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: 6.w, vertical: 2.h),
                      //       decoration: BoxDecoration(
                      //         color: AppColors.kPrimary,
                      //         borderRadius: BorderRadius.circular(6.r),
                      //         border: Border.all(color: AppColors.kPrimary),
                      //       ),
                      //       child: AppText(
                      //         'مجاني',
                      //         size: 10.sp,
                      //         color: AppColors.kWhite,
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                  12.sbW,
                  Expanded(
                    // This will take remaining space
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: AppText(
                                model?.type ?? '',
                                size: 12.sp,
                                color: AppColors.textColor2,
                              ),
                            ),
                            if (model?.type != 'Attachment')
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: AppColors.kGreen.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: AppColors.kGreen.withOpacity(0.2),
                                  ),
                                ),
                                child: AppText(
                                  '${model?.durationMinutes ?? 0} دقيقة',
                                  size: 10.sp,
                                  color: AppColors.kGreen,
                                ),
                              ),
                          ],
                        ),
                        6.sbH,
                        AppTextScroll(
                          model?.title ?? '',
                          size: 14.sp,
                          weight: w500,
                        ),
                        if (model?.type != 'Attachment') ...[
                          8.sbH,
                          Row(
                            children: [
                              AppText(
                                'مستوي التقدم',
                                size: 12.sp,
                                color: AppColors.textColor2,
                                weight: w500,
                              ),
                              const Spacer(),
                              AppText(
                                '${model?.progressPercent ?? 0}%',
                                size: 12.sp,
                                weight: w500,
                                color: AppColors.textColor2,
                              ),
                            ],
                          ),
                          4.sbH,
                          LinearPercentIndicator(
                            lineHeight: 3.h,
                            percent: (double.tryParse(
                                        model?.progressPercent.toString() ?? '0') ??
                                    0.0) /
                                100,
                            barRadius: Radius.circular(8.r),
                            isRTL: true,
                            progressColor: AppColors.kPrimary,
                            backgroundColor: AppColors.textFieldBorderColor,
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
