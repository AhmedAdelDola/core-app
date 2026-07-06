// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

// import '../../../../../../core/consts/strings.dart';
// import '../../../../../../core/navigator/named_navigator_impl.dart';
// import '../../../../../../core/services/di.dart';
// import '../../../../../../core/theme/colors/app_colors.dart';
// import '../../../../../../core/widgets/app_bar/custom_curved_appbar.dart';
// import '../../../../../../core/widgets/app_texts/app_text.dart';
// import '../../../../../../core/widgets/network_img.dart';
// import '../../../../../../models/home_entities/subject/get_subject.dart';
// import '../../../cubit/home_cubit/home_cubit.dart';
// import '../cubit/subjects_section_cubit.dart';
// import 'subject_courses_view.dart';

// class SubjectsScreen extends StatefulWidget {
//   final List<GetSubjectsData>? subjects;

//   const SubjectsScreen({super.key, this.subjects});

//   @override
//   State<SubjectsScreen> createState() => _SubjectsScreenState();
// }

// class _SubjectsScreenState extends State<SubjectsScreen> {
//   final RefreshController _refreshController =
//       RefreshController(initialRefresh: false);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar(title: 'المواد الدراسية'),
//       body: SmartRefresher(
//         controller: _refreshController,
//         onRefresh: () async {
//           await Future.delayed(const Duration(milliseconds: 500));
//           di<HomeCubit>().getSubjects();
//           _refreshController.refreshCompleted();
//         },
//         child: GridView.builder(
//           padding: const EdgeInsets.all(8),
//           gridDelegate: sliverGridDelegate,
//           itemCount: widget.subjects?.length ?? 0,
//           itemBuilder: (context, index) {
//             return GestureDetector(
//               onTap: () {
//                 NamedNavigatorImpl.push(
//                   BlocProvider.value(
//                     value: di<SubjectsSectionCubit>()
//                       ..getSubjectCourses('${widget.subjects?[index].id}'),
//                     child: SubjectsCourseView(
//                       title: widget.subjects?[index].name ?? '',
//                       id: '${widget.subjects?[index].id}',
//                     ),
//                   ),
//                 );
//               },
//               child: Card(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     NetworkImagesWidgets(
//                       url: widget.subjects?[index].image ??
//                           Strings.placeHolderImg,
//                       height: 22.h,
//                       width: 22.w,
//                       errorWidget: (p0, p1, p2) => Icon(Icons.menu_book_sharp,
//                           color: AppColors.kPrimary),
//                     ),
//                     AppText(
//                       widget.subjects![index].name ?? '',
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       size: 16.sp,
//                       weight: w500,
//                       color: AppColors.textColor2,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   SliverGridDelegateWithFixedCrossAxisCount get sliverGridDelegate {
//     return const SliverGridDelegateWithFixedCrossAxisCount(
//       mainAxisSpacing: 16,
//       crossAxisSpacing: 16,
//       crossAxisCount: 2,
//       childAspectRatio: 1.3,
//     );
//   }
// }
