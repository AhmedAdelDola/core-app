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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final bool isTablet = screenWidth >= 600;

    Widget navContent = Row(
      mainAxisAlignment:
          isTablet ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.spaceBetween,
      children: [
        bottomNavigationItem(0, 'الرئيسية', AppImages.homeNav),
        // bottomNavigationItem(1, 'التدريبات', AppImages.fileNav),
        bottomNavigationItem(1, 'المكتبة', AppImages.libraryNav),
        // bottomNavigationItem(3, 'الإشعارات', AppImages.notificationNav),
        bottomNavigationItem(2, 'المزيد', AppImages.moreNav),
      ],
    );

    if (isTablet) {
      navContent = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: navContent,
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.only(
        bottom: 10,
        start: isTablet ? 16 : 28,
        end: isTablet ? 16 : 28,
        top: 10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: navContent,
    );
  }

  Widget bottomNavigationItem(int index, String label, String iconPath) {
    return InkWell(
      key: ValueKey('nav_tab_$index'),
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
