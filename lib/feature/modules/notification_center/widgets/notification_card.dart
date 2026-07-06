// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../../core/theme/colors/app_colors.dart';
// import '../../../../core/theme/theme.dart';
// import '../../../../core/widgets/app_texts/app_text.dart';
// import '../../../../core/widgets/network_img.dart';
// import '../../../../core/widgets/ui_helpers/extensions.dart';
// import '../../../../models/profile/get_notifications_response.dart';

// class NotificationCard extends StatelessWidget {
//   final AppNotification item;
//   const NotificationCard(this.item, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white,
//       margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 14.w),
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
//         child: Row(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: AppColors.kPrimary),
//               ),
//               child: CircleAvatar(
//                 radius: 25.r,
//                 backgroundColor: AppColors.kWhite,
//                 child: CachedNetworkImage(
//                   imageUrl: item.image?.toString() ?? '',
//                   imageBuilder: (context, img) => Container(
//                     width: 40.w,
//                     height: 40.h,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       image: DecorationImage(image: img, fit: BoxFit.contain),
//                     ),
//                   ),
//                   errorWidget: errorIconImage,
//                 ),
//               ),
//             ),
//             16.sbW,
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Container(
//                   constraints: BoxConstraints(maxWidth: 280.w),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       AppText(
//                         '${item.title}',
//                         style: TextStyles.textViewMedium().copyWith(color: AppColors.textColor3),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       AppText(
//                         item.createdAt?.toDateFormat(
//                               format: 'dd/M/yyyy',
//                               locale: 'en',
//                             ) ??
//                             '',
//                         style: TextStyles.textViewMedium().copyWith(color: AppColors.kPrimary),
//                       ),
//                     ],
//                   ),
//                 ),
//                 10.sbH,
//                 Container(
//                   constraints: BoxConstraints(maxWidth: 280.w),
//                   child: AppText(
//                     '${item.message}',
//                     color: AppColors.hintColor,
//                     size: 14.sp,
//                     weight: w500,
//                     maxLines: 4,
//                     centerText: false,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
