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
  final String? whatsapp, telegram;

  const CourseInstructor({
    super.key,
    required this.avatar,
    required this.name,
    this.whatsapp,
    this.telegram,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Row(
          children: [
            CircleAvatar(radius: 22, backgroundImage:avatar == '' ? AssetImage(AppImages.logoPng):CachedNetworkImageProvider(avatar)),
            10.sbW,
            AppText(name, color: AppColors.textColor, size: 18.sp, weight: w800),
            const Spacer(),
            if (whatsapp != null && whatsapp!.isNotEmpty)
              MasterButton(
                width: 50.w,
                height: 50.h,
                padding: EdgeInsets.zero,
                buttonRadius: 50.r,
                onPressed: () => AppLauncher.launchWhatsApp(number: whatsapp ?? ''),
                borderColor: AppColors.kDarkModeGreen,
                buttonColor: AppColors.kWhite,
                child: SvgPicture.asset(
                  AppImages.whatsappSvg,
                  colorFilter: const ColorFilter.mode(
                    AppColors.kDarkModeGreen,
                    BlendMode.srcIn,
                  ),
                  width: 20,
                  height: 20,
                ),
              ),
            10.sbW,
            if (telegram != null && telegram!.isNotEmpty)
              MasterButton(
                width: 50.w,
                height: 50.h,
                padding: EdgeInsets.zero,
                buttonRadius: 50.r,
                onPressed: () => AppLauncher.launchTelegram(number: telegram ?? ''),
                borderColor: AppColors.textColor4,
                buttonColor: AppColors.kWhite,
                child: const RotationTransition(
                  turns: AlwaysStoppedAnimation(180 / 500),
                  filterQuality: FilterQuality.high,
                  child: Icon(
                    Icons.send,
                    color: AppColors.textColor4,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
