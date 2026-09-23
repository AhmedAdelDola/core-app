import 'package:elhanbly/models/home_entities/home/get_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/consts/images.dart';
import '../../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../core/util/responsive/responsive_helper.dart';
import '../../../../../../core/widgets/ui_helpers/extensions.dart';
import 'session_screen.dart';

class RecommendedLessonsCard extends StatelessWidget {
  final SuggestedSession? model;
  final bool inGrid;
  final double? width;

  const RecommendedLessonsCard({
    super.key,
    required this.model,
    this.inGrid = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTablet = AppResponsive.isTablet(context);
    final bool isMobileLandscape = AppResponsive.isMobileLandscape(context);
    final bool isLargeScreen = AppResponsive.isTabletOrLarger(context);
    final bool isDesktop = AppResponsive.isDesktop(context);

    return InkWell(
      onTap: () => NamedNavigatorImpl.push(
        SessionDetilesScreen(
          id: model?.id ?? 0,
          title: model?.title ?? '',
          subTitle: model?.course?.title ?? '',
        ),
      ),
      child: Container(
        width: inGrid
            ? double.infinity
            : (width ??
                (isDesktop
                    ? 230.0
                    : (isTablet
                        ? 210.0
                        : (isMobileLandscape ? 175.0 : 190.w)))),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(isLargeScreen ? 14 : 14.r),
          border: Border.all(
            color: AppColors.borderColor.withOpacity(0.6),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isLargeScreen ? 14 : 14.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(AppImages.playStore, fit: BoxFit.cover),
                  ),
                  Positioned(
                    bottom: isMobileLandscape ? 4.0 : 8.h,
                    left: isMobileLandscape ? 4.0 : 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobileLandscape ? 5.0 : 8.w,
                        vertical: isMobileLandscape ? 2.0 : 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            size: isMobileLandscape ? 11.0 : (isLargeScreen ? 14 : 14.sp),
                            color: Colors.white,
                          ),
                          3.sbW,
                          AppText(
                            'فيديو',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobileLandscape ? 9.sp : (isLargeScreen ? 11 : 11.sp),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobileLandscape ? 8.0 : (isLargeScreen ? 12 : 10.w),
                  vertical: isMobileLandscape ? 5.0 : (isLargeScreen ? 10 : 8.h),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      model?.title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.textViewBold(
                        size: isMobileLandscape ? 13.sp : (isLargeScreen ? (isDesktop ? 15 : 14) : 15.sp),
                        color: AppColors.textColor,
                      ),
                    ),
                    (isMobileLandscape ? 3.0 : 6.0).sbH,
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: isMobileLandscape ? 12.0 : (isLargeScreen ? 14 : 14.sp),
                          color: AppColors.textColor5,
                        ),
                        6.sbW,
                        Expanded(
                          child: AppText(
                            model?.course?.title ?? '',
                            maxLines: 1,
                            size: isMobileLandscape ? 11.sp : (isLargeScreen ? (isDesktop ? 13 : 12) : 12.sp),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.textViewRegular(
                              color: AppColors.textColor5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
