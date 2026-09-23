import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../../core/consts/images.dart';
import '../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../core/util/responsive/responsive_helper.dart';

class CourseImageWithData extends StatelessWidget {
  final bool isFree;
  final String? imageUrl;
  final String? price;

  const CourseImageWithData({
    super.key,
    required this.isFree,
    this.imageUrl,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    final hasValidImage = imageUrl != null && imageUrl!.trim().isNotEmpty;
    final priceNum = double.tryParse(price ?? '0') ?? 0.0;
    final isActuallyFree = isFree || priceNum == 0.0;
    final bool isMobileLandscape = AppResponsive.isMobileLandscape(context);
    final double imageHeight = isMobileLandscape ? 160.0 : 270.h;

    return Stack(
      children: [
        SizedBox(
          height: imageHeight,
          width: double.infinity,
          child: hasValidImage
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade100,
                    child: Center(
                      child: Image.asset(AppImages.logoPng, width: 90.w, fit: BoxFit.contain),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade100,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : Container(
                  color: Colors.grey.shade100,
                  child: Center(
                    child: Image.asset(AppImages.logoPng, width: 90.w, fit: BoxFit.contain),
                  ),
                ),
        ),
        // Dark gradient from top for app bar buttons contrast
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: isMobileLandscape ? 60.0 : 100.h,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.55),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Price badge in bottom left (or right)
        Positioned(
          bottom: isMobileLandscape ? 14.0 : 35.h,
          right: isMobileLandscape ? 12.0 : 20.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isActuallyFree ? AppColors.kGreen : AppColors.kPrimary,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              isActuallyFree ? 'مجاني' : '$priceNum ج.م',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
