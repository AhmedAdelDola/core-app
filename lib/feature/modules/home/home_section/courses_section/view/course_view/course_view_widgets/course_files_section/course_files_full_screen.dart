// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lottie/lottie.dart';

// import '../../../../../../../../../core/consts/images.dart';
// import '../../../../../../../../../core/widgets/app_bar/custom_curved_appbar.dart';
// import '../../../../../../../../../core/widgets/loader/app_loader.dart';
// import '../../../../../../../../../core/widgets/ui_helpers/extensions.dart';
// import '../../../../cubit/courses_section_cubit.dart';
// import 'course_files_card.dart';

// class CourseFilesFullScreen extends StatelessWidget {
//   const CourseFilesFullScreen({super.key});

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
//       return Scaffold(
//         appBar: const CustomAppBar(title: 'الملفات'),
//         body: ListView.separated(
//           itemCount: model.length,
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           scrollDirection: Axis.vertical,
//           separatorBuilder: (c, i) => 16.sbH,
//           itemBuilder: (c, i) => CourseFilesCard(model: model[i]),
//         ),
//       );
//     });
//   }
// }
