import 'package:elhanbly/core/consts/strings.dart';
import 'package:elhanbly/models/home_entities/home/get_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../core/widgets/network_img.dart';
import '../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../../../../core/local/cache_helper.dart';
import '../../../../../../core/local/enum_init.dart';
import '../../../../../../core/navigator/named_navigator_routes.dart';
import '../../../../../../core/services/di.dart';
import '../../../../../../core/widgets/app_buttons/master_button.dart';
import '../view/course_view/course_view.dart';
import 'floating_text_on_img.dart';

class CourseCardItem extends StatelessWidget {
  final RecommendedCourse? model;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const CourseCardItem({
    super.key,
    required this.model,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1200;
    final bool isDesktop = screenWidth >= 1200;
    final bool isLargeScreen = isTablet || isDesktop;

    return InkWell(
      onTap:
          onTap ??
          () {
            bool isLogged =
                di<CacheHelper>().getBool(CachingKey.isLogged);
            if (isLogged) {
              NamedNavigatorImpl.push(
                CourseViewScreen(id: "${model?.id ?? 0}"),
              );
            } else {
              showDialog(
                context: context,
                builder: (dialogContext) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(
                          'تنبيه',
                          style: TextStyles.textViewBold(
                            size: 18.sp,
                            color: AppColors.kPrimary,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        AppText(
                          'يرجى تسجيل الدخول أولاً لتتمكن من تصفح هذه الدورة.',
                          style: TextStyles.textViewMedium(
                            fontSize: 14.sp,
                            color: AppColors.textColor,
                          ),
                          align: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(),
                                child: AppText(
                                  'إلغاء',
                                  style: TextStyles.textViewMedium(
                                    fontSize: 14.sp,
                                    color: AppColors.textColor5,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: MasterButton(
                                height: 40.h,
                                padding: EdgeInsets.zero,
                                buttonRadius: 8.r,
                                text: 'تسجيل الدخول',
                                textStyle: TextStyles.textViewMedium(
                                  fontSize: 14.sp,
                                  color: AppColors.kWhite,
                                ),
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                  NamedNavigatorImpl.pushNamed(Routes.login);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
      child: Container(
        width:
            width ??
            (isLargeScreen ? 230 : MediaQuery.of(context).size.width * 0.44),
        height: height,
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
              FloatingTextOnImg(img: model?.imageUrl ?? '', isFree: 0),
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: NetworkImagesWidgets(
                            url:
                                model?.teacher?.imageUrl ??
                                Strings.placeHolderImg,
                            height: isLargeScreen
                                ? (isDesktop ? 24 : 22)
                                : 24.h,
                            width: isLargeScreen
                                ? (isDesktop ? 24 : 22)
                                : 24.w,
                          ),
                        ),
                        8.sbW,
                        Expanded(
                          child: AppText(
                            align: TextAlign.start,
                            model?.teacher?.name ?? '',
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
