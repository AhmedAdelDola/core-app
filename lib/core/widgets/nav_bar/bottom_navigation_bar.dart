import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../consts/images.dart';
import '../../theme/colors/app_colors.dart';
import '../../util/responsive/responsive_helper.dart';
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
    final bool isTablet = AppResponsive.isTablet(context);
    final bool isMobileLandscape = AppResponsive.isMobileLandscape(context);
    final bool isLandscape = AppResponsive.isLandscape(context);

    Widget navContent = Row(
      mainAxisAlignment:
          (isTablet || isLandscape) ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.spaceBetween,
      children: [
        bottomNavigationItem(0, 'الرئيسية', AppImages.homeNav, isMobileLandscape),
        // bottomNavigationItem(1, 'التدريبات', AppImages.fileNav, isMobileLandscape),
        bottomNavigationItem(1, 'المكتبة', AppImages.libraryNav, isMobileLandscape),
        // bottomNavigationItem(3, 'الإشعارات', AppImages.notificationNav, isMobileLandscape),
        bottomNavigationItem(2, 'المزيد', AppImages.moreNav, isMobileLandscape),
      ],
    );

    if (isTablet || isLandscape) {
      navContent = Center(
        heightFactor: 1.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isTablet ? 500 : 420),
          child: navContent,
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.only(
        bottom: isMobileLandscape ? 4 : 10,
        start: isTablet ? 16 : (isMobileLandscape ? 12 : 28),
        end: isTablet ? 16 : (isMobileLandscape ? 12 : 28),
        top: isMobileLandscape ? 4 : 10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SafeArea(
        top: false,
        child: navContent,
      ),
    );
  }

  Widget bottomNavigationItem(int index, String label, String iconPath, bool isMobileLandscape) {
    final double iconSize = isMobileLandscape ? 18.0 : 22.0;
    return InkWell(
      key: ValueKey('nav_tab_$index'),
      onTap: () => widget.onItemTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: iconSize,
            height: iconSize,
            colorFilter: ColorFilter.mode(
              index == widget.currentIndex
                  ? AppColors.kPrimary
                  : AppColors.textFieldBorderColor,
              BlendMode.srcIn,
            ),
          ),
          (isMobileLandscape ? 2.0 : 6.0).sbH,
          AppText(
            label,
            color: index == widget.currentIndex
                ? AppColors.kPrimary
                : AppColors.textFieldBorderColor,
            size: isMobileLandscape ? 10.sp : (index == widget.currentIndex ? 13.sp : 12.sp),
          )
        ],
      ),
    );
  }
}
