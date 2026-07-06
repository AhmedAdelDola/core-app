// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

// import '../../../../../../core/services/di.dart';
// import '../../../../../../core/widgets/app_bar/custom_curved_appbar.dart';
// import '../../../../../../core/widgets/loader/app_loader.dart';
// import '../cubit/subjects_section_cubit.dart';
// import '../widgets/no_subjects_widget.dart';
// import 'subject_courses_card.dart';

// class SubjectsCourseView extends StatelessWidget {
//   final String title, id;

//   const SubjectsCourseView({super.key, required this.title, required this.id});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: title),
//       body: BlocProvider(
//         create: (context) => di<SubjectsSectionCubit>()..getSubjectCourses(id),
//         child: BlocBuilder<SubjectsSectionCubit, SubjectsSectionState>(
//           builder: (context, state) {
//             final cubit = SubjectsSectionCubit.of(context);
//             final model = cubit.subjectCoursesModel?.data;
//             if (state is GetSubjectCoursesLoadingState) return const AppLoader();
//             return SmartRefresher(
//               controller: cubit.refreshController,
//               onRefresh: () async {
//                 await Future.delayed(const Duration(milliseconds: 500)).whenComplete(() {
//                   cubit.getSubjectCourses(id);
//                   cubit.refreshController.refreshCompleted();
//                 });
//               },
//               child: model?.isEmpty ?? true
//                   ? const NoSubjectsWidget()
//                   : ListView.builder(
//                       itemCount: model?.length ?? 0,
//                       itemBuilder: (context, index) {
//                         final data = model?[index];
//                         return SubjectsCourseCard(data: data);
//                       },
//                     ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
