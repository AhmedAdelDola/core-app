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
// import '../../../models/quizes/quize_questions_response.dart';
// import 'cubit/quize/quize_cubit.dart';
// import 'cubit/submit_question/submit_question_cubit.dart';
// import '../../../core/navigator/named_navigator_impl.dart';

// class QuizScreen extends StatelessWidget {
//   final int id;
//   final String? title, chapterTitle, subjectTitle;
//   const QuizScreen(
//       {super.key,
//       required this.id,
//       this.title,
//       this.chapterTitle,
//       this.subjectTitle});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<QuizeCubit>(
//           create: (context) =>
//               di<QuizeCubit>()..getQuizeQuestions(id: id, page: 1),
//         ),
//         BlocProvider<SubmitQuestionCubit>(
//           create: (context) => di<SubmitQuestionCubit>(),
//         ),
//       ],
//       child: Scaffold(
//         appBar: CustomAppBar(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               AppTextScroll(
//                 title ?? '',
//                 size: 28.sp,
//                 weight: w500,
//                 color: AppColors.kWhite,
//                 align: TextAlign.start,
//                 mode: TextScrollMode.begin,
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
//         body: BlocSelector<QuizeCubit, QuizeState, RequestStatus>(
//           selector: (state) => state.requestStatus,
//           builder: (context, state) {
//             switch (state) {
//               case RequestStatus.initial:
//                 return const SizedBox.shrink();
//               case RequestStatus.loading:
//                 return const AppLoader();
//               case RequestStatus.success:
//                 return QuizPageView(id: id);
//               case RequestStatus.error:
//                 return AppText(
//                   QuizeCubit.get(context).state.errorMessage ?? '',
//                 );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// class QuizPageView extends StatefulWidget {
//   final int id;
//   const QuizPageView({super.key, required this.id});

//   @override
//   _QuizPageViewState createState() => _QuizPageViewState();
// }

// class _QuizPageViewState extends State<QuizPageView> {
//   late PageController _pageController;
//   bool buttonClicked = false;
//   bool wrongAnswerSelected = false;
//   DateTime? wrongAnswerTime;
//   Map<int, bool> questionAutoNavigatedMap =
//       {}; // Track auto-navigated questions

//   @override
//   void initState() {
//     super.initState();
//     final quizeCubit = context.read<QuizeCubit>();

//     // Find the index of the first unanswered question
//     final firstUnansweredIndex = quizeCubit.state.quizeQuestions
//         .indexWhere((q) => q.selectedAnswer == null);

//     // If all questions are answered, start from the last question
//     int initialPage = firstUnansweredIndex == -1
//         ? quizeCubit.state.quizeQuestions.length - 1
//         : firstUnansweredIndex;
//     print(initialPage);
//     if (initialPage == quizeCubit.state.quizeQuestions.length - 1) {
//       quizeCubit.updateCurrentQuestionIndex(0);
//       initialPage = 0;
//     }

//     _pageController = PageController(initialPage: initialPage);

//     // Update current question index
//     quizeCubit.updateCurrentQuestionIndex(initialPage);

//     // Add page controller listener for pagination
//     _pageController.addListener(_onPageChanged);
//   }

//   void _onPageChanged() {
//     final QuizeCubit quizeCubit = context.read<QuizeCubit>();
//     final QuizeState state = quizeCubit.state;

//     // Check if we're near the end of current questions and need to fetch more
//     if (_pageController.page != null &&
//         _pageController.page!.round() >= state.quizeQuestions.length - 2) {
//       quizeCubit.loadMoreQuestions(widget.id);
//     }
//   }

//   void setWrongAnswer() {
//     if (mounted) {
//       setState(() {
//         wrongAnswerSelected = true;
//         wrongAnswerTime = DateTime.now();
//       });
//     }
//   }

//   void clearWrongAnswer() {
//     if (mounted) {
//       setState(() {
//         wrongAnswerSelected = false;
//         wrongAnswerTime = null;
//       });
//     }
//   }

//   bool hasAutoNavigated(int questionId) {
//     return questionAutoNavigatedMap[questionId] == true;
//   }

//   void markQuestionAsAutoNavigated(int questionId) {
//     if (mounted) {
//       setState(() {
//         questionAutoNavigatedMap[questionId] = true;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     // NamedNavigatorImpl.pop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<QuizeCubit, QuizeState>(
//       builder: (context, state) {
//         return Column(
//           children: [
//             IndicatorWidget(pageController: _pageController),
//             Expanded(
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemCount: state.quizeQuestions.length,
//                 onPageChanged: (index) {
//                   context.read<QuizeCubit>().updateCurrentQuestionIndex(index);
//                 },
//                 itemBuilder: (context, index) {
//                   final question = state.quizeQuestions[index];
//                   return SingleChildScrollView(
//                     child: Container(
//                       margin: EdgeInsets.all(16.sp),
//                       padding: EdgeInsets.all(16.sp),
//                       decoration: BoxDecoration(
//                         color: AppColors.kWhite,
//                         borderRadius: BorderRadius.circular(16.sp),
//                       ),
//                       child: QuizQuestionWidget(
//                         onpressed: () {
//                           if (state.quizeQuestions.length ==
//                               state.currentQuestionIndex + 1) {
//                             NamedNavigatorImpl.pop();
//                           }
//                         },
//                         question: question,
//                         quizId: widget.id,
//                         pageController: _pageController,
//                         buttonClicked: buttonClicked,
//                         wrongAnswerSelected: wrongAnswerSelected,
//                         setWrongAnswer: setWrongAnswer,
//                         clearWrongAnswer: clearWrongAnswer,
//                         hasAutoNavigated: hasAutoNavigated(question.id),
//                         markQuestionAsAutoNavigated: () =>
//                             markQuestionAsAutoNavigated(question.id),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             SafeArea(
//               child: Column(
//                 children: [
//                   const Divider(),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 16.sp,
//                       vertical: 12.sp,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         BackButton(
//                           pageController: _pageController,
//                           onPressed: () {
//                             if (mounted) {
//                               setState(() {
//                                 buttonClicked = true;
//                               });
//                             }
//                             // Clear any pending wrong answer navigation
//                             clearWrongAnswer();

//                             context.read<QuizeCubit>().previousQuestion();
//                             if (_pageController.hasClients) {
//                               _pageController
//                                   .previousPage(
//                                 duration: const Duration(milliseconds: 300),
//                                 curve: Curves.easeInOut,
//                               )
//                                   .then(
//                                 (value) {
//                                   // Delay resetting the button flag to ensure the animation completes
//                                   Future.delayed(
//                                       const Duration(milliseconds: 350), () {
//                                     if (mounted) {
//                                       setState(() {
//                                         buttonClicked = false;
//                                       });
//                                     }
//                                   });
//                                 },
//                               );
//                             }
//                           },
//                         ),
//                         NextButton(
//                           id: widget.id,
//                           pageController: _pageController,
//                           onPressed: () {
//                             if (mounted) {
//                               setState(() {
//                                 buttonClicked = true;
//                               });
//                             }
//                             // Clear any pending wrong answer navigation
//                             clearWrongAnswer();

//                             context.read<QuizeCubit>().nextQuestion();
//                             if (_pageController.hasClients) {
//                               _pageController
//                                   .nextPage(
//                                 duration: const Duration(milliseconds: 300),
//                                 curve: Curves.easeInOut,
//                               )
//                                   .then(
//                                 (value) {
//                                   // Delay resetting the button flag to ensure the animation completes
//                                   Future.delayed(
//                                       const Duration(milliseconds: 350), () {
//                                     if (mounted) {
//                                       setState(() {
//                                         buttonClicked = false;
//                                       });
//                                     }
//                                   });
//                                 },
//                               );
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class BackButton extends StatelessWidget {
//   final PageController pageController;
//   final void Function() onPressed;
//   const BackButton(
//       {super.key, required this.pageController, required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return BlocSelector<QuizeCubit, QuizeState, bool>(
//       selector: (state) {
//         return state.currentQuestionIndex == 0;
//       },
//       builder: (context, state) {
//         if (state) {
//           return const SizedBox.shrink();
//         }
//         return OutlinedButton(
//           style: ElevatedButton.styleFrom(
//             foregroundColor: AppColors.kPrimary,
//             side: const BorderSide(color: AppColors.kPrimary),
//             padding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 12.sp),
//           ),
//           onPressed: onPressed,
//           child: const Text('السابق'),
//         );
//       },
//     );
//   }
// }

// class NextButton extends StatelessWidget {
//   final int id;
//   final PageController pageController;
//   final void Function() onPressed;

//   const NextButton({
//     super.key,
//     required this.id,
//     required this.pageController,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocSelector<QuizeCubit, QuizeState, bool>(
//       selector: (state) {
//         return state.currentQuestionIndex == state.quizeQuestions.length - 1;
//       },
//       builder: (context, state) {
//         if (state) {
//           return const SizedBox.shrink();
//         }
//         return BlocBuilder<SubmitQuestionCubit, SubmitQuestionState>(
//           builder: (context, state) {
//             return Visibility(
//               visible: state is! SubmitQuestionLoading,
//               replacement: const AppLoader(),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 30.sp,
//                     vertical: 12.sp,
//                   ),
//                 ),
//                 onPressed: onPressed,
//                 child: const Text('التالي'),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class QuizQuestionWidget extends StatelessWidget {
//   final QuizeQuestion question;
//   final int quizId;
//   final PageController pageController;
//   final bool buttonClicked;
//   final bool wrongAnswerSelected;
//   final VoidCallback setWrongAnswer;
//   final VoidCallback clearWrongAnswer;
//   final bool hasAutoNavigated;
//   final VoidCallback markQuestionAsAutoNavigated;
//   final VoidCallback onpressed;

//   const QuizQuestionWidget({
//     super.key,
//     required this.question,
//     required this.quizId,
//     required this.pageController,
//     required this.buttonClicked,
//     required this.wrongAnswerSelected,
//     required this.setWrongAnswer,
//     required this.clearWrongAnswer,
//     required this.hasAutoNavigated,
//     required this.markQuestionAsAutoNavigated,
//     required this.onpressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<SubmitQuestionCubit>(
//       create: (context) => di<SubmitQuestionCubit>(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'السؤال #${context.read<QuizeCubit>().state.currentQuestionIndex + 1}',
//                 style: TextStyles.textViewSemiBold(
//                   color: AppColors.textColor,
//                   fontSize: 18.sp,
//                 ),
//               ),
//               BlocBuilder<SubmitQuestionCubit, SubmitQuestionState>(
//                 builder: (context, submitState) {
//                   final isSubmitted = question.selectedAnswer != null ||
//                       submitState is SubmitQuestionSuccess;

//                   if (!isSubmitted || question.selectedAnswer == null) {
//                     return SizedBox(width: 24.sp); // Placeholder for spacing
//                   }

//                   // Find the selected answer
//                   final selectedAnswer = question.answers
//                       .firstWhere((a) => a.id == question.selectedAnswer);

//                   return Padding(
//                     padding: EdgeInsets.only(left: 8.sp),
//                     child: Icon(
//                       selectedAnswer.isCorrect()
//                           ? Icons.check_circle
//                           : Icons.cancel,
//                       color: selectedAnswer.isCorrect()
//                           ? AppColors.kGreen
//                           : AppColors.red,
//                       size: 40.sp,
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//           SizedBox(height: 12.sp),
//           Container(
//             padding: EdgeInsets.only(right: 16.sp),
//             child: Column(
//               children: [
//                 HtmlWidget(
//                   question.question,
//                   renderMode: RenderMode.column,
//                   textStyle: TextStyles.textViewRegular(
//                     color: AppColors.textColor,
//                     fontSize: 16.sp,
//                   ),
//                 ),
//                 if (question.image.isNotEmpty)
//                   Padding(
//                     padding: EdgeInsets.only(left: 8.sp),
//                     child: Image.network(
//                       question.image,
//                       width: 150.sp,
//                       height: 150.sp,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           SizedBox(height: 12.sp),
//           BlocConsumer<SubmitQuestionCubit, SubmitQuestionState>(
//             listener: (context, state) {
//               onpressed();
//               if (state is SubmitQuestionSuccess && !buttonClicked) {
//                 // Only process auto-navigation if no button was clicked
//                 // and if this question hasn't been auto-navigated yet
//                 if (!hasAutoNavigated) {
//                   // Mark this question as having auto-navigated
//                   markQuestionAsAutoNavigated();

//                   // Find if the selected answer is correct
//                   final selectedAnswer = question.answers
//                       .firstWhere((a) => a.id == question.selectedAnswer);

//                   if (!selectedAnswer.isCorrect()) {
//                     // Wrong answer - set flag and wait 1 second before navigating
//                     setWrongAnswer();

//                     // Schedule navigation after 1 second
//                     Future.delayed(const Duration(seconds: 1), () {
//                       // Only navigate if the wrong answer flag is still set
//                       // (not cleared by a button press)
//                       if (wrongAnswerSelected && pageController.hasClients) {
//                         pageController.nextPage(
//                           duration: const Duration(milliseconds: 300),
//                           curve: Curves.easeInOut,
//                         );

//                         // Clear the wrong answer flag after navigation
//                         clearWrongAnswer();
//                       }
//                     });
//                   } else {
//                     // Correct answer - navigate immediately
//                     if (pageController.hasClients) {
//                       pageController.nextPage(
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.easeInOut,
//                       );
//                     }
//                   }
//                 }
//               }
//             },
//             builder: (context, submitState) {
//               // Consider a question as submitted if it has a selected answer or
//               // the SubmitQuestionCubit is in a success state
//               final isSubmitted = question.selectedAnswer != null ||
//                   submitState is SubmitQuestionSuccess;

//               return Column(
//                 children: question.answers.map((answer) {
//                   return GestureDetector(
//                     onTap: isSubmitted
//                         ? null
//                         : () {
//                             // Select answer in QuizeCubit
//                             context
//                                 .read<QuizeCubit>()
//                                 .selectedAnswer(answer.id);

//                             // Submit answer via SubmitQuestionCubit
//                             context
//                                 .read<SubmitQuestionCubit>()
//                                 .submitQuestionAnswerEvent(
//                                   questionId: question.id,
//                                   questionAnswerId: answer.id,
//                                   quizeId: quizId,
//                                 );
//                           },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                           vertical: 12.sp, horizontal: 16.sp),
//                       margin: EdgeInsets.only(bottom: 12.sp),
//                       decoration: BoxDecoration(
//                         color: _getAnswerColor(context, answer, isSubmitted),
//                         borderRadius: BorderRadius.circular(12.sp),
//                         border: Border.all(color: AppColors.borderColor),
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: answer.image == null
//                                 ? Text(
//                                     answer.answer,
//                                     style: TextStyles.textViewRegular(
//                                       fontSize: 16.sp,
//                                       color: _getAnswerTextColor(
//                                           context, answer, isSubmitted),
//                                     ),
//                                   )
//                                 : Image.network(
//                                     answer.image ?? '',
//                                     width: 100.sp,
//                                     height: 100.sp,
//                                     color: _getAnswerTextColor(
//                                         context, answer, isSubmitted),
//                                   ),
//                           ),
//                           Icon(
//                             question.selectedAnswer == answer.id
//                                 ? Icons.radio_button_checked
//                                 : Icons.radio_button_off,
//                             color: _getRadioColor(context, answer, isSubmitted),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getAnswerColor(
//       BuildContext context, QuestionOption answer, bool isSubmitted) {
//     if (!isSubmitted) {
//       return question.selectedAnswer == answer.id
//           ? AppColors.kPrimary
//           : AppColors.kWhite;
//     }

//     if (answer.isCorrect()) return AppColors.kGreen;
//     if (question.selectedAnswer == answer.id) return AppColors.red;
//     return AppColors.kWhite;
//   }

//   Color _getAnswerTextColor(
//       BuildContext context, QuestionOption answer, bool isSubmitted) {
//     if (!isSubmitted) {
//       return question.selectedAnswer == answer.id
//           ? AppColors.kWhite
//           : AppColors.textColor2;
//     }

//     if (answer.isCorrect() ||
//         (question.selectedAnswer == answer.id && !answer.isCorrect())) {
//       return AppColors.kWhite;
//     }
//     return AppColors.textColor2;
//   }

//   Color _getRadioColor(
//       BuildContext context, QuestionOption answer, bool isSubmitted) {
//     if (!isSubmitted) {
//       return question.selectedAnswer == answer.id
//           ? AppColors.kWhite
//           : AppColors.kGrayText;
//     }

//     if (answer.isCorrect() ||
//         (question.selectedAnswer == answer.id && !answer.isCorrect())) {
//       return AppColors.kWhite;
//     }
//     return AppColors.kGrayText;
//   }
// }

// class IndicatorWidget extends StatelessWidget {
//   final PageController pageController;

//   const IndicatorWidget({super.key, required this.pageController});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 24.sp),
//       child: BlocSelector<QuizeCubit, QuizeState, int>(
//         selector: (state) => state.currentQuestionIndex,
//         builder: (context, state) {
//           final quizeCubit = context.read<QuizeCubit>();
//           return Row(
//             children: [
//               Expanded(
//                 child: LinearProgressIndicator(
//                   color: AppColors.kGreen,
//                   minHeight: 12.sp,
//                   borderRadius: BorderRadius.circular(8.sp),
//                   backgroundColor: AppColors.indicatorBg,
//                   value: (state + 1) / quizeCubit.state.quizeQuestions.length,
//                 ),
//               ),
//               SizedBox(width: 16.sp),
//               Text(
//                 '${state + 1}/${quizeCubit.state.quizeQuestions.length}',
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
