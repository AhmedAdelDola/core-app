import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../../../core/consts/images.dart';
import '../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../core/util/launcher.dart';
import '../../../../../../../../core/widgets/app_buttons/master_button.dart';
import '../../../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../../../core/widgets/ui_helpers/extensions.dart';

class CourseInstructor extends StatelessWidget {
  final String avatar, name;

  const CourseInstructor({
    super.key,
    required this.avatar,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.kPrimary.withOpacity(0.1),
                child: avatar.isEmpty
                    ? Image.asset(AppImages.logoPng)
                    : ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: avatar,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Image.asset(AppImages.logoPng),
                        ),
                      ),
              ),
              12.sbW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      name,
                      color: AppColors.textColor,
                      size: 16.sp,
                      weight: w800,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    2.sbH,
                    AppText(
                      'المحاضر',
                      color: AppColors.textColor4,
                      size: 12.sp,
                      weight: w400,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
