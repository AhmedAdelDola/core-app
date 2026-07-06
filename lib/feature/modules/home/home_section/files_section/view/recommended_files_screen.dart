// import 'package:elhanbly/feature/modules/home/cubit/home_cubit/home_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../../../../core/consts/images.dart';
// import '../../../../../../core/consts/strings.dart';
// import '../../../../../../core/navigator/named_navigator_impl.dart';
// import '../../../../../../core/services/di.dart';
// import '../../../../../../core/theme/colors/app_colors.dart';
// import '../../../../../../core/widgets/app_bar/custom_curved_appbar.dart';
// import '../../../../../../core/widgets/app_buttons/custom_button.dart';
// import '../../../../../../core/widgets/app_texts/app_text.dart';
// import '../../../../../../core/widgets/app_texts/text_scroll.dart';
// import '../../../../../../core/widgets/loader/app_loader.dart';
// import '../../../../../../core/widgets/ui_helpers/alert_message.dart';
// import '../../../../../../core/widgets/ui_helpers/extensions.dart';
// import '../../../../library/widgets/files_tap/pdf_viewer.dart';
// import '../../courses_section/view/course_view/course_view_widgets/course_details_instructor.dart';
// import '../../courses_section/view/course_view/course_view_widgets/course_lessons_section/lesson_profile/lesson_profile_item.dart';
// import '../../lessons_section/cubit/lessons_section_cubit.dart';
// import '../cubit/files_section_cubit.dart';

// class RecommendedFileView extends StatelessWidget {
//   final String title, title2;
//   final int id;
//   const RecommendedFileView(
//       {super.key, required this.title, required this.title2, required this.id});

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<HomeCubit, HomeStates>(
//       listener: (context, state) {
      
//       },
//       builder: (context, state) {
//         final cubit = HomeCubit.of(context);
//         final model = cubit.home?.featuredFiles;
//         if (state is GetHomeLoadingState) return const AppLoader();
    
//         return Scaffold(
//           appBar: CustomAppBar(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 AppTextScroll(
//                   title,
//                   size: 28.sp,
//                   weight: w500,
//                   color: AppColors.kWhite,
//                   align: TextAlign.start,
//                   mode: TextScrollMode.begin,
//                 ),
//                 AppTextScroll(
//                   title2,
//                   size: 20.sp,
//                   weight: w400,
//                   color: AppColors.kWhite,
//                 ),
//               ],
//             ),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 20.sbH,
//                 AppText(
//                   'تفاصيل الحصه',
//                   size: 20.sp,
//                   align: TextAlign.start,
//                   weight: w500,
//                   color: AppColors.textColor,
//                 ),
//                 14.sbH,
//                 AppText(
//                   model?. ?? '',
//                   size: 16.sp,
//                   align: TextAlign.start,
//                   maxLines: 3,
//                   overflow: TextOverflow.ellipsis,
//                   weight: w400,
//                   color: AppColors.textColor2,
//                 ),
//                 20.sbH,
//                 AppText(
//                   'محتوي الشيت',
//                   size: 20.sp,
//                   align: TextAlign.start,
//                   weight: w500,
//                   color: AppColors.textColor,
//                 ),
//                 16.sbH,
//                 const Divider(thickness: 1.5),
//                 LessonProfileItem(
//                   title: 'عدد الصفحات',
//                   subTitle: model?.pageNumbers.toString() ?? '0',
//                   icon: AppImages.fileNav,
//                 ),
//                 const Divider(thickness: 1.5),
//                 10.sbH,
//                 AppText(
//                   'تفاصيل المدرس',
//                   size: 20.sp,
//                   align: TextAlign.start,
//                   weight: w500,
//                   color: AppColors.textColor,
//                 ),
//                 14.sbH,
//                 CourseInstructor(
//                   avatar: model?.teacher?.avatar.toString() ??
//                       Strings.placeHolderImg,
//                   name: model?.teacher?.name ?? '',
//                   telegram: model?.teacher?.telegram ?? '',
//                   whatsapp: model?.teacher?.whatsapp ?? '',
//                 ),
//               ],
//             ),
//           ),
//           bottomNavigationBar:
//               (model?.isFree == 1 || model?.isSubscribe != 0) ||
//                       model?.isSubscribe != 0
//                   ? Padding(
//                       padding: const EdgeInsets.all(25),
//                       child: CustomButton(
//                         text: 'المشاهده الان',
//                         onTap: () async {
//                           await context
//                               .read<LessonsSectionCubit>()
//                               .getAttachmentFile('${model?.id}');
//                           final modelss = context
//                               .read<LessonsSectionCubit>()
//                               .getAttachmentModel;
//                           NamedNavigatorImpl.push(PdfViewer(pdf: modelss));
//                         },
//                       ),
//                     )
//                   : null,
//         );
//       },
//     );

//     // body: BlocBuilder<CoursesSectionCubit, CoursesSectionState>(
//     //   builder: (context, state) {
//     //     // final cubit = CoursesSectionCubit.of(context);
//     //     // final model = cubit.lessonProfileResponse?.data;
//     //     if (state is GetLessonProfileLoadingState) return const AppLoader();
//     //     return Padding(
//     //       padding: const EdgeInsets.all(8),
//     //       child: Column(
//     //         crossAxisAlignment: CrossAxisAlignment.start,
//     //         children: [
//     //           20.sbH,
//     //           AppText(
//     //             'تفاصيل الدرس',
//     //             size: 20.sp,
//     //             align: TextAlign.start,
//     //             weight: w500,
//     //             color: AppColors.textColor,
//     //           ),
//     //           14.sbH,
//     //           AppText(
//     //             'tezt', //model?.description ?? '',
//     //             size: 16.sp,
//     //             align: TextAlign.start,
//     //             maxLines: 3,
//     //             overflow: TextOverflow.ellipsis,
//     //             weight: w400,
//     //             color: AppColors.textColor2,
//     //           ),
//     //           20.sbH,
//     //           const Row(
//     //             mainAxisAlignment: MainAxisAlignment.spaceAround,
//     //             children: [
//     //               LessonProfileItem(
//     //                 title: 'الحاله',
//     //                 subTitle: 'البداية',
//     //                 icon: Icons.calendar_today,
//     //               ),
//     //               LessonProfileItem(
//     //                 title: 'التقدم',
//     //                 subTitle: 'البداية',
//     //                 icon: Icons.calendar_today,
//     //               ),
//     //               LessonProfileItem(
//     //                 title: 'النقاط',
//     //                 subTitle: 'البداية',
//     //                 icon: Icons.calendar_today,
//     //               ),
//     //             ],
//     //           ),
//     //           20.sbH,
//     //           AppText(
//     //             'محتوي الدرس',
//     //             size: 20.sp,
//     //             align: TextAlign.start,
//     //             weight: w500,
//     //             color: AppColors.textColor,
//     //           ),
//     //           14.sbH,
//     //           // ...List.generate(
//     //           //   model?.content.length ?? 0,
//     //           //   (i) => LessonCard(model: model?.content[i]),
//     //           // ),
//     //         ],
//     //       ),
//     //     );
//     //   },
//     // ),
//   }
// }
