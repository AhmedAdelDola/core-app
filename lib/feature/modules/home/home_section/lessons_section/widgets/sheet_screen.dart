// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../../../../core/consts/images.dart';
// import '../../../../../../core/consts/strings.dart';
// import '../../../../../../core/services/di.dart';
// import '../../../../../../core/theme/colors/app_colors.dart';
// import '../../../../../../core/widgets/app_bar/custom_curved_appbar.dart';
// import '../../../../../../core/widgets/app_buttons/custom_button.dart';
// import '../../../../../../core/widgets/app_texts/app_text.dart';
// import '../../../../../../core/widgets/loader/app_loader.dart';
// import '../../../../../../core/widgets/ui_helpers/extensions.dart';
// import '../../courses_section/view/course_view/course_view_widgets/course_details_instructor.dart';
// import '../../courses_section/view/course_view/course_view_widgets/course_lessons_section/lesson_profile/lesson_profile_item.dart';
// import '../cubit/lessons_section_cubit.dart';

// class SheetDetailsScreen extends StatelessWidget {
//   final int id;

//   const SheetDetailsScreen(this.id, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => di<LessonsSectionCubit>()..getSheetInfo('$id'),
//       child: BlocBuilder<LessonsSectionCubit, LessonsSectionState>(
//         builder: (context, state) {
//           final cubit = LessonsSectionCubit.of(context);
//           // final model = cubit.getSheetInfoModel?.data;

//           if (state is GetSubjectCoursesLoadingState) return Scaffold(body: const AppLoader());
//           return Scaffold(
//             appBar: CustomAppBar(
//               child: Row(
//                 children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       AppText(
//                         model?.name ?? '',
//                         size: 28.sp,
//                         weight: w500,
//                         color: AppColors.kWhite,
//                         align: TextAlign.start,
//                       ),
//                       AppText(
//                         model?.courseName ?? '',
//                         size: 20.sp,
//                         weight: w400,
//                         color: AppColors.kWhite,
//                       ),
//                     ],
//                   ),
//                   Spacer(),
//                   if (model?.isShowResult == 1)
//                     Container(
//                       width: 60.w,
//                       height: 30,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: AppColors.kGreen,
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: AppText(
//                         model?.result.toString() ?? '',
//                         color: AppColors.kWhite,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             body: Padding(
//               padding: const EdgeInsets.all(8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   20.sbH,
//                   AppText(
//                     'تفاصيل ال${model?.modelTypeValue}',
//                     size: 20.sp,
//                     align: TextAlign.start,
//                     weight: w500,
//                     color: AppColors.textColor,
//                   ),
//                   14.sbH,
//                   AppText(
//                     model?.note ?? 'لا يوجد ملاحظات',
//                     size: 16.sp,
//                     align: TextAlign.start,
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                     weight: w400,
//                     color: AppColors.textColor2,
//                   ),
//                   16.sbH,
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       LessonProfileItem(
//                         title: 'الاسئله',
//                         subTitle: '${model?.asksCount}',
//                         icon: AppImages.alertCircle,
//                       ),
//                       LessonProfileItem(
//                         title: 'المده',
//                         subTitle: '${model?.duration}',
//                         icon: AppImages.medalStar,
//                       ),
//                       LessonProfileItem(
//                         title: 'النقاط',
//                         subTitle: model?.points.toString() ?? '',
//                         icon: AppImages.ranking,
//                       ),
//                     ],
//                   ),
//                   const Divider(thickness: 1.5),
//                   LessonProfileItem(
//                     title: 'تاريخ البدايه',
//                     subTitle: '${model?.startDate ?? ''} - ${model?.startTime ?? ''}',
//                     icon: AppImages.fileNav,
//                   ),
//                   const Divider(thickness: 1.5),
//                   LessonProfileItem(
//                     title: 'اخر موعد للتسليم',
//                     subTitle: '${model?.endDate ?? ''} - ${model?.endHour ?? ''}',
//                     icon: AppImages.fileNav,
//                   ),
//                   const Divider(thickness: 1.5),
//                   10.sbH,
//                   Center(
//                     child: AppText(
//                       'تقرير ال${model?.modelTypeValue}',
//                       size: 20.sp,
//                       weight: w500,
//                       color: AppColors.textColor,
//                     ),
//                   ),
//                   15.sbH,
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       _cardText(
//                         color: AppColors.kPrimary,
//                         title: 'الاسئله المحلوله',
//                         value: '${model?.answersCount}',
//                       ),
//                       _cardText(
//                         color: AppColors.kGreen,
//                         title: 'الاسئله الصحيحه',
//                         value: '${model?.sucessAnswersCount}',
//                       ),
//                       _cardText(
//                         color: AppColors.kRed,
//                         title: 'الاسئله الخاطئه',
//                         value: '${model?.wrongAnswersCount}',
//                       ),
//                     ],
//                   ),
//                   20.sbH,
//                   AppText(
//                     'تفاصيل المدرس',
//                     size: 20.sp,
//                     align: TextAlign.start,
//                     weight: w500,
//                     color: AppColors.textColor,
//                   ),
//                   CourseInstructor(
//                     avatar: model?.teacher?.avatar.toString() ?? Strings.placeHolderImg,
//                     name: model?.teacher?.name ?? '',
//                     telegram: model?.teacher?.telegram ?? '',
//                     whatsapp: model?.teacher?.whatsapp ?? '',
//                   ),
//                 ],
//               ),
//             ),
//             bottomNavigationBar: Padding(
//               padding: const EdgeInsets.all(25),
//               child: CustomButton(
//                 text: 'عرض الاجابات',
//                 onTap: () {},
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _cardText({required Color color, required String title, required String value}) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: AppText(
//         '$title\n($value)',
//         size: 16.sp,
//         align: TextAlign.center,
//         weight: w500,
//         color: AppColors.kWhite,
//       ),
//     );
//   }
// }
