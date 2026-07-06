// part of 'quize_cubit.dart';

// class QuizeState extends Equatable {
//   final List<QuizeQuestion> quizeQuestions;
//   final RequestStatus requestStatus;
//   final String? errorMessage;
//   final int currentQuestionIndex;
//   final int currentPage;
//   final bool isLoading;
//   final bool hasReachedMax;

//   const QuizeState({
//     this.quizeQuestions = const [],
//     this.requestStatus = RequestStatus.initial,
//     this.errorMessage,
//     this.currentQuestionIndex = 0,
//     this.currentPage = 1,
//     this.isLoading = false,
//     this.hasReachedMax = false,
//   });

//   QuizeState copyWith({
//     List<QuizeQuestion>? quizeQuestions,
//     RequestStatus? requestStatus,
//     String? errorMessage,
//     int? currentQuestionIndex,
//     int? currentPage,
//     bool? isLoading,
//     bool? hasReachedMax,
//   }) {
//     return QuizeState(
//       quizeQuestions: quizeQuestions ?? this.quizeQuestions,
//       requestStatus: requestStatus ?? this.requestStatus,
//       errorMessage: errorMessage ?? this.errorMessage,
//       currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
//       currentPage: currentPage ?? this.currentPage,
//       isLoading: isLoading ?? this.isLoading,
//       hasReachedMax: hasReachedMax ?? this.hasReachedMax,
//     );
//   }

//   bool isSelectedId(int id) {
//     final currentQuestion = quizeQuestions[currentQuestionIndex];
//     return currentQuestion.selectedAnswer == id;
//   }

//   bool isQAnswered() {
//     final currentQuestion = quizeQuestions[currentQuestionIndex];
//     return currentQuestion.selectedAnswer != null;
//   }

//   @override
//   List<Object?> get props => [
//         quizeQuestions,
//         requestStatus,
//         errorMessage,
//         currentQuestionIndex,
//         currentPage,
//         isLoading,
//         hasReachedMax
//       ];

//   static QuizeState initial() => const QuizeState();
// }
