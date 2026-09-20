import 'package:cached_network_image/cached_network_image.dart';
import 'package:elhanbly/core/theme/theme.dart';
import 'package:elhanbly/models/home_entities/courses/get_course_data_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../../../../../../../core/consts/images.dart';
import '../../../../../../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../../../../../core/widgets/app_texts/text_scroll.dart';
import '../../../../../../../../../../core/widgets/network_img.dart';
import '../../../../../../../../../../core/widgets/purchase_modal/course_purchase_modal.dart';
import '../../../../../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../../../../lessons_section/widgets/lesson_screen.dart';
import '../../../../../../lessons_section/widgets/session_screen.dart';
import '../../../../../../lessons_section/widgets/sheet_screen.dart';

class LessonCard extends StatelessWidget {
  final Session? model;
  final VoidCallback? onPurchased;
  const LessonCard({super.key, required this.model, this.onPurchased});

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    final bool isLocked = model?.canAccess == false;

    return InkWell(
      onTap: () {
        if (isLocked) {
          CoursePurchaseModal.show(
            context: context,
            type: PurchaseTargetType.session,
            id: model?.id?.toString() ?? '0',
            title: model?.title ?? '',
            price: model?.price ?? model?.singleSessionPrice ?? '0',
            onSuccess: () {
              model?.canAccess = true;
              onPurchased?.call();
            },
          );
          return;
        }

        if (model?.isPublished != 0) {
          // Attachment
          switch (model?.type) {
            case 'pdf':
              NamedNavigatorImpl.push(LessonDetailsScreen(
                id: model?.id ?? 0,
                title: model?.title ?? '',
                subTitle: model?.type ?? '',
              ));
              break;
            case 'Homework':
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
                        child: CircleAvatar(
                          backgroundColor: isLocked ? Colors.grey.shade400 : AppColors.kPrimary,
                          radius: 20,
                          child: isLocked
                              ? const Icon(Icons.lock_rounded, color: AppColors.kWhite, size: 22)
                              : SvgPicture.asset(AppImages.playVideoSvg, color: AppColors.kWhite, width: 25),
                        ),
                            
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
                            // Flexible(
                            //   child: AppText(
                            //     model?.type ?? '',
                            //     size: 14.sp,
                            //     color: AppColors.textColor2,
                            //   ),
                            // ),
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
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: isLocked ? Colors.grey.shade400 : AppColors.kPrimary,
                        child: isLocked
                            ? const Icon(Icons.lock_rounded, color: AppColors.kWhite, size: 26)
                            : SvgPicture.asset(AppImages.playVideoSvg, color: AppColors.kWhite, width: 40),
                      ),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: AppText(
                                model?.title ?? '',
                                style: TextStyles.textViewMedium(),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isLocked)
                                  Container(
                                    margin: EdgeInsets.only(left: 4.w),
                                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade50,
                                      borderRadius: BorderRadius.circular(6.r),
                                      border: Border.all(color: Colors.amber.shade400),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.lock_outline_rounded, size: 10.sp, color: Colors.amber.shade900),
                                        2.sbW,
                                        AppText(
                                          (model?.price != null && model?.price != '0')
                                              ? '${model?.price} ج.م'
                                              : 'مقفلة',
                                          size: 9.sp,
                                          color: Colors.amber.shade900,
                                          weight: w600,
                                        ),
                                      ],
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
                          ],
                        ),
                        // 6.sbH,
                       
                        if (model?.type != 'Attachment') ...[
                          // 8.sbH,
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
