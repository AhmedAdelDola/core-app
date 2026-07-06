// part of '../../../library_imports.dart';

// class ChaptersDetailsScreen extends StatelessWidget {
//   final GetAllSubjectsData model;

//   const ChaptersDetailsScreen({super.key, required this.model});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: model.name ?? ''),
//       floatingActionButton: ElevatedButton.icon(
//         icon: const Icon(Icons.add_circle),
//         label: const Text('إنشاء امتحان'),
//         onPressed: () {
//           BottomSheetHelper.showBottomSheet(context,
//               child: const CreateQuizSheet());
//         },
//       ),
//       body: BlocProvider(
//         create: (context) =>
//             di<LibraryCubit>()..getAllSubjectsChapters('${model.id}'),
//         child: BlocBuilder<LibraryCubit, LibraryState>(
//           builder: (context, state) {
//             final cubit = LibraryCubit.of(context);
//             final model = cubit.subjectChapters?.data;
//             if (state is GetAllSubjectsChaptersLoadingState) {
//               return const AppLoader();
//             }
//             if (model?.isEmpty ?? true) {
//               return Center(child: Lottie.asset(AppJsonFiles.emptyState, fit: BoxFit.fill));

//             }
//             return ListView.separated(
//               itemCount: model!.length,
//               padding: EdgeInsets.only(top: 16.h),
//               separatorBuilder: (context, index) => 16.sbH,
//               itemBuilder: (context, i) {
//                 return GestureDetector(
//                   onTap: () {
//                     if (model[i].id != null) {
//                       NamedNavigatorImpl.push(
//                         ChapterLessonsScreen(
//                           model: model[i],
//                           subjectName: this.model.name ?? '',
//                         ),
//                       );
//                     }
//                   },
//                   child: Container(
//                     width: double.infinity,
//                     margin: EdgeInsets.symmetric(horizontal: 16.w),
//                     padding: EdgeInsets.symmetric(horizontal: 16.w),
//                     decoration: BoxDecoration(
//                         border: Border.all(color: AppColors.borderColor),
//                         borderRadius: BorderRadius.circular(12.r)),
//                     child: Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 30.r,
//                           backgroundColor:
//                               AppColors.textColor4.withOpacity(0.1),
//                           backgroundImage: CachedNetworkImageProvider(
//                               model[i].image ?? Strings.placeHolderImg),
//                         ),
//                         16.sbW,
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Container(
//                               constraints: BoxConstraints(
//                                   maxWidth:
//                                       MediaQuery.of(context).size.width * 0.63),
//                               child: AppText(
//                                 model[i].name!.trim(),
//                                 maxLines: 2,
//                                 centerText: false,
//                                 overflow: TextOverflow.ellipsis,
//                                 withOverFlow: true,
//                                 color: AppColors.textColor,
//                                 size: 16.sp,
//                                 weight: w500,
//                               ),
//                             ),
//                             8.sbH,
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 AppText(
//                                   'أكملت ${model[i].percent}',
//                                   color: AppColors.textColor2,
//                                   size: 14.sp,
//                                   weight: w400,
//                                 ),
//                                 SizedBox(
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.45,
//                                   child: LinearPercentIndicator(
//                                     lineHeight: 8.h,
//                                     percent: double.tryParse(
//                                             model?[i].percent ?? '') ??
//                                         0.0,
//                                     barRadius: Radius.circular(12.r),
//                                     isRTL: true,
//                                     progressColor: AppColors.kPrimary,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             16.sbH,
//                           ],
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
