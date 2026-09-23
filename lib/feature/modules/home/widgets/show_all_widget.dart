import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/util/responsive/responsive_helper.dart';
import '../../../../core/widgets/app_texts/app_text.dart';
import '../../../../core/widgets/ui_helpers/extensions.dart';

class ShowAllWidget extends StatelessWidget {
  final String title;
  final void Function()? onTap;

  const ShowAllWidget(this.title, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = AppResponsive.isTablet(context);
    final isMobileLandscape = AppResponsive.isMobileLandscape(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24.w : (isMobileLandscape ? 12.w : 20.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            title,
            style: TextStyle(
              fontSize: isMobileLandscape ? 15.sp : 18.sp,
              fontWeight: w700,
            ),
          ),
          if (onTap != null)
            InkWell(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppText(
                    'عرض الكل',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: w400,
                      color: AppColors.textColor4,
                    ),
                  ),
                  4.sbW,
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textColor4,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
