// import '../../../../../../../../../core/navigator/named_navigator_impl.dart';
// import '../../../../../../../../../core/widgets/loader/app_loader.dart';
// import '../../../../../../../../../core/widgets/ui_helpers/extensions.dart';
// import '../../../../cubit/courses_section_cubit.dart';
// import '../../../../../../widgets/show_all_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'course_comments_card.dart';
// import 'course_comments_full_screen.dart';

// class CourseComments extends StatelessWidget {
//   const CourseComments({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CoursesSectionCubit, CoursesSectionState>(
//       builder: (context, state) {
//         final cubit = CoursesSectionCubit.of(context);
//         final courseRate = cubit.courseData.;
//         if (state is GetCourseRateReviewLoadingState) return const AppLoader();
//         return cubit.courseRateReview == null
//             ? const SizedBox()
//             : Column(
//                 children: [
//                   ShowAllWidget(
//                     'اراء المشاركين '
//                     '(${courseRate?.data?.numberOfReviews ?? 0})',
//                     () => NamedNavigatorImpl.push(
//                         CourseCommentsFullScreen(model: courseRate?.data)),
//                   ),
//                   16.sbH,
//                   SizedBox(
//                     height: 115.h,
//                     child: ListView.separated(
//                       shrinkWrap: true,
//                       itemCount: courseRate?.data?.feedbacks?.length ?? 0,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       scrollDirection: Axis.horizontal,
//                       separatorBuilder: (c, i) => 16.sbW,
//                       itemBuilder: (context, i) {
//                         return CourseCommentsCard(
//                             item: courseRate?.data?.feedbacks?[i]);
//                       },
//                     ),
//                   ),
//                 ],
//               );
//       },
//     );
//   }
// }
