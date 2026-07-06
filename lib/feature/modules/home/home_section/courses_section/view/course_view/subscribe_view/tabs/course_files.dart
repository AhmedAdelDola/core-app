// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lottie/lottie.dart';

// import '../../../../../../../../../core/consts/images.dart';
// import '../../../../../../../../../core/services/di.dart';
// import '../../../../../../../../../core/theme/colors/app_colors.dart';
// import '../../../../../../../../../core/widgets/app_texts/app_text.dart';
// import '../../../../../../../../../core/widgets/loader/app_loader.dart';
// import '../../../../../../../../../core/widgets/ui_helpers/extensions.dart';
// import '../../../../cubit/courses_section_cubit.dart';

// class CourseFiles extends StatelessWidget {
//   const CourseFiles({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CoursesSectionCubit, CoursesSectionState>(
//       builder: (context, state) {
//         final cubit = CoursesSectionCubit.of(context);
//         // final model = cubit.attachmentResponse?.data;
//         // if (state is CourseAttachmentLoadingState) return const AppLoader();
//         // if (model == null || model.isEmpty) {
//         //   return Center(
//         //       child: Lottie.asset(AppJsonFiles.emptyState, fit: BoxFit.fill));
//         // }

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
//               child: AppText(
//                 'الملفات ' '(${model?.length})',
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: w700,
//                 ),
//               ),
//             ),
//             10.sbH,
//             Expanded(
//               child: ListView.separated(
//                 shrinkWrap: true,
//                 physics: const BouncingScrollPhysics(),
//                 itemCount: model?.length ?? 0,
//                 scrollDirection: Axis.vertical,
//                 padding: const EdgeInsets.all(8),
//                 separatorBuilder: (c, i) => 16.sbW,
//                 itemBuilder: (c, courseIndex) {
//                   return Container(
//                     width: MediaQuery.of(context).size.width,
//                     margin:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: AppColors.kWhite,
//                       borderRadius: BorderRadius.circular(12.r),
//                       border: Border.all(
//                           color: AppColors.textFieldBorderColor, width: 1),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Row(
//                         children: [
//                           const CircleAvatar(
//                             radius: 20,
//                             child: Icon(Icons.picture_as_pdf,
//                                 color: AppColors.kWhite),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 12, vertical: 8),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AppText(
//                                       model?[courseIndex].name ?? '',
//                                       size: 16.sp,
//                                       weight: w700,
//                                       color: AppColors.textColor,
//                                     ),
//                                     8.sbH,
//                                     AppText(
//                                       '${model?[courseIndex].attachmentCount} صفحة',
//                                       size: 14.sp,
//                                       weight: w400,
//                                       color: AppColors.textColor4,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
