// part of 'exam_cubit.dart';

// class ExamState extends Equatable {
//   final List<QuestionData> examQuestions; // Flattened from ExamQuestions.data
//   final RequestStatus requestStatus;
//   final String? errorMessage;
//   final int currentQuestionIndex;
//   final int currentPage;
//   final bool isLoading;
//   final bool hasReachedMax;

//   const ExamState({
//     this.examQuestions = const [],
//     this.requestStatus = RequestStatus.initial,
//     this.errorMessage,
//     this.currentQuestionIndex = 0,
//     this.currentPage = 1,
//     this.isLoading = false,
//     this.hasReachedMax = false,
//   });

//   ExamState copyWith({
//     List<QuestionData>? examQuestions,
//     RequestStatus? requestStatus,
//     String? errorMessage,
//     int? currentQuestionIndex,
//     int? currentPage,
//     bool? isLoading,
//     bool? hasReachedMax,
//   }) {
//     return ExamState(
//       examQuestions: examQuestions ?? this.examQuestions,
//       requestStatus: requestStatus ?? this.requestStatus,
//       errorMessage: errorMessage ?? this.errorMessage,
//       currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
//       currentPage: currentPage ?? this.currentPage,
//       isLoading: isLoading ?? this.isLoading,
//       hasReachedMax: hasReachedMax ?? this.hasReachedMax,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         examQuestions,
//         requestStatus,
//         errorMessage,
//         currentQuestionIndex,
//         currentPage,
//         isLoading,
//         hasReachedMax,
//       ];

//   factory ExamState.initial() => const ExamState();
// }
