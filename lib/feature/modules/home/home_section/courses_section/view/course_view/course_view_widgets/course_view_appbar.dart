import '../../../../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../../../../core/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../../core/util/responsive/responsive_helper.dart';

Widget get customAppBar {
  return Builder(
    builder: (context) {
      final isMobileLandscape = AppResponsive.isMobileLandscape(context);
      final isTablet = AppResponsive.isTablet(context);
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          height: isMobileLandscape ? 36.0 : 40.0,
          margin: EdgeInsets.only(
            top: isMobileLandscape ? 8.0 : (isTablet ? 16.0 : 45.h),
            left: isMobileLandscape ? 10.0 : 16.0,
            right: isMobileLandscape ? 10.0 : 16.0,
          ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: AppColors.kBlack.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.kPrimary.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.kWhite),
              onPressed: () => NamedNavigatorImpl.pop(),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.kPrimary.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.favorite_border,
                      color: AppColors.kWhite),
                  onPressed: () => NamedNavigatorImpl.pop(),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     color: AppColors.kPrimary.withOpacity(0.5),
              //     shape: BoxShape.circle,
              //   ),
              //   child: IconButton(
              //     icon: const Icon(Icons.share, color: AppColors.kWhite),
              //     onPressed: () => NamedNavigatorImpl.pop(),
              //   ),
              // ),
            ],
          ),
        
      ]))
      );
    },
  );
}
