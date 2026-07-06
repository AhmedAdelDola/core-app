import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../consts/images.dart';
import '../../theme/colors/app_colors.dart';
import '../app_texts/app_text.dart';
import '../ui_helpers/extensions.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int index) onItemTap;

  const CustomBottomNavigationBar(
      {super.key, required this.currentIndex, required this.onItemTap});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.only(
          bottom: 10, start: 28, end: 28, top: 10),
      decoration: BoxDecoration(
        color: AppColors.kBackground,
        borderRadius: BorderRadius.circular(20),
        // boxShadow: [
        //   BoxShadow(
        //     color: AppColors.kBlack.withOpacity(0.9),
        //     blurRadius: 12.r,
        //     offset: const Offset(0, -2), // changes position of shadow
        //   ),
        // ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          bottomNavigationItem(0, 'الرئيسية', AppImages.homeNav),
          // bottomNavigationItem(1, 'التدريبات', AppImages.fileNav),
          bottomNavigationItem(1, 'المكتبة', AppImages.libraryNav),
          // bottomNavigationItem(3, 'الإشعارات', AppImages.notificationNav),
          bottomNavigationItem(2, 'المزيد', AppImages.moreNav),
        ],
      ),
    );
  }

  Widget bottomNavigationItem(int index, String label, String iconPath) {
    return InkWell(
      onTap: () => widget.onItemTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 24.w,
            height: 24.h,
            colorFilter: ColorFilter.mode(
              index == widget.currentIndex
                  ? AppColors.kPrimary
                  : AppColors.textFieldBorderColor,
              BlendMode.srcIn,
            ),
          ),
          10.sbH,
          AppText(
            label,
            color: index == widget.currentIndex
                ? AppColors.kPrimary
                : AppColors.textFieldBorderColor,
            size: index == widget.currentIndex ? 13.sp : 12.sp,
          )
        ],
      ),
    );
  }
}
