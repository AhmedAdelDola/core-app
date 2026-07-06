// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../../../../core/consts/strings.dart';
// import '../../../../../../core/navigator/named_navigator_impl.dart';
// import '../../../../../../core/theme/colors/app_colors.dart';
// import '../../../../../../core/widgets/app_texts/app_text.dart';
// import '../../../../../../core/widgets/app_texts/text_scroll.dart';
// import '../../../../../../core/widgets/network_img.dart';
// import '../../../../../../core/widgets/ui_helpers/extensions.dart';
// import '../../../../../../models/home_entities/subject/get_subject.dart';
// import 'subject_courses_view.dart';

// class SubjectsCard extends StatelessWidget {
//   final GetSubjectsData? data;
//   const SubjectsCard({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         NamedNavigatorImpl.push(SubjectsCourseView(title: data?.name ?? '', id: '${data?.id}'));
//       },
//       child: Container(
//         height: 56.h,
//         margin: const EdgeInsets.only(right: 4),
//         child: Card(
//           elevation: 2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.r),
//             side: const BorderSide(color: AppColors.disabledBtnColor, width: 1),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: Row(
//               children: [
//                 NetworkImagesWidgets(
//                   url: data?.image ?? Strings.placeHolderImg,
//                   height: 22.h,
//                   width: 22.w,
//                   fit: BoxFit.fill,
//                 ),
//                 6.sbW,
//                 Container(
//                   constraints: BoxConstraints(maxWidth: 120.w),
//                   child: AppTextScroll(
//                     data?.name ?? '',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     align: TextAlign.center,
//                     size: 16,
//                     weight: bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
