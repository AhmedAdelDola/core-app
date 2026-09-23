import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../consts/strings.dart';
import '../../../services/di.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../util/responsive/responsive_helper.dart';
import '../../app_texts/app_text.dart';
import '../../app_texts/text_scroll.dart';
import '../../network_img.dart';

class AppBarImageWidget extends StatelessWidget {
  const AppBarImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = AppResponsive.isTablet(context);
    final isMobileLandscape = AppResponsive.isMobileLandscape(context);
    final double avatarRadius = isTablet ? 20.0 : (isMobileLandscape ? 15.0 : 18.0);
    final double containerSize = isTablet ? 40.0 : (isMobileLandscape ? 30.0 : 36.0);

    return Padding(
      padding:
          EdgeInsetsDirectional.symmetric(horizontal: isTablet ? 2.w : 4.w),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.kPrimary),
        ),
        child: CircleAvatar(
          radius: avatarRadius,
          backgroundColor: AppColors.kWhite,
          child: CachedNetworkImage(
            imageUrl: userData?.student?.imageUrl ?? Strings.placeHolderImg,
            imageBuilder: (context, imageProvider) => Container(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            errorWidget: errorIconImage,
          ),
        ),
      ),
    );
  }
}

Widget get appBarNotifcationView {
  return Builder(builder: (context) {
    final isTablet = AppResponsive.isTablet(context);
    final isMobileLandscape = AppResponsive.isMobileLandscape(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          align: TextAlign.start,
          'الاشعارات',
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: isTablet ? 20.sp : (isMobileLandscape ? 16.sp : 22.sp),
            fontWeight: w500,
          ),
        ),
        if (!isMobileLandscape)
          AppText(
            align: TextAlign.start,
            'الاشعارات تحتوي علي جميع تديثات الاشياء التي اشتركت بها',
            style: TextStyle(
              color: AppColors.textColor2,
              fontSize: isTablet ? 12.sp : 14.sp,
              fontWeight: w400,
            ),
          )
      ],
    );
  });
}

Widget get appBarLibraryView {
  return Builder(builder: (context) {
    final isTablet = AppResponsive.isTablet(context);
    final isMobileLandscape = AppResponsive.isMobileLandscape(context);
    return Padding(
      padding: EdgeInsetsDirectional.only(top: isMobileLandscape ? 0 : 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            align: TextAlign.start,
            'المكتبة',
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: isTablet ? 22.sp : (isMobileLandscape ? 16.sp : 19.sp),
              fontWeight: w700,
            ),
          ),
          if (!isMobileLandscape) ...[
            SizedBox(height: 2.h),
            AppText(
              align: TextAlign.start,
              'المكتبة تحتوي علي جميع الاشياء التي اشتركت بها',
              style: TextStyle(
                color: AppColors.textColor4,
                fontSize: isTablet ? 13.sp : 11.5.sp,
                fontWeight: w400,
              ),
            ),
          ],
        ],
      ),
    );
  });
}

Widget get appBarTrainingView {
  return Builder(builder: (context) {
    final isTablet = AppResponsive.isTablet(context);
    final isMobileLandscape = AppResponsive.isMobileLandscape(context);
    return Padding(
      padding: EdgeInsetsDirectional.only(top: isMobileLandscape ? 0 : 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            align: TextAlign.start,
            'التدريبات',
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: isTablet ? 22.sp : (isMobileLandscape ? 16.sp : 19.sp),
              fontWeight: w700,
            ),
          ),
          if (!isMobileLandscape) ...[
            SizedBox(height: 2.h),
            AppText(
              align: TextAlign.start,
              'بعض الأسئلة التي تساعدك علي ممارسة المنهج',
              style: TextStyle(
                color: AppColors.textColor4,
                fontSize: isTablet ? 13.sp : 11.5.sp,
                fontWeight: w400,
              ),
            ),
          ],
        ],
      ),
    );
  });
}

Widget get appBarBodyView {
  return Builder(builder: (context) {
    final isTablet = AppResponsive.isTablet(context);
    final isMobileLandscape = AppResponsive.isMobileLandscape(context);
    return Padding(
      padding: EdgeInsetsDirectional.only(top: isMobileLandscape ? 0 : 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            align: TextAlign.start,
            userData?.student?.name ?? 'guest',
            style: TextStyles.textViewBold(
              color: AppColors.textColor,
              size: isTablet ? 20.sp : (isMobileLandscape ? 15.sp : 17.sp),
            ),
          ),
          if (!isMobileLandscape) ...[
            SizedBox(height: 2.h),
            AppText(
              align: TextAlign.start,
              '${userData?.student?.level?.stage?.name ?? ''} - ${userData?.student?.level?.name ?? ''}',
              color: AppColors.textColor4,
              size: isTablet ? 13.sp : 12.sp,
              weight: w400,
            ),
          ],
        ],
      ),
    );
  });
}
