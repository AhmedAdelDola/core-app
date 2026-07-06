part of '../../library_imports.dart';

class QuizesTab extends StatelessWidget {
  const QuizesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return LottieBuilder.asset(AppJsonFiles.emptyState, );
    
    
  //   BlocProvider<CreateQuizeCubit>(
  //     create: (context) => di<CreateQuizeCubit>()..getAllSubjects(),
  //     child: BlocBuilder<CreateQuizeCubit, CreateQuizeState>(
  //       builder: (context, state) {
  //         final cubit = CreateQuizeCubit.get(context);
  //         final model = cubit.subjects?.data?.data;
  //         if (state is GetAllSubjectsLoadingState) {
  //           return const AppLoader();
  //         }
  //         return ListView.separated(
  //           itemCount: model?.length ?? 0,
  //           separatorBuilder: (context, index) => 16.sbH,
  //           itemBuilder: (context, i) {
  //             return GestureDetector(
  //               onTap: () => model?[i].availability == 1
  //                   ? NamedNavigatorImpl.push(
  //                       ChaptersDetailsScreen(model: model![i]))
  //                   : showErrorToast('بنك الاسئلة غير متاح الان لهذة المادة'),
  //               child: Container(
  //                 width: double.infinity,
  //                 margin: const EdgeInsets.symmetric(horizontal: 16),
  //                 padding: const EdgeInsets.symmetric(horizontal: 16),
  //                 decoration: BoxDecoration(
  //                     border: Border.all(color: AppColors.borderColor),
  //                     borderRadius: BorderRadius.circular(12.r)),
  //                 child: Row(
  //                   children: [
  //                     Expanded(
  //                       child: CircleAvatar(
  //                           radius: 30.r,
  //                           backgroundColor:
  //                               AppColors.textColor4.withOpacity(0.1),
  //                           backgroundImage: CachedNetworkImageProvider(
  //                               model?[i].image ?? Strings.placeHolderImg)),
  //                     ),
  //                     16.sbW,
  //                     Expanded(
  //                       flex: 4,
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                         children: [
  //                           SizedBox(
  //                             width: MediaQuery.of(context).size.width * 0.63,
  //                             child: Row(
  //                               children: [
  //                                 AppText(
  //                                   model?[i].name ?? '',
  //                                   color: AppColors.textColor,
  //                                   size: 18.sp,
  //                                   weight: w500,
  //                                 ),
  //                                 const Spacer(),
  //                                 if (model?[i].isFree == 1)
  //                                   const PriceContainer(title: 'مجاني'),
  //                                 if (model?[i].availability == 0)
  //                                   const PriceContainer(title: 'غير متاح'),
  //                               ],
  //                             ),
  //                           ),
  //                           // 8.sbH,
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               AppText(
  //                                 'أكملت ${model?[i].percent}',
  //                                 color: AppColors.textColor2,
  //                                 size: 14.sp,
  //                                 weight: w400,
  //                               ),
  //                               Flexible(
  //                                 child: SizedBox(
  //                                   width: MediaQuery.of(context).size.width *
  //                                       0.45,
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
  //                               ),
  //                             ],
  //                           ),

  //                           8.sbH,
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }
}
}