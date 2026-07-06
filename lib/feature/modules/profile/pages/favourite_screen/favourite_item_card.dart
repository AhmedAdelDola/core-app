// part of '../../profile_imports.dart';

// class FavouriteItem extends StatelessWidget {
//   final Function() onTabRemoveFav;

//   const FavouriteItem({super.key, required this.onTabRemoveFav});

//   @override
//   Widget build(BuildContext context) {
//     num initialRating = 1;
//     int studentsCount = 10;
//     return BlocProvider(
//       create: (context) => di<GetFavCoursesCubit>()..getFavCourses(),
//       child: BlocBuilder<GetFavCoursesCubit, GetFavCoursesState>(
//         builder: (context, state) {
//           return Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: SizedBox(
//               width: 382.w,
//               height: 289.h,
//               child: Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Stack(
//                       children: [
//                         const ImgPlaceHolder(),
//                         const ImgPlaceHolderCourseState(),
//                         ImgPlaceHolderRemoveFav(onTabRemoveFav: onTabRemoveFav),
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(right: 12, top: 20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               AppRatingBar(
//                                 size: 20,
//                                 initialRating: double.tryParse('$initialRating'),
//                                 onRatingUpdate: null,
//                               ),
//                               8.sbW,
//                               AppText(
//                                 '$initialRating ($studentsCount)',
//                                 textDirection: TextDirection.ltr,
//                                 style: TextStyles.textViewMedium(color: AppColors.textColor5),
//                               ),
//                             ],
//                           ),
//                           AppText(
//                             'Course Title',
//                             style: TextStyles.textViewMedium(
//                               color: AppColors.textColor,
//                               fontSize: 20.sp,
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               SvgPicture.asset(AppImages.favDoctorIcon),
//                               8.sbW,
//                               AppText(
//                                 'doctor name',
//                                 style: TextStyles.textViewMedium(color: AppColors.textColor5),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
