// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lottie/lottie.dart';

// import '../../../../../../../../../core/consts/images.dart';
// import '../../../../../../../../../core/navigator/named_navigator_impl.dart';
// import '../../../../../../../../../core/widgets/loader/app_loader.dart';
// import '../../../../../../../../../core/widgets/ui_helpers/extensions.dart';
// import '../../../../../../widgets/show_all_widget.dart';
// import '../../../../cubit/courses_section_cubit.dart';
// import 'course_files_card.dart';
// import 'course_files_full_screen.dart';

// class CourseFilesSec extends StatelessWidget {
//   const CourseFilesSec({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CoursesSectionCubit, CoursesSectionState>(
//         builder: (context, state) {
//       final cubit = CoursesSectionCubit.of(context);
//       final model = cubit.attachmentResponse?.data;
//       if (state is CourseAttachmentLoadingState) return const AppLoader();
//       if (model == null || model.isEmpty) {
//         return Center(
//             child: Lottie.asset(AppJsonFiles.emptyState, fit: BoxFit.fill));
//       }
//       return Column(
//         children: [
//           ShowAllWidget('الملفات (${model.length})',
//               () => NamedNavigatorImpl.push(const CourseFilesFullScreen())),
//           16.sbH,
//           SizedBox(
//             height: 80.h,
//             child: ListView.separated(
//               shrinkWrap: true,
//               itemCount: model.length,
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               scrollDirection: Axis.horizontal,
//               separatorBuilder: (c, i) => 16.sbW,
//               itemBuilder: (c, i) => CourseFilesCard(model: model[i]),
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }
