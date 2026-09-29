import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/consts/images.dart';
import '../../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../../../../models/home_entities/home/get_home.dart';
import '../../../../library/widgets/files_tap/pdf_viewer.dart';
import '../../lessons_section/widgets/session_screen.dart';

class RecommendedFilesItem extends StatelessWidget {
  final FeaturedFile? model;

  const RecommendedFilesItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final bool isVideo = model?.kind?.toLowerCase() == 'media' ||
        model?.type?.toLowerCase() == 'video' ||
        model?.type?.toLowerCase() == 'media' ||
        (model?.id != null && model!.id!.startsWith('media-'));

    return InkWell(
      onTap: () {
        NamedNavigatorImpl.push(
          SessionDetilesScreen(
            id: model?.session?.id ?? int.tryParse(model?.id ?? '') ?? 0,
            title: model?.session?.title ?? model?.name ?? '',
            subTitle: model?.course?.title ?? '',
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: AppColors.borderColor.withOpacity(0.6),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.kPrimary,
                radius: 20,
                child: isVideo
                    ? SvgPicture.asset(
                        AppImages.playVideoSvg,
                        colorFilter: const ColorFilter.mode(
                          AppColors.kWhite,
                          BlendMode.srcIn,
                        ),
                        width: 22,
                      )
                    : const Icon(Icons.picture_as_pdf, color: AppColors.kWhite),
              ),
              12.sbW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      model?.session?.title ?? model?.name ?? '',
                      size: 15.sp,
                      weight: w700,
                      color: AppColors.textColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.sbH,
                    AppText(
                      isVideo ? 'فيديو' : 'ملف PDF',
                      size: 12.sp,
                      weight: w400,
                      color: AppColors.textColor4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
