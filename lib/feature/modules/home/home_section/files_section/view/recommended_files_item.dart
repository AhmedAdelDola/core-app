import 'package:elhanbly/core/widgets/app_texts/text_scroll.dart';
import 'package:elhanbly/feature/modules/home/home_section/lessons_section/widgets/lesson_screen.dart';
import 'package:elhanbly/feature/modules/home/home_section/lessons_section/widgets/session_screen.dart';
import 'package:elhanbly/models/home_entities/home/get_home.dart';

import '../../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../core/widgets/ui_helpers/extensions.dart';
import 'recommended_files_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../models/home_entities/files/get_recommended_files_response.dart';

class RecommendedFilesItem extends StatelessWidget {
  final FeaturedFile? model;

  const RecommendedFilesItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        switch (model?.type){
        case 'video'  : {
          NamedNavigatorImpl.push(SessionDetilesScreen(id: model?.session?.id ?? 0, title: model?.session?.title ?? '', subTitle: model?.course?.title ?? ''));}
          break;
        case 'pdf' : {
          // NamedNavigatorImpl.push(LessonDetailsScreen(id: model?.session?.id ?? 0, title: model?.session?.title ?? '', subTitle: model?.course?.title ?? ''));
          }
        break;
        }

        
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.textFieldBorderColor, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
               CircleAvatar(
                radius: 20,
                child: Icon(model?.type == 'video'? Icons.video_library_outlined : Icons.picture_as_pdf, color: AppColors.kWhite),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextScroll(
                            model?.session?.title ?? '',
                            size: 16.sp,
                            weight: w700,
                            color: AppColors.textColor,
                            align: TextAlign.right,
                          ),
                          8.sbH,
                          AppText(
                            '${model?.type} ',
                            size: 14.sp,
                            weight: w400,
                            color: AppColors.textColor4,
                          ),
                        ],
                      ),
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
