// import '../../../../../../core/navigator/named_navigator_impl.dart';
// import 'subjects_card.dart';
// import '../widgets/no_subjects_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../../../core/widgets/app_buttons/state_conditional_builder.dart';
// import '../../../../../../core/widgets/loader/app_loader.dart';
// import '../../../../../../core/widgets/ui_helpers/extensions.dart';
// import '../../../cubit/home_cubit/home_cubit.dart';
// import '../../../widgets/show_all_widget.dart';
// import 'all_subjects_screen.dart';

// class SubjectsSection extends StatelessWidget {
//   const SubjectsSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeCubit, HomeStates>(
//       builder: (context, state) {
//         final cubit = HomeCubit.of(context);
//         final data = cubit.?.data;
//         return StateConditionalBuilder(
//           loadingCondition: state is GetSubjectsLoadingState,
//           errorBuilder: (_) => const NoSubjectsWidget(),
//           errorCondition: state is GetSubjectsErrorState,
//           loadingBuilder: (_) => const AppLoader(),
//           fallback: (_) {
//             return Column(
//               children: [
//                 ShowAllWidget(
//                   'المواد الدراسية',
//                   () => NamedNavigatorImpl.push(SubjectsScreen(subjects: data)),
//                 ),
//                 16.sbH,
//                 SizedBox(
//                   width: double.infinity,
//                   height: 56.h,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: data?.length ?? 0,
//                     itemBuilder: (c, i) => SubjectsCard(data: data?[i]),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }
