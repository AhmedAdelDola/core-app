import 'package:elhanbly/models/home_entities/home/get_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/consts/images.dart';
import '../../../../../../core/consts/strings.dart';
import '../../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../core/widgets/app_texts/text_scroll.dart';
import '../../../../../../core/widgets/network_img.dart';
import '../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../../../../models/home_entities/lessons/get_lessons_response.dart';
import 'lesson_screen.dart';
import 'session_screen.dart';

class RecommendedLessonsCard extends StatelessWidget {
  final SuggestedSession? model;

  const RecommendedLessonsCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1000;
    final bool isDesktop = screenWidth >= 1000;
    final bool isLargeScreen = isTablet || isDesktop;

    return InkWell(
      onTap: () => NamedNavigatorImpl.push(SessionDetilesScreen(
        id: model?.id ?? 0,
        title: model?.title ?? '',
        subTitle: model?.course?.title ?? '',
      )),
      child: Container(
        width: isLargeScreen ? 200.w : 190.w,
        height: isLargeScreen ? 280.h : 180.h,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isLargeScreen ? 12 : 12.r),
        ),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isLargeScreen ? 12 : 12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isLargeScreen ? 12 : 12.r),
                  topRight: Radius.circular(isLargeScreen ? 12 : 12.r),
                ),
                child: SizedBox(
                  width: isLargeScreen ? 200 : 180.w,
                  height: isLargeScreen ? 150 : 170.h,
                  child: Image.asset(AppImages.playStore, fit: BoxFit.cover)
                     
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(isLargeScreen ? 12 : 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isLargeScreen
                              ? AppTextScroll(
                                  model?.title ?? '',
                                  size: isDesktop ? 15 : 14,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  color: AppColors.textColor,
                                  centerText: false,
                                )
                              : AppTextScroll(
                                  model?.title ?? '',
                                  size: 18.sp,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  color: AppColors.textColor,
                                  centerText: false,
                                ),
                          SizedBox(height: isLargeScreen ? 6 : 5.h),
                          isLargeScreen
                              ? AppText(
                                  model?.course?.title ?? '',
                                  size: isDesktop ? 13 : 12,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  color: AppColors.textColor,
                                  centerText: false,
                                )
                              : AppTextScroll(
                                  model?.course?.title ?? '',
                                  size: 18.sp,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  color: AppColors.textColor,
                                  centerText: false,
                                ),
                        ],
                      ),
                      SizedBox(height: isLargeScreen ? 8 : 5.h),

                      // Row(
                      //   children: [
                      //     NetworkImagesWidgets(
                      //       url: model.lesson..?.avatar ?? '',
                      //       height: isLargeScreen ? 24 : 22.h,
                      //       width: isLargeScreen ? 24 : 22.w,
                      //     ),
                      //     SizedBox(width: isLargeScreen ? 8 : 8.w),
                      //     Expanded(
                      //       child: isLargeScreen
                      //           ? AppText(
                      //               model.teacher?.name ?? '',
                      //               maxLines: 1,
                      //               size: isDesktop ? 12 : 11,
                      //               overflow: TextOverflow.ellipsis,
                      //               style: TextStyles.textViewMedium(
                      //                   color: AppColors.textColor5),
                      //             )
                      //           : AppTextScroll(
                      //               model.teacher?.name ?? '',
                      //               maxLines: 1,
                      //               overflow: TextOverflow.ellipsis,
                      //               style: TextStyles.textViewMedium(
                      //                   color: AppColors.textColor5),
                      //             ),
                      //     ),
                      //   ],
                      // ),
                    
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
