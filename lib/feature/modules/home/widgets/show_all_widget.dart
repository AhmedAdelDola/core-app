import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/widgets/app_texts/app_text.dart';
import '../../../../core/widgets/ui_helpers/extensions.dart';

class ShowAllWidget extends StatelessWidget {
  final String title;
  final void Function()? onTap;

  const ShowAllWidget(this.title, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            title,
            style: TextStyle(fontSize: 18.sp, fontWeight: w700),
          ),
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
