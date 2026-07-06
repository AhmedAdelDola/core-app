import '../../../../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../../../../core/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget get customAppBar {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Container(
      height: 40,
      margin: EdgeInsets.only(top: 45.h),
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
        ],
      ),
    ),
  );
}
