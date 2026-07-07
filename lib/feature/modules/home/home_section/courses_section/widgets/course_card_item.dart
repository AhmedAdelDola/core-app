import 'package:elhanbly/core/consts/strings.dart';
import 'package:elhanbly/models/home_entities/home/get_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../core/widgets/app_texts/text_scroll.dart';
import '../../../../../../core/widgets/network_img.dart';
import '../../../../../../core/widgets/ui_helpers/app_rating_bar.dart';
import '../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../view/course_view/course_view.dart';
import 'floating_text_on_img.dart';

class CourseCardItem extends StatelessWidget {
  final RecommendedCourse? model;

  const CourseCardItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1200;
    final bool isDesktop = screenWidth >= 1200;
    final bool isLargeScreen = isTablet || isDesktop;

    return InkWell(
      onTap: () => NamedNavigatorImpl.push(CourseViewScreen(id:  "${model?.id ?? 0}")),
      child: Container(
        width: isLargeScreen ? 220 : MediaQuery.of(context).size.width * 0.70,
        height: isLargeScreen ? 320 : 290.h,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isLargeScreen ? 12 : 12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FloatingTextOnImg(
                img: model?.imageUrl ?? '',
                isFree: 0,
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
                          // Row(
                          //   children: [
                          //     AppRatingBar(
                          //       size:
                          //           isLargeScreen ? (isDesktop ? 15 : 14) : 20,
                          //       initialRating: double.tryParse(
                          //           '${model?.?.rate ?? 0.0}'),
                          //       onRatingUpdate: null,
                          //     ),
                          //     SizedBox(width: isLargeScreen ? 6 : 8.w),
                          //     Flexible(
                          //       child: AppText(
                          //         '${model.rating?.rate ?? 0.0} (${model.rating?.raters ?? 0.0})',
                          //         textDirection: TextDirection.ltr,
                          //         size: isLargeScreen
                          //             ? (isDesktop ? 12 : 11)
                          //             : null,
                          //         style: TextStyles.textViewMedium(
                          //           color: AppColors.textColor5,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(height: isLargeScreen ? 8 : 5.h),
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
                        ],
                      ),
                      SizedBox(height: isLargeScreen ? 8 : 5.h),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(50),
                            child: NetworkImagesWidgets(
                              url: model?.teacher?.imageUrl ?? Strings.placeHolderImg,
                            
                              height:
                                  isLargeScreen ? (isDesktop ? 26 : 24) : 32.h,
                              width: isLargeScreen ? (isDesktop ? 26 : 24) : 32.w,
                              
                            ),
                          ),
                          SizedBox(width: isLargeScreen ? 8 : 8.w),
                          Expanded(
                            child: AppText(
                              align: TextAlign.start,
                              model?.teacher?.name ?? '',
                              maxLines: 1,
                              size:
                                  isLargeScreen ? (isDesktop ? 13 : 12) : null,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.textViewMedium(
                                  color: AppColors.textColor5),
                            ),
                          ),
                        ],
                      ),
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
