// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

// import '../../../core/services/di.dart';
// import '../../../core/theme/colors/app_colors.dart';
// import '../../../core/theme/theme.dart';
// import '../../../core/util/enums.dart';
// import '../../../core/widgets/app_bar/custom_curved_appbar.dart';
// import '../../../core/widgets/app_texts/app_text.dart';
// import '../../../core/widgets/app_texts/text_scroll.dart';
// import '../../../core/widgets/loader/app_loader.dart';
// import '../../../core/navigator/named_navigator_impl.dart';
// import '../../../../../models/exams/get_exam_questions.dart';
// import 'exam_cubit/exam/exam_cubit.dart';
// import 'exam_cubit/submit_question/submit_exam_question_cubit.dart';

// /// -------------------------
// ///  MAIN EXAM SCREEN
// /// -------------------------
// class ExamScreen extends StatefulWidget {
//   final int id;
//   final String? title, chapterTitle, subjectTitle;
//   final Duration duration;
//   final bool showResults;

//   const ExamScreen({
//     super.key,
//     required this.id,
//     this.title,
//     this.chapterTitle,
//     this.subjectTitle,
//     this.duration = const Duration(minutes: 30),
//     this.showResults = false,
//   });

//   @override
//   State<ExamScreen> createState() => _ExamScreenState();
// }

// class _ExamScreenState extends State<ExamScreen> {
//   late Duration remaining;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     remaining = widget.duration;

//     if (!widget.showResults) {
//       _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//         if (mounted) {
//           setState(() {
//             if (remaining.inSeconds > 0) {
//               remaining -= const Duration(seconds: 1);
//             } else {
//               timer.cancel();
//               _submitExam();
//             }
//           });
//         }
//       });
//     }
//   }

//   void _submitExam() {
//     context.read<ExamCubit>().endExam(widget.id.toString());
//     NamedNavigatorImpl.pop();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     String formattedTime =
//         "${remaining.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(remaining.inSeconds.remainder(60)).toString().padLeft(2, '0')}";

//     return QuizScreen(
//       id: widget.id,
//       title: widget.title,
//       chapterTitle: widget.chapterTitle,
//       subjectTitle: widget.subjectTitle,
//       timerWidget: !widget.showResults
//           ? Text(
//               "الوقت المتبقي: $formattedTime",
//               style: TextStyles.textViewSemiBold(
//                 color: AppColors.kWhite,
//                 fontSize: 18.sp,
//               ),
//             )
//           : null,
//       showResults: widget.showResults,
//     );
//   }
// }

// /// -------------------------
// ///  QUIZ SCREEN
// /// -------------------------
// class QuizScreen extends StatelessWidget {
//   final int id;
//   final String? title, chapterTitle, subjectTitle;
//   final Widget? timerWidget;
//   final bool showResults;

//   const QuizScreen({
//     super.key,
//     required this.id,
//     this.title,
//     this.chapterTitle,
//     this.subjectTitle,
//     this.timerWidget,
//     this.showResults = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<ExamCubit>(
//           create: (context) =>
//               di<ExamCubit>()..getExamQuestions(id: id.toString(), page: 1),
//         ),
//         BlocProvider<SubmitExamQuestionCubit>(
//           create: (context) => di<SubmitExamQuestionCubit>(),
//         ),
//       ],
//       child: Scaffold(
//         appBar: CustomAppBar(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               if (timerWidget != null)
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: timerWidget!,
//                 ),
//               AppTextScroll(
//                 title ?? '',
//                 size: 28.sp,
//                 weight: w500,
//                 color: AppColors.kWhite,
//               ),
//               AppTextScroll(
//                 '$chapterTitle - $subjectTitle',
//                 size: 20.sp,
//                 weight: w400,
//                 color: AppColors.kWhite,
//               ),
//             ],
//           ),
//         ),
//         body: BlocBuilder<ExamCubit, ExamState>(
//           builder: (context, state) {
//             if (state.requestStatus == RequestStatus.loading) {
//               return const AppLoader();
//             } else if (state.requestStatus == RequestStatus.error) {
//               return Center(child: Text(state.errorMessage ?? 'حدث خطأ ما'));
//             } else if (state.examQuestions.isEmpty) {
//               return const Center(child: Text('لا توجد أسئلة حالياً'));
//             }
//             return QuizPageView(id: id, showResults: showResults);
//           },
//         ),
//       ),
//     );
//   }
// }

// /// -------------------------
// ///  QUIZ PAGE VIEW
// /// -------------------------
// class QuizPageView extends StatefulWidget {
//   final int id;
//   final bool showResults;

//   const QuizPageView({super.key, required this.id, required this.showResults});

//   @override
//   _QuizPageViewState createState() => _QuizPageViewState();
// }

// class _QuizPageViewState extends State<QuizPageView> {
//   late PageController _pageController;

//   @override
//   void initState() {
//     super.initState();
//     final examCubit = context.read<ExamCubit>();
//     _pageController = PageController();
//     examCubit.updateCurrentQuestionIndex(0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ExamCubit, ExamState>(
//       builder: (context, state) {
//         final totalQuestions = state.examQuestions.length;
//         return Column(
//           children: [
//             IndicatorWidget(pageController: _pageController),
//             Expanded(
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemCount: totalQuestions,
//                 onPageChanged: (index) {
//                   context.read<ExamCubit>().updateCurrentQuestionIndex(index);
//                 },
//                 itemBuilder: (context, index) {
//                   final question = state.examQuestions[index];
//                   return SingleChildScrollView(
//                     child: Container(
//                       margin: EdgeInsets.all(16.sp),
//                       padding: EdgeInsets.all(16.sp),
//                       decoration: BoxDecoration(
//                         color: AppColors.kWhite,
//                         borderRadius: BorderRadius.circular(16.sp),
//                       ),
//                       child: QuizQuestionWidget(
//                         question: question,
//                         quizId: widget.id,
//                         showResults: widget.showResults,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// /// -------------------------
// ///  QUIZ QUESTION WIDGET
// /// -------------------------
// class QuizQuestionWidget extends StatelessWidget {
//   final QuestionData question;
//   final int quizId;
//   final bool showResults;

//   const QuizQuestionWidget({
//     super.key,
//     required this.question,
//     required this.quizId,
//     required this.showResults,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final studentAnswerId = question.studentAnswer?.id;
//     final trueAnswerId = question.trueAnswer?.id;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Text(
//           'السؤال #${context.read<ExamCubit>().state.currentQuestionIndex + 1}',
//           style: TextStyles.textViewSemiBold(
//             color: AppColors.textColor,
//             fontSize: 18.sp,
//           ),
//         ),
//         SizedBox(height: 12.sp),
//         HtmlWidget(
//           question.title ?? '',
//           renderMode: RenderMode.column,
//           textStyle: TextStyles.textViewRegular(
//             color: AppColors.textColor,
//             fontSize: 16.sp,
//           ),
//         ),
//         if (question.image != null && question.image!.isNotEmpty)
//           Padding(
//             padding: EdgeInsets.only(top: 8.sp),
//             child: Image.network(
//               question.image!,
//               width: 150.sp,
//               height: 150.sp,
//             ),
//           ),
//         SizedBox(height: 12.sp),

//         /// Answer Options
//         Column(
//           children: (question.answers ?? []).map((answer) {
//             final isSelected =
//                 question.studentAnswer?.id == answer.id; // Student’s choice
//             final isCorrect = question.trueAnswer?.id == answer.id; // True one

//             Color bgColor = AppColors.kWhite;
//             Color textColor = AppColors.textColor2;
//             Color borderColor = AppColors.borderColor;

//             if (showResults) {
//               if (isCorrect) {
//                 bgColor = Colors.green.withOpacity(0.1);
//                 textColor = Colors.green;
//                 borderColor = Colors.green;
//               } else if (isSelected && !isCorrect) {
//                 bgColor = Colors.red.withOpacity(0.1);
//                 textColor = Colors.red;
//                 borderColor = Colors.red;
//               }
//             } else if (isSelected) {
//               bgColor = AppColors.kPrimary;
//               textColor = AppColors.kWhite;
//             }

//             return GestureDetector(
//               onTap: showResults
//                   ? null
//                   : () => context.read<ExamCubit>().selectAnswer(answer.id!),
//               child: Container(
//                 padding:
//                     EdgeInsets.symmetric(vertical: 12.sp, horizontal: 16.sp),
//                 margin: EdgeInsets.only(bottom: 12.sp),
//                 decoration: BoxDecoration(
//                   color: bgColor,
//                   borderRadius: BorderRadius.circular(12.sp),
//                   border: Border.all(color: borderColor),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         answer.title ?? '',
//                         style: TextStyles.textViewRegular(
//                           fontSize: 16.sp,
//                           color: textColor,
//                         ),
//                       ),
//                     ),
//                     Icon(
//                       isSelected
//                           ? Icons.radio_button_checked
//                           : Icons.radio_button_off,
//                       color: textColor,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }

// /// -------------------------
// ///  PROGRESS INDICATOR
// /// -------------------------
// class IndicatorWidget extends StatelessWidget {
//   final PageController pageController;
//   const IndicatorWidget({super.key, required this.pageController});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 24.sp),
//       child: BlocSelector<ExamCubit, ExamState, int>(
//         selector: (state) => state.currentQuestionIndex,
//         builder: (context, index) {
//           final examCubit = context.read<ExamCubit>();
//           final total = examCubit.state.examQuestions.length;
//           return Row(
//             children: [
//               Expanded(
//                 child: LinearProgressIndicator(
//                   color: AppColors.kGreen,
//                   minHeight: 12.sp,
//                   borderRadius: BorderRadius.circular(8.sp),
//                   backgroundColor: AppColors.indicatorBg,
//                   value: total == 0 ? 0 : (index + 1) / total,
//                 ),
//               ),
//               SizedBox(width: 16.sp),
//               Text(
//                 '${index + 1}/$total',
//                 style: TextStyles.textViewSemiBold(
//                   color: AppColors.textColor3,
//                   fontSize: 16.sp,
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
