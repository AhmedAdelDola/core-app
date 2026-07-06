// import '../../../../../../models/home_entities/subject/subject_courses_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../../../../core/navigator/named_navigator_impl.dart';
// import '../../../../../../core/theme/colors/app_colors.dart';
// import '../../../../../../core/theme/theme.dart';
// import '../../../../../../core/widgets/app_texts/app_text.dart';
// import '../../../../../../core/widgets/network_img.dart';
// import '../../../../../../core/widgets/ui_helpers/app_rating_bar.dart';
// import '../../../../../../core/widgets/ui_helpers/extensions.dart';
// import '../../courses_section/view/course_view/course_view.dart';
// import '../../courses_section/widgets/floating_text_on_img.dart';

// class SubjectsCourseCard extends StatelessWidget {
//   final SubjectCourses? data;
//   const SubjectsCourseCard({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         NamedNavigatorImpl.push(CourseViewScreen(id: data?.id ?? 0));
//       },
//       child: Container(
//         height: 290.h,
//         width: MediaQuery.of(context).size.width * 0.75,
//         margin: EdgeInsets.all(10.sp),
//         child: Card(
//           elevation: 4,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               FloatingTextOnImg(img: data?.sliders, isFree: data?.isFree ?? 0),
//               Padding(
//                 padding: EdgeInsets.only(right: 12.w, top: 20.h),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         AppRatingBar(
//                           size: 20,
//                           initialRating: double.tryParse('${data?.rating?.rate ?? 0.0}'),
//                           onRatingUpdate: null,
//                         ),
//                         8.sbW,
//                         AppText(
//                           '${data?.rating?.totalRate ?? 0.0}',
//                           textDirection: TextDirection.ltr,
//                           style: TextStyles.textViewMedium(color: AppColors.textColor5),
//                         ),
//                       ],
//                     ),
//                     5.sbH,
//                     AppText(
//                       data?.title ?? '',
//                       size: 18.sp,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       color: AppColors.textColor,
//                       centerText: false,
//                     ),
//                     5.sbH,
//                     Row(
//                       children: [
//                         NetworkImagesWidgets(
//                           url: data?.teacher?.avatar ?? '',
//                           height: 32.h,
//                           width: 32.w,
//                         ),
//                         8.sbW,
//                         AppText(
//                           data?.teacher?.name ?? '',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyles.textViewMedium(color: AppColors.textColor5),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
