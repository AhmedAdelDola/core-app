import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/consts/images.dart';
import '../../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../../core/services/di.dart';
import '../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../core/util/logger.dart';
import '../../../../../../core/widgets/app_bar/custom_curved_appbar.dart';
import '../../../../../../core/widgets/app_buttons/custom_button.dart';
import '../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../core/widgets/app_texts/text_scroll.dart';
import '../../../../../../core/widgets/loader/app_loader.dart';
import '../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../../library/widgets/files_tap/pdf_viewer.dart';
import '../../courses_section/view/course_view/course_view_widgets/course_lessons_section/lesson_profile/lesson_profile_item.dart';
import '../cubit/lessons_section_cubit.dart';

class LessonDetailsScreen extends StatelessWidget {
  final int id;
  final String title, subTitle;

  const LessonDetailsScreen(
      {super.key,
      required this.id,
      required this.title,
      required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonsSectionCubit, LessonsSectionState>(
      builder: (context, state) {
        final cubit = LessonsSectionCubit.of(context);
        final model = cubit.getSessionModel?.session?.pdf;
        if (state is GetSubjectCoursesLoadingState)
          return Scaffold(body: const AppLoader());
    
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
                  subTitle,
                  size: 20.sp,
                  weight: w400,
                  color: AppColors.kWhite,
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.sbH,
                AppText(
                  'تفاصيل الملف',
                  size: 20.sp,
                  align: TextAlign.start,
                  weight: w500,
                  color: AppColors.textColor,
                ),
                14.sbH,
                AppText(
                  model?.disk ?? '',
                  size: 16.sp,
                  align: TextAlign.start,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  weight: w400,
                  color: AppColors.textColor2,
                ),
                16.sbH,
                const Divider(thickness: 1.5),
                LessonProfileItem(
                  title: 'عدد الصفحات',
                  subTitle: model?.sizeBytes.toString() ?? '0',
                  icon: AppImages.fileNav,
                ),
                const Divider(thickness: 1.5),
                10.sbH,
                // AppText(
                //   'تفاصيل المدرس',
                //   size: 20.sp,
                //   align: TextAlign.start,
                //   weight: w500,
                //   color: AppColors.textColor,
                // ),
                // 14.sbH,
                // CourseInstructor(
                //   avatar: model?.teacher?.avatar.toString() ?? Strings.placeHolderImg,
                //   name: model?.teacher?.name ?? '',
                //   telegram: model?.teacher?.telegram ?? '',
                //   whatsapp: model?.teacher?.whatsapp ?? '',
                // ),
              ],
            ),
          ),
          // bottomNavigationBar: Padding(
          //   padding: const EdgeInsets.all(25),
          //   child: CustomButton(
          //     text: 'عرض الملف',
          //     onTap: () async {
          //       PrintLog.w(model?.id);
          //       // await cubit
          //       //     .getAttachmentFile('${model?.id}')
          //       //     .whenComplete(() {
          //       //   PrintLog.w(cubit.getAttachmentModel?.data.link);
          //         NamedNavigatorImpl.push(
          //             PdfViewers(pdf: model));
          //       // });
          //     },
          //   ),
          // ),
        );
      },
    );
  }
}
