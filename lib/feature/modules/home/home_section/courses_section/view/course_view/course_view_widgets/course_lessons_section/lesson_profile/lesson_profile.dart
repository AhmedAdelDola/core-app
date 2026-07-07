// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:elhanbly/models/home_entities/courses/get_course_data_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../../../../core/consts/images.dart';
import '../../../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../../../core/widgets/app_bar/custom_curved_appbar.dart';
import '../../../../../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../../../../../core/widgets/app_texts/text_scroll.dart';
import '../../../../../../../../../../core/widgets/loader/app_loader.dart';
import '../../../../../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../../../cubit/courses_section_cubit.dart';
import 'lesson_card.dart';
import 'lesson_profile_item.dart';

class LessonProfile extends StatelessWidget {
  final Lesson lesson;
  final String title2;

  const LessonProfile({super.key, required this.lesson, required this.title2});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextScroll(
              lesson.title ?? '',
              size: 28.sp,
              weight: w500,
              color: AppColors.kWhite,
              align: TextAlign.start,
              mode: TextScrollMode.begin,
            ),
            AppTextScroll(
              title2,
              size: 20.sp,
              weight: w400,
              color: AppColors.kWhite,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          20.sbH,
          AppText(
            'تفاصيل الدرس',
            size: 20.sp,
            align: TextAlign.start,
            weight: w500,
            color: AppColors.textColor,
          ),
          14.sbH,
          AppText(
            lesson.title ?? 'غير متوفر',
            size: 16.sp,
            align: TextAlign.start,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            weight: w400,
            color: AppColors.textColor2,
          ),
          20.sbH,
          AppText(
            'محتوي الدرس',
            size: 20.sp,
            align: TextAlign.start,
            weight: w500,
            color: AppColors.textColor,
          ),
          14.sbH,
          ...List.generate(
            lesson.sessions?.length ?? 0,
            (i) => LessonCard(model: lesson.sessions?[i]),
          ),
        ],
      ),
    );
  }
}
