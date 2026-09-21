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
            : (width ?? (isLargeScreen ? 230 : 190.w)),
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
                    bottom: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
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
                            size: isLargeScreen ? 14 : 14.sp,
                            color: Colors.white,
                          ),
                          3.sbW,
                          AppText(
                            'فيديو',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isLargeScreen ? 11 : 11.sp,
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
                  horizontal: isLargeScreen ? 12 : 10.w,
                  vertical: isLargeScreen ? 10 : 8.h,
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
                        size: isLargeScreen ? (isDesktop ? 15 : 14) : 15.sp,
                        color: AppColors.textColor,
                      ),
                    ),
                    6.sbH,
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: isLargeScreen ? 14 : 14.sp,
                          color: AppColors.textColor5,
                        ),
                        6.sbW,
                        Expanded(
                          child: AppText(
                            model?.course?.title ?? '',
                            maxLines: 1,
                            size: isLargeScreen ? (isDesktop ? 13 : 12) : 12.sp,
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
