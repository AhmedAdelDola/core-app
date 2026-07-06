// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../../../../../../../core/services/di.dart';
// import '../../../../../../../../../core/theme/colors/app_colors.dart';
// import '../../../../../../../../../core/widgets/app_bar/custom_curved_appbar.dart';
// import '../../../../../../../../../core/widgets/app_buttons/custom_button.dart';
// import '../../../../../../../../../core/widgets/app_texts/app_text.dart';
// import '../../../../../../../../../core/widgets/ui_helpers/app_rating_bar.dart';
// import '../../../../../../../../../core/widgets/ui_helpers/extensions.dart';
// import '../../../../../../../../../models/home_entities/courses/get_course_rate_review_response.dart';
// import 'course_comments_card.dart';
// import 'course_reviews_row.dart';

// class CourseCommentsFullScreen extends StatelessWidget {
//   final CourseRateReviewData? model;

//   const CourseCommentsFullScreen({super.key, required this.model});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar(title: 'اراء المشاركين'),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         padding: const EdgeInsets.only(bottom: 40),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 AppText(
//                   model?.numberOfReviews.toString() ?? '',
//                   size: 56.sp,
//                   weight: w700,
//                   color: AppColors.textColor,
//                 ),
//               ],
//             ),
//             AppRatingBar(
//               size: 34,
//               initialRating: double.tryParse('${model?.rate ?? 0.0}'),
//               onRatingUpdate: null,
//             ),
//             12.sbH,
//             AppText(
//               'Based on ${model?.numberOfReviews} reviews',
//               size: 16.sp,
//               weight: w400,
//               color: AppColors.textColor2,
//             ),
//             CourseReviewsRow(
//               title: 'Excellent',
//               userNumber: model?.excellentRatesCount.toString() ?? '',
//               percentage: ((model?.excellentRatesCount ?? 0 / (model?.numberOfReviews ?? 0)) * 100),
//             ),
//             CourseReviewsRow(
//               title: 'Very Good',
//               userNumber: model?.veryGoodRatesCount.toString() ?? '',
//               percentage: ((model?.veryGoodRatesCount ?? 0 / (model?.numberOfReviews ?? 0)) * 100),
//             ),
//             CourseReviewsRow(
//               title: 'Average',
//               userNumber: model?.averageRatesCount.toString() ?? '',
//               percentage: ((model?.averageRatesCount ?? 0 / (model?.numberOfReviews ?? 0)) * 100),
//             ),
//             CourseReviewsRow(
//               title: 'Poor',
//               userNumber: model?.poorRatesCount.toString() ?? '',
//               percentage: ((model?.poorRatesCount ?? 0 / (model?.numberOfReviews ?? 0)) * 100),
//             ),
//             CourseReviewsRow(
//               title: 'Terrible',
//               userNumber: model?.terribleRatesCount.toString() ?? '',
//               percentage: ((model?.terribleRatesCount ?? 0 / (model?.numberOfReviews ?? 0)) * 100),
//             ),
//             40.sbH,
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: Row(
//                 children: [
//                   AppText(
//                     'اراء المشاركين',
//                     size: 16.sp,
//                     weight: w700,
//                     color: AppColors.textColor,
//                   ),
//                 ],
//               ),
//             ),
//             21.sbH,
//             ListView.separated(
//               itemCount: model?.feedbacks?.length ?? 0,
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               scrollDirection: Axis.vertical,
//               separatorBuilder: (c, i) => 16.sbH,
//               itemBuilder: (c, i) => CourseCommentsCard(item: model?.feedbacks?[i]),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar:
//           model?.feedbacks?.any((element) => element.user?.id == userData?.student.id) ?? true
//               ? 0.sbH
//               : Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: CustomButton(
//                     text: 'تقييم الكورس',
//                     onTap: () {},
//                   ),
//                 ),
//     );
//   }
// }
