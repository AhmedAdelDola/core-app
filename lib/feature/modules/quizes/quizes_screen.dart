// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../core/navigator/named_navigator_impl.dart';
// import '../../../core/services/di.dart';
// import '../../../core/theme/colors/app_colors.dart';
// import '../../../core/theme/theme.dart';
// import '../../../core/util/enums.dart';
// import '../../../core/widgets/app_buttons/master_button.dart';
// import '../../../core/widgets/app_texts/app_text.dart';
// import '../../../core/widgets/loader/app_loader.dart';
// import '../../../core/widgets/ui_helpers/bottom_sheet_helper.dart';
// import '../../../core/widgets/ui_helpers/extensions.dart';
// import '../../../models/quizes/create_quiz_response.dart';
// import '../../../models/quizes/library/get_all_subjects_response.dart';
// import '../library/library_imports.dart';
// import '../library/widgets/quizes_tab/exams_tab.dart';
// import 'cubit/create_quiz/create_quize_cubit.dart';

// class QuizesScreen extends StatefulWidget {
//   const QuizesScreen({super.key});

//   @override
//   State<QuizesScreen> createState() => _QuizesScreenState();
// }

// class _QuizesScreenState extends State<QuizesScreen>
//     with SingleTickerProviderStateMixin {
//   late final TabController _controller;

//   @override
//   void initState() {
//     _controller = TabController(length: 2, vsync: this);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => di<CreateQuizeCubit>(),
//       child: BlocBuilder<CreateQuizeCubit, CreateQuizeState>(
//           builder: (context, state) {
//         var cubit = CreateQuizeCubit.get(context);

//         return Scaffold(
//           floatingActionButtonLocation:
//               FloatingActionButtonLocation.centerFloat,

//           /// subscription_all_subjects == 1 hide btn
//           floatingActionButton: cubit.notSubscribedSubjects.isEmpty
//               ? null
//               : MasterButton(
//                   text: 'الاشتراك ف بنك الاسئلة',
//                   margin: EdgeInsets.symmetric(horizontal: 16.w),
//                   onPressed: () {
//                     BottomSheetHelper.showBottomSheet(context,
//                         child: const CreateQuizSheet());
//                   },
//                 ),
//           body: Column(
//             children: [
//               24.sbH,
//               Container(
//                 height: 48.h,
//                 width: double.infinity,
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 padding: EdgeInsets.all(4.sp),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF9FAFC),
//                   border: Border.all(
//                       color: AppColors.kPrimary.withOpacity(0.3), width: 2),
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: TabBar(
//                   physics: const NeverScrollableScrollPhysics(),
//                   controller: _controller,
//                   indicatorColor: Colors.transparent,
//                   indicator: BoxDecoration(
//                     color: AppColors.kWhite,
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   labelColor: AppColors.kPrimary,
//                   unselectedLabelColor: AppColors.textColor2,
//                   tabs: const [AppText('التدريبات'), AppText('الامتحانات')],
//                 ),
//               ),
//               24.sbH,
//               Expanded(
//                 child: TabBarView(
//                   controller: _controller,
//                   children: const [QuizesTab(), ExamsTab()],
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

// class CreateQuizSheet extends StatelessWidget {
//   const CreateQuizSheet({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           di<CreateQuizeCubit>()..getAllQuizeOptionsAndSubjects(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'تدريبات مادة علم القانون',
//                 style: TextStyles.textViewBold(size: 22.sp),
//               ),
//               Text(
//                 '15 ج.م',
//                 style: TextStyles.textViewRegular(
//                   color: AppColors.kPrimary,
//                   fontSize: 20.sp,
//                 ),
//               ),
//             ],
//           ),
//           24.sbH,
//           const QuizeSelectAllHeader(title: 'ابواب المادة'),
//           24.sbH,
//           Expanded(
//             child:
//                 BlocSelector<CreateQuizeCubit, CreateQuizeState, RequestStatus>(
//               builder: (context, state) {
//                 switch (state) {
//                   case RequestStatus.initial:
//                     return Container();
//                   case RequestStatus.loading:
//                     return const AppLoader();
//                   case RequestStatus.success:
//                     return const QuizOptionsListView();
//                   case RequestStatus.error:
//                     return Text(
//                       CreateQuizeCubit.get(context).state.errorMessage ??
//                           'حدث خطأ ما',
//                     );
//                 }
//               },
//               selector: (CreateQuizeState state) {
//                 return state.requestStatus;
//               },
//             ),
//           ),
//           BlocSelector<CreateQuizeCubit, CreateQuizeState, bool>(
//             selector: (state) {
//               return state.requestStatus == RequestStatus.success;
//             },
//             builder: (context, state) {
//               return ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(vertical: 16.sp)),
//                   onPressed: state
//                       ? () {
//                           NamedNavigatorImpl.pop();
//                           // Nav.push(const QuizeScreen(id:,));
//                         }
//                       : null,
//                   child: const Text('تأكيد'));
//             },
//           )
//         ],
//       ),
//     );
//   }
// }

// class QuizOptionsListView extends StatelessWidget {
//   const QuizOptionsListView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CreateQuizeCubit, CreateQuizeState>(
//       builder: (context, state) {
//         print('==========================================');
//         print('==========================================');
//         print(state.options);
//         if (state.options.isEmpty) {
//           return const Center(
//             child: Text('لا يوجد بيانات'),
//           );
//         }

//         return ListView.separated(
//           itemCount: state.options.length,
//           separatorBuilder: (context, index) => const Divider(),
//           itemBuilder: (BuildContext context, int index) {
//             return QuizOptionItem(quizOption: state.options[index]);
//           },
//         );
//       },
//     );
//   }
// }

// class QuizOptionItem extends StatelessWidget {
//   final GetAllSubjectsData quizOption;
//   const QuizOptionItem({super.key, required this.quizOption});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(child: Text(quizOption.name ?? '')),
//         Text(
//           '${quizOption.subjectPrice} ج.م',
//           style: TextStyles.textViewRegular(
//               color: AppColors.textColor3, fontSize: 16.sp),
//         ),
//         BlocSelector<CreateQuizeCubit, CreateQuizeState, bool>(
//           selector: (state) {
//             return state.options
//                 .firstWhere((e) => e.id == quizOption.id)
//                 .isSelected;
//           },
//           builder: (context, state) {
//             return Checkbox.adaptive(
//                 value: state,
//                 onChanged: (value) {
//                   context.read<CreateQuizeCubit>().toggleOption(quizOption);
//                 });
//           },
//         ),
//       ],
//     );
//   }
// }

// class QuizeSelectAllHeader extends StatelessWidget {
//   final String title;
//   const QuizeSelectAllHeader({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//             child: Text(
//           title,
//           style: TextStyles.textViewSemiBold(fontSize: 16.sp),
//         )),
//         Text(
//           'تحديد الكل',
//           style: TextStyles.textViewRegular(
//               fontWeight: FontWeight.w400,
//               color: AppColors.textColor2,
//               fontSize: 16.sp),
//         ),
//         BlocSelector<CreateQuizeCubit, CreateQuizeState, bool>(
//           selector: (state) {
//             return state.isSelectAll();
//           },
//           builder: (context, state) {
//             return Checkbox.adaptive(
//                 value: state,
//                 onChanged: (value) {
//                   context.read<CreateQuizeCubit>().toggleSelectAll();
//                 });
//           },
//         ),
//       ],
//     );
//   }
// }
