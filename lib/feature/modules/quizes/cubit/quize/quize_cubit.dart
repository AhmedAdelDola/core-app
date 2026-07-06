// import 'dart:developer';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../../core/network/repository/repository_imports.dart';
// import '../../../../../core/util/enums.dart';
// import '../../../../../core/widgets/ui_helpers/alert_message.dart';
// import '../../../../../models/quizes/quize_questions_response.dart';

// part 'quize_state.dart';

// class QuizeCubit extends Cubit<QuizeState> {
//   final Repository repo;

//   QuizeCubit(this.repo) : super(QuizeState.initial());

//   static QuizeCubit get(context) => BlocProvider.of(context);

//   Future<void> getQuizeQuestions(
//       {required int id, int page = 1, int pageSize = 10}) async {
//     // Prevent multiple simultaneous loading
//     if (state.isLoading) return;

//     emit(state.copyWith(requestStatus: RequestStatus.loading, isLoading: true));

//     // Modify the repository method to accept page and pageSize if possible
//     final response = await repo.getQuizeQuestions(
//         id: id,
//         // You might need to modify your repository method to accept these parameters
//         // If not, remove these and handle pagination on the backend
//         page: page,
//         pageSize: pageSize);

//     response.fold(
//         (l) => emit(state.copyWith(
//             requestStatus: RequestStatus.error,
//             errorMessage: l.toString(),
//             isLoading: false)), (r) {
//       // Merge new questions with existing questions
//       List<QuizeQuestion> updatedQuestions = [
//         ...state.quizeQuestions,
//         ...r.data
//       ];

//       // Remove duplicates while preserving order
//       final uniqueQuestions = updatedQuestions.toSet().toList();

//       emit(state.copyWith(
//           requestStatus: RequestStatus.success,
//           quizeQuestions: uniqueQuestions,
//           currentPage: page,
//           isLoading: false,
//           hasReachedMax:
//               r.data.isEmpty // If no new questions, we've reached the max
//           ));

//       // Animate to first unanswered question on first load
//       if (page == 1) {
//         animateToFirstUnansweredQuestion();
//       }
//     });
//   }

//   Future<void> loadMoreQuestions(int id) async {
//     // Check if we can load more questions
//     if (state.hasReachedMax || state.isLoading) return;

//     // Load next page
//     await getQuizeQuestions(id: id, page: state.currentPage + 1);
//   }

//   void animateToFirstUnansweredQuestion() {
//     for (int i = 0; i < state.quizeQuestions.length; i++) {
//       if (!state.quizeQuestions[i].isAnswered()) {
//         emit(state.copyWith(currentQuestionIndex: i));
//         return;
//       }
//     }
//   }

//   void updateCurrentQuestionIndex(int index) {
//     emit(state.copyWith(currentQuestionIndex: index));
//   }

//   void selectedAnswer(int answerId) {
//     final currentQuestion = state.quizeQuestions[state.currentQuestionIndex]
//         .copyWith(selectedAnswer: answerId);

//     List<QuizeQuestion> quizeQuestions = List.from(state.quizeQuestions);
//     quizeQuestions[state.currentQuestionIndex] = currentQuestion;

//     emit(state.copyWith(quizeQuestions: quizeQuestions));
//   }

//   void nextQuestion() {
//     if (state.currentQuestionIndex < state.quizeQuestions.length - 1) {
//       emit(state.copyWith(
//         currentQuestionIndex: state.currentQuestionIndex + 1,
//       ));
//     }
//   }

//   void previousQuestion() {
//     if (state.currentQuestionIndex > 0) {
//       emit(state.copyWith(
//         currentQuestionIndex: state.currentQuestionIndex - 1,
//       ));
//     }
//   }

//   // Add this method to your QuizeCubit class
//   void markAutoNavigationUsed(int questionId) {
//     final updatedQuestions = state.quizeQuestions.map((q) {
//       if (q.id == questionId) {
//         // Create a copy of the question with autoNavigationUsed set to true
//         return q.copyWith(autoNavigationUsed: true);
//       }
//       return q;
//     }).toList();

//     emit(state.copyWith(quizeQuestions: updatedQuestions));
//   }
// }
