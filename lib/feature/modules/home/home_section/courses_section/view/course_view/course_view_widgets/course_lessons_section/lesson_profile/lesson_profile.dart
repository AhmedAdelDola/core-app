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
  final String title, id;

  const LessonProfile({super.key, required this.title, required this.id});

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
              title,
              size: 28.sp,
              weight: w500,
              color: AppColors.kWhite,
              align: TextAlign.start,
              mode: TextScrollMode.begin,
            ),
            AppTextScroll(
              id,
              size: 20.sp,
              weight: w400,
              color: AppColors.kWhite,
            ),
          ],
        ),
      ),
      body: BlocProvider(
        create: (context) => CoursesSectionCubit.of(context)..getCourseData(id),
        child: BlocBuilder<CoursesSectionCubit, CoursesSectionState>(
          builder: (context, state) {
            final cubit = CoursesSectionCubit.of(context);
            Lesson? findLesson() {
              final chapters = cubit.courseData?.course?.chapters;
              if (chapters == null) return null;
              for (final chapter in chapters) {
                final lessons = chapter.lessons;
                if (lessons == null) continue;
                for (final lesson in lessons) {
                  if (lesson.id?.toString() == id) {
                    return lesson;
                  }
                }
              }
              return null;
            }

            final model = findLesson();
            if (state is GetLessonProfileLoadingState) return const AppLoader();
            return ListView(
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
                  model?.title ?? 'غير متوفر',
                  size: 16.sp,
                  align: TextAlign.start,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  weight: w400,
                  color: AppColors.textColor2,
                ),
                20.sbH,
                if (model == null) ...[
                  AppText(
                    'لا يوجد درس واحد بمثل هذا المعرف.',
                    size: 16.sp,
                    align: TextAlign.start,
                    weight: w400,
                    color: AppColors.textColor2,
                  ),
                ] else ...[
                  AppText(
                    'محتوي الدرس',
                    size: 20.sp,
                    align: TextAlign.start,
                    weight: w500,
                    color: AppColors.textColor,
                  ),
                  14.sbH,
                  ...List.generate(
                    model.sessions?.length ?? 0,
                    (i) => LessonCard(model: model.sessions?[i]),
                  ),
                ],
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     LessonProfileItem(
                //       title: 'الحاله',
                //       subTitle: model?.status ?? '',
                //       icon: AppImages.alertCircle,
                //     ),
                //     LessonProfileItem(
                //       title: 'التقدم',
                //       subTitle: '${model?.progressPoint ?? 0} %',
                //       icon: AppImages.medalStar,
                //     ),
                //     LessonProfileItem(
                //       title: 'النقاط',
                //       subTitle: model?.points.toString() ?? '',
                //       icon: AppImages.ranking,
                //     ),
                //   ],
                // ),
                // 20.sbH,
                
              ],
            );
          },
        ),
      ),
    );
  }
}
