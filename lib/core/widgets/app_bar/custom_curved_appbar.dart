import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors/app_colors.dart';
import '../../util/responsive/responsive_helper.dart';
import '../app_texts/text_scroll.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? child, leading;
  final String? title;
  final double? height;

  const CustomAppBar({
    super.key,
    this.child,
    this.title,
    this.height,
    this.leading,
  });

  static double getAppBarHeight(BuildContext context) {
    if (AppResponsive.isMobileLandscape(context)) {
      return 52.0;
    } else if (AppResponsive.isTablet(context)) {
      return AppResponsive.isLandscape(context) ? 62.0 : 68.0;
    } else {
      return 72.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobileLandscape = AppResponsive.isMobileLandscape(context);
    final bool isTablet = AppResponsive.isTablet(context);

    final double titleFontSize = isMobileLandscape
        ? 16.sp
        : (isTablet ? 18.sp : 22.sp);

    final double borderRadius = isMobileLandscape
        ? 20.0
        : (isTablet ? 28.0 : 36.0);

    final double appBarHeight = height ?? getAppBarHeight(context);

    return AppBar(
      toolbarHeight: appBarHeight,
      centerTitle: false,
      leading: leading,
      title: child ??
          AppTextScroll(
            title ?? '',
            size: titleFontSize,
            weight: FontWeight.w600,
            color: AppColors.kWhite,
            align: TextAlign.start,
            mode: TextScrollMode.begin,
          ),
      backgroundColor: AppColors.kPrimary,
      foregroundColor: AppColors.kWhite,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    if (height != null) {
      return Size.fromHeight(height!);
    }
    return const Size.fromHeight(72.0);
  }
}
