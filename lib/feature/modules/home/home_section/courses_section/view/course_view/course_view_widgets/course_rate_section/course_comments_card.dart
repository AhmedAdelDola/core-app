// import '../../../../../../../../../core/services/di.dart';
// import '../../../../../../../../../core/theme/colors/app_colors.dart';
// import '../../../../../../../../../core/widgets/app_texts/app_text.dart';
// import '../../../../../../../../../core/widgets/app_texts/text_scroll.dart';
// import '../../../../../../../../../core/widgets/ui_helpers/app_rating_bar.dart';
// import '../../../../../../../../../core/widgets/ui_helpers/extensions.dart';
// import '../../../../../../../../../models/home_entities/courses/get_course_rate_review_response.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CourseCommentsCard extends StatelessWidget {
//   final CourseRateFeedback? item;
//   const CourseCommentsCard({super.key, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final bool isTablet = screenWidth >= 600 && screenWidth < 900;
//     final bool isDesktop = screenWidth >= 900;
//     final bool isLargeScreen = isTablet || isDesktop;

//     return Container(
//       height: isLargeScreen ? 130 : 115.h,
//       width: isLargeScreen ? (isDesktop ? 380 : 360) : 347.w,
//       padding: EdgeInsets.symmetric(
//         horizontal: isLargeScreen ? 10 : 6,
//       ),
//       decoration: BoxDecoration(
//         color: userData?.student.id == item?.user?.id
//             ? AppColors.kPrimary.withOpacity(0.15)
//             : AppColors.kWhite,
//         borderRadius: BorderRadius.circular(isLargeScreen ? 12 : 12.r),
//         border: Border.all(color: AppColors.textFieldBorderColor),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: isLargeScreen ? (isDesktop ? 24 : 22) : null,
//             backgroundColor: AppColors.kPrimary.withOpacity(0.1),
//             backgroundImage: item?.user?.avatar != null
//                 ? CachedNetworkImageProvider(item?.user?.avatar ?? '')
//                 : null,
//             child: item?.user?.avatar != null
//                 ? null
//                 : AppText(
//                     item?.user?.name
//                             ?.split(' ')
//                             .map((e) => '${e[0]} ')
//                             .join() ??
//                         '',
//                     weight: w400,
//                     size: isLargeScreen ? (isDesktop ? 18 : 16) : 22.sp,
//                     color: AppColors.kPrimary,
//                   ),
//           ),
//           SizedBox(width: isLargeScreen ? (isDesktop ? 14 : 12) : 12.w),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                 vertical: isLargeScreen ? 10 : 8.h,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Row(
//                         children: [
//                           AppRatingBar(
//                             size: isLargeScreen ? (isDesktop ? 16 : 15) : 20,
//                             initialRating: double.tryParse(
//                                 item?.rate?.toString() ?? '0.0'),
//                             onRatingUpdate: null,
//                           ),
//                           SizedBox(width: isLargeScreen ? 6 : 4.w),
//                           AppText(
//                             item?.rate?.toString() ?? '0.0',
//                             size: isLargeScreen ? (isDesktop ? 13 : 12) : 14.sp,
//                             weight: w700,
//                             color: AppColors.textColor2,
//                           ),
//                         ],
//                       ),
//                       const Spacer(),
//                       AppText(
//                         item?.ratedAt ?? '',
//                         size: isLargeScreen ? (isDesktop ? 13 : 12) : 14.sp,
//                         weight: w400,
//                         color: AppColors.textColor2,
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: isLargeScreen ? 6 : 4.h),
//                   isLargeScreen
//                       ? AppText(
//                           item?.user?.name ?? '',
//                           size: isDesktop ? 15 : 14,
//                           weight: w700,
//                           align: TextAlign.start,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           color: AppColors.textColor,
//                         )
//                       : AppTextScroll(
//                           item?.user?.name ?? '',
//                           size: 16.sp,
//                           weight: w700,
//                           align: TextAlign.end,
//                           color: AppColors.textColor,
//                         ),
//                   SizedBox(height: isLargeScreen ? 6 : 4.h),
//                   Expanded(
//                     child: AppText(
//                       item?.feedback ?? '',
//                       size: isLargeScreen ? (isDesktop ? 13 : 12) : 14.sp,
//                       weight: w300,
//                       align: TextAlign.start,
//                       maxLines: isLargeScreen ? 3 : 2,
//                       overflow: TextOverflow.ellipsis,
//                       color: AppColors.textColor2,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
