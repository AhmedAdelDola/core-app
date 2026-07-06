// import 'dart:developer';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../../core/network/repository/repository_imports.dart';
// import '../../../../../core/util/enums.dart';
// import '../../../../../models/exams/get_all_exams.dart';
// import '../../../../../models/exams/get_exam_deatils.dart';
// import '../../../../../models/exams/get_exam_questions.dart';

// part 'exam_state.dart';

// class ExamCubit extends Cubit<ExamState> {
//   final Repository repo;

//   ExamCubit(this.repo) : super(ExamState.initial());

//   static ExamCubit get(context) => BlocProvider.of(context);

//   AllExam? allExam;
//   SingleExam? singleExam;
//   ExamQuestions? examQuestionsResponse;

//   /// ✅ Get All Exams
//   Future<void> getAllExam() async {
//     emit(state.copyWith(isLoading: true, requestStatus: RequestStatus.loading));

//     final f = await repo.getAllExams();

//     f.fold(
//       (l) => emit(state.copyWith(
//           errorMessage: l.toString(),
//           requestStatus: RequestStatus.error,
//           isLoading: false)),
//       (r) {
//         allExam = r;
//         emit(state.copyWith(
//           isLoading: false,
//           requestStatus: RequestStatus.success,
//         ));
//       },
//     );
//   }

//   /// ✅ Start Exam
//   Future<void> startExam(String id) async {
//     emit(state.copyWith(isLoading: true, requestStatus: RequestStatus.loading));

//     final f = await repo.StartExam(id);

//     f.fold(
//       (l) => emit(state.copyWith(
//           errorMessage: l.toString(),
//           requestStatus: RequestStatus.error,
//           isLoading: false)),
//       (r) {
//         emit(state.copyWith(
//           isLoading: false,
//           requestStatus: RequestStatus.success,
//         ));
//       },
//     );
//   }

//   /// ✅ End Exam
//   Future<void> endExam(String id) async {
//     emit(state.copyWith(isLoading: true, requestStatus: RequestStatus.loading));

//     final f = await repo.EndExam(id);

//     f.fold(
//       (l) => emit(state.copyWith(
//           errorMessage: l.toString(),
//           requestStatus: RequestStatus.error,
//           isLoading: false)),
//       (r) {
//         emit(state.copyWith(
//           isLoading: false,
//           requestStatus: RequestStatus.success,
//         ));
//       },
//     );
//   }

//   /// ✅ Get Single Exam Details
//   Future<void> getExamDetails(String id) async {
//     emit(state.copyWith(isLoading: true, requestStatus: RequestStatus.loading));

//     final f = await repo.getExamDeatils(id);

//     f.fold(
//       (l) => emit(state.copyWith(
//           errorMessage: l.toString(),
//           requestStatus: RequestStatus.error,
//           isLoading: false)),
//       (r) {
//         singleExam = r;
//         emit(state.copyWith(
//           isLoading: false,
//           requestStatus: RequestStatus.success,
//         ));
//       },
//     );
//   }

//   /// ✅ Get Exam Questions (with pagination)
//   Future<void> getExamQuestions({
//     required String id,
//     int page = 1,
//   }) async {
//     if (state.isLoading) return;

//     emit(state.copyWith(requestStatus: RequestStatus.loading, isLoading: true));

//     final response = await repo.getExamQuestion(id);

//     response.fold(
//       (l) => emit(state.copyWith(
//           requestStatus: RequestStatus.error,
//           errorMessage: l.toString(),
//           isLoading: false)),
//       (r) {
//         examQuestionsResponse = r;

//         final newQuestions = r.data ?? [];
//         final updatedQuestions = [
//           ...state.examQuestions,
//           ...newQuestions,
//         ];

//         emit(state.copyWith(
//           requestStatus: RequestStatus.success,
//           examQuestions: updatedQuestions,
//           currentPage: page,
//           isLoading: false,
//           hasReachedMax: newQuestions.isEmpty,
//         ));
//       },
//     );
//   }

//   /// ✅ Change current question index
//   void updateCurrentQuestionIndex(int index) {
//     emit(state.copyWith(currentQuestionIndex: index));
//   }

//   /// ✅ Select an answer for the current question
//   void selectAnswer(int answerId) {
//     final questions = List<QuestionData>.from(state.examQuestions);
//     final currentIndex = state.currentQuestionIndex;

//     if (currentIndex < 0 || currentIndex >= questions.length) return;

//     final currentQuestion = questions[currentIndex];

//     // ✅ Find the selected answer object
//     final selectedAnswer = currentQuestion.answers?.firstWhere(
//         (ans) => ans.id == answerId,
//         orElse: () => Answer(id: answerId));

//     final updatedQuestion = QuestionData(
//       id: currentQuestion.id,
//       title: currentQuestion.title,
//       complexity: currentQuestion.complexity,
//       image: currentQuestion.image,
//       piece: currentQuestion.piece,
//       answers: currentQuestion.answers,
//       studentAnswer: selectedAnswer, // ✅ Correct type
//       trueAnswer: currentQuestion.trueAnswer,
//     );

//     questions[currentIndex] = updatedQuestion;

//     emit(state.copyWith(examQuestions: questions));
//   }

//   /// ✅ Move to next question
//   void nextQuestion() {
//     if (state.currentQuestionIndex < state.examQuestions.length - 1) {
//       emit(state.copyWith(
//         currentQuestionIndex: state.currentQuestionIndex + 1,
//       ));
//     }
//   }

//   /// ✅ Move to previous question
//   void previousQuestion() {
//     if (state.currentQuestionIndex > 0) {
//       emit(state.copyWith(
//         currentQuestionIndex: state.currentQuestionIndex - 1,
//       ));
//     }
//   }

//   /// ✅ Helper: check if an answer is selected
//   bool isAnswerSelected(int questionIndex, int answerId) {
//     if (questionIndex < 0 || questionIndex >= state.examQuestions.length) {
//       return false;
//     }
//     final question = state.examQuestions[questionIndex];
//     return question.studentAnswer?.id == answerId;
//   }
// }
