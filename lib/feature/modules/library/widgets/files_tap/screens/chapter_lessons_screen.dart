// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lottie/lottie.dart';
// import '../../../../../../core/consts/images.dart';
// import '../../../../../../core/navigator/named_navigator_impl.dart';
// import '../../../../../../core/services/di.dart';
// import '../../../../../../core/theme/colors/app_colors.dart';
// import '../../../../../../core/widgets/app_bar/custom_curved_appbar.dart';
// import '../../../../../../core/widgets/app_texts/app_text.dart';
// import '../../../../../../core/widgets/app_texts/text_scroll.dart';
// import '../../../../../../core/widgets/loader/app_loader.dart';
// import '../../../../../../core/widgets/ui_helpers/extensions.dart';
// import '../../../../../../models/quizes/library/get_subjects_chapters_response.dart';
// import '../../../../quizes/quize_screen.dart';
// import '../../../cubit/library_cubit/library_cubit.dart';

// class ChapterLessonsScreen extends StatelessWidget {
//   final GetSubjectChapters model;
//   final String subjectName;

//   const ChapterLessonsScreen(
//       {super.key, required this.model, required this.subjectName});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             AppTextScroll(
//               model.name ?? '',
//               size: 28.sp,
//               weight: w500,
//               color: AppColors.kWhite,
//               align: TextAlign.start,
//               mode: TextScrollMode.begin,
//             ),
//             AppText(
//               subjectName,
//               size: 20.sp,
//               weight: w400,
//               color: AppColors.kWhite,
//             ),
//           ],
//         ),
//       ),
//       body: BlocProvider(
//         create: (context) =>
//             di<LibraryCubit>()..getChapterLessons('${model.id}'),
//         child: BlocBuilder<LibraryCubit, LibraryState>(
//           builder: (context, state) {
//             final cubit = LibraryCubit.of(context);
//             final model = cubit.chapterLessons?.data;
//             if (state is GetChapterLessonsLoadingState)
//               return const AppLoader();
//             if (model?.isEmpty == true)
//               return Center(
//                   child:
//                       Lottie.asset(AppJsonFiles.emptyState, fit: BoxFit.fill));
//             if (state is GetChapterLessonsLoadingState) const AppLoader();
//             if (model?.isEmpty == true) {
//               Center(
//                   child:
//                       Lottie.asset(AppJsonFiles.emptyState, fit: BoxFit.fill));
//             }
//             return ListView.separated(
//               itemCount: model?.length ?? 0,
//               padding: EdgeInsets.only(top: 16.h),
//               separatorBuilder: (context, index) => 16.sbH,
//               itemBuilder: (context, i) {
//                 return GestureDetector(
//                   onTap: () {
//                     if (model?[i].id != null) {
//                       NamedNavigatorImpl.push(
//                         QuizScreen(
//                           id: model![i].id!,
//                           title: model[i].title ?? '',
//                           chapterTitle: model[i].chapter ?? '',
//                           subjectTitle: subjectName,
//                         ),
//                       );
//                     }
//                   },
//                   child: Container(
//                     width: double.infinity,
//                     margin: const EdgeInsets.symmetric(horizontal: 16),
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: AppColors.borderColor),
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CircleAvatar(
//                           radius: 30.r,
//                           backgroundColor:
//                               AppColors.textColor4.withOpacity(0.1),
//                           backgroundImage:
//                               CachedNetworkImageProvider('${model?[i].image}'),
//                         ),
//                         16.sbW,
//                         Container(
//                           constraints: BoxConstraints(
//                             maxWidth: MediaQuery.of(context).size.width * 0.63,
//                           ),
//                           child: Column(
//                             children: [
//                               AppText(
//                                 '${model?[i].title}',
//                                 maxLines: 2,
//                                 centerText: false,
//                                 overflow: TextOverflow.ellipsis,
//                                 color: AppColors.textColor,
//                                 size: 16.sp,
//                                 weight: w500,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
