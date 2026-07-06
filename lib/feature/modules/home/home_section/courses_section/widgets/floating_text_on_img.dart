import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/consts/images.dart';
import '../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../core/widgets/network_img.dart';

class FloatingTextOnImg extends StatelessWidget {
  final String? img;
  final int isFree;

  const FloatingTextOnImg({super.key, required this.img, required this.isFree});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 382.w,
          height: 171.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
            child: img == 'https://apluscore.com/media/images/logo.png'
                ? Image.asset(AppImages.logoPng, fit: BoxFit.fill)
                : NetworkImagesWidgets(url: img ?? '', fit: BoxFit.fill),
          ),
        ),
        if (isFree == 1)
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              width: 62.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: AppColors.kPrimary,
                borderRadius: BorderRadius.all(Radius.circular(8.r)),
              ),
              child: AppText(
                'مجاني',
                color: Colors.white,
                size: 16.sp,
              ),
            ),
          ),
      ],
    );
  }
}
