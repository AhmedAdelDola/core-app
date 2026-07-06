// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';

// import '../../../../../core/consts/strings.dart';
// import '../../../../../core/navigator/named_navigator_impl.dart';
// import '../../../../../core/services/di.dart';
// import '../../../../../core/theme/colors/app_colors.dart';
// import '../../../../../core/widgets/app_texts/app_text.dart';
// import '../../../../../core/widgets/loader/app_loader.dart';
// import '../../../../../core/widgets/ui_helpers/alert_message.dart';
// import '../../../../../core/widgets/ui_helpers/extensions.dart';
// import '../../../home/home_section/courses_section/view/course_view/course_view_widgets/price_container.dart';
// import '../../../quizes/cubit/create_quiz/create_quize_cubit.dart';
// import '../../../quizes/exam_cubit/exam/exam_cubit.dart';
// import '../../../quizes/exam_cubit/exam_deatils_screen.dart';
// import '../../library_imports.dart';

// class ExamsTab extends StatelessWidget {
//   const ExamsTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<ExamCubit>(
//       create: (context) => di<ExamCubit>()..getAllExam(),
//       child: BlocBuilder<ExamCubit, ExamState>(
//         builder: (context, state) {
//           final cubit = ExamCubit.get(context);
//           final model = cubit.allExam?.data;

//           if (state.isLoading) {
//             return const AppLoader();
//           }
//           return ListView.separated(
//             itemCount: model?.length ?? 0,
//             separatorBuilder: (context, index) => 16.sbH,
//             itemBuilder: (context, i) {
//               return GestureDetector(
//                 onTap: () => NamedNavigatorImpl.push(SingleExamScreen(
//                   examId: model![i].id.toString(),
//                   ChapterName: model[i].chapterName ?? '',
//                   courseName: model[i].courseName ?? '',
//                   name: model[i].name ?? '',
//                 )),
//                 child: Container(
//                   width: double.infinity,
//                   margin: const EdgeInsets.symmetric(horizontal: 16),
//                   // padding: const EdgeInsets.symmetric(horizontal: 16),
//                   decoration: BoxDecoration(
//                       border: Border.all(color: AppColors.borderColor),
//                       borderRadius: BorderRadius.circular(12.r)),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: SizedBox(
//                           height: 120.h,
//                           child: ClipRRect(
//                               clipBehavior: Clip.antiAlias,
//                               borderRadius: BorderRadius.circular(12.r),
//                               child: CachedNetworkImage(
//                                   fit: BoxFit.fill,
//                                   imageUrl: model?[i].image ??
//                                       Strings.placeHolderImg)),
//                         ),
//                       ),
//                       16.sbW,
//                       Expanded(
//                         flex: 4,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               SizedBox(
//                                 child: Row(
//                                   children: [
//                                     AppText(
//                                       model?[i].name ?? '',
//                                       color: AppColors.textColor,
//                                       size: 18.sp,
//                                       weight: w500,
//                                     ),
//                                     const Spacer(),
//                                     AppText(
//                                       "${model?[i].duration}د" ?? '',
//                                       color: AppColors.kGreen,
//                                       size: 14.sp,
//                                       weight: w500,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               5.sbH,
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     '${model?[i].courseName}',
//                                     color: AppColors.textColor2,
//                                     size: 14.sp,
//                                     weight: w400,
//                                   ),
//                                   AppText(
//                                     '  -  ',
//                                     color: AppColors.textColor2,
//                                     size: 14.sp,
//                                     weight: w400,
//                                   ),
//                                   AppText(
//                                     '${model?[i].chapterName}',
//                                     color: AppColors.textColor2,
//                                     size: 14.sp,
//                                     weight: w400,
//                                   ),
//                                 ],
//                               ),
//                               5.sbH,
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   AppText(
//                                     'البداية',
//                                     color: AppColors.kPrimary,
//                                     size: 14.sp,
//                                     weight: w400,
//                                   ),
//                                   AppText(
//                                     'النهاية',
//                                     color: AppColors.textColor2,
//                                     size: 14.sp,
//                                     weight: w400,
//                                   ),
//                                 ],
//                               ),
//                               5.sbH,
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   AppText(
//                                     '${model?[i].startDate}',
//                                     color: AppColors.kPrimary,
//                                     size: 14.sp,
//                                     weight: w400,
//                                   ),
//                                   AppText(
//                                     '${model?[i].endDate}',
//                                     color: AppColors.textColor2,
//                                     size: 14.sp,
//                                     weight: w400,
//                                   ),
//                                 ],
//                               ),
//                               5.sbH,
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
