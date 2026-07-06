import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../consts/strings.dart';
import '../../../services/di.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../theme/theme.dart';
import '../../app_texts/app_text.dart';
import '../../app_texts/text_scroll.dart';
import '../../network_img.dart';

class AppBarImageWidget extends StatelessWidget {
  const AppBarImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final double avatarRadius = isTablet ? 16.r : 20.r;
    final double containerSize = isTablet ? 32.w : 40.w;

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
    final isTablet = MediaQuery.of(context).size.width >= 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          align: TextAlign.start,
          'الاشعارات',
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: isTablet ? 20.sp : 28.sp,
            fontWeight: w500,
          ),
        ),
        AppText(
          align: TextAlign.start,
          'الاشعارات تحتوي علي جميع تديثات الاشياء التي اشتركت بها',
          style: TextStyle(
            color: AppColors.textColor2,
            fontSize: isTablet ? 12.sp : 16.sp,
            fontWeight: w400,
          ),
        )
      ],
    );
  });
}

Widget get appBarLibraryView {
  return Builder(builder: (context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          align: TextAlign.start,
          'المكتبة',
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: isTablet ? 20.sp : 28.sp,
            fontWeight: w500,
          ),
        ),
        AppText(
          align: TextAlign.start,
          'المكتبة تحتوي علي جميع الاشياء التي اشتركت بها',
          style: TextStyle(
            color: AppColors.textColor2,
            fontSize: isTablet ? 12.sp : 16.sp,
            fontWeight: w400,
          ),
        )
      ],
    );
  });
}

Widget get appBarTrainingView {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText(
        align: TextAlign.start,
        'التدريبات',
        style: TextStyle(
          color: AppColors.textColor,
          fontSize: 28.sp,
          fontWeight: w500,
        ),
      ),
      AppText(
        align: TextAlign.start,
        'بعض الأسئلة التي تساعدك علي ممارسة المنهج',
        style: TextStyle(
          color: AppColors.textColor2,
          fontSize: 16.sp,
          fontWeight: w400,
        ),
      )
    ],
  );
}

Widget get appBarBodyView {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText(
        align: TextAlign.start,
        userData?.student?.name ?? '',
        style: TextStyles.textViewMedium(
            color: AppColors.textColor, fontSize: 18.sp),
      ),
      AppText(
        align: TextAlign.start,
        '${userData?.student?.level?.stage?.name} - ${userData?.student?.level?.name}',
        color: AppColors.textColor4,
        size: 16.sp,
        weight: w400,
      ),
    ],
  );
}
