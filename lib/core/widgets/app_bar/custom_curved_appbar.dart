import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors/app_colors.dart';
import '../app_texts/app_text.dart';
import '../app_texts/text_scroll.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? child, leading;
  final String? title;
  final double? height;

  const CustomAppBar(
      {super.key, this.child, this.title, this.height, this.leading});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final double titleFontSize = isTablet ? 20.sp : 28.sp;
    final double borderRadius = isTablet ? 35.sp : 50.sp;
    final double appBarHeight = isTablet ? 65.h : 85.h;

    return AppBar(
      centerTitle: false,
      leading: leading,
      title: child ??
          AppTextScroll(
            title ?? '',
            size: titleFontSize,
            weight: w500,
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
  Size get preferredSize => Size.fromHeight(height ?? 85.h);
}
