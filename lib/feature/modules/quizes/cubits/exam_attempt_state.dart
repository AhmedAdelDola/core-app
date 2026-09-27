import 'package:equatable/equatable.dart';
import '../../../../models/exams/exam_attempt_response.dart';
import '../../../../models/exams/exam_result_response.dart';

enum ExamSessionStatus {
  initial,
  loading,
  inProgress,
  submitting,
  completed,
  error,
}

class ExamAttemptState extends Equatable {
  final ExamSessionStatus status;
  final ExamAttemptData? attemptData;
  final ExamResultResponse? resultData;
  final int currentQuestionIndex;
  final Map<int, List<int>> selectedAnswers;
  final Set<int> flaggedQuestionIds;
  final int timeRemainingSeconds;
  final String? errorMessage;
  final bool isSavingAnswer;

  const ExamAttemptState({
    this.status = ExamSessionStatus.initial,
    this.attemptData,
    this.resultData,
    this.currentQuestionIndex = 0,
    this.selectedAnswers = const {},
    this.flaggedQuestionIds = const {},
    this.timeRemainingSeconds = 0,
    this.errorMessage,
    this.isSavingAnswer = false,
  });

  ExamAttemptState copyWith({
    ExamSessionStatus? status,
    ExamAttemptData? attemptData,
    ExamResultResponse? resultData,
    int? currentQuestionIndex,
    Map<int, List<int>>? selectedAnswers,
    Set<int>? flaggedQuestionIds,
    int? timeRemainingSeconds,
    String? errorMessage,
    bool? isSavingAnswer,
  }) {
    return ExamAttemptState(
      status: status ?? this.status,
      attemptData: attemptData ?? this.attemptData,
      resultData: resultData ?? this.resultData,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      flaggedQuestionIds: flaggedQuestionIds ?? this.flaggedQuestionIds,
      timeRemainingSeconds: timeRemainingSeconds ?? this.timeRemainingSeconds,
      errorMessage: errorMessage ?? this.errorMessage,
      isSavingAnswer: isSavingAnswer ?? this.isSavingAnswer,
    );
  }

  int get totalQuestions => attemptData?.questions?.length ?? 0;
  
  int get answeredQuestionsCount {
    if (attemptData?.questions == null) return 0;
    int count = 0;
    for (final q in attemptData!.questions!) {
      final qId = q.questionId ?? 0;
      final selected = selectedAnswers[qId];
      if (selected != null && selected.isNotEmpty) {
        count++;
      }
    }
    return count;
  }

  int get unansweredQuestionsCount => totalQuestions - answeredQuestionsCount;

  int get flaggedQuestionsCount => flaggedQuestionIds.length;

  bool isQuestionAnswered(int questionId) {
    final selected = selectedAnswers[questionId];
    return selected != null && selected.isNotEmpty;
  }

  bool isQuestionFlagged(int questionId) {
    return flaggedQuestionIds.contains(questionId);
  }

  @override
  List<Object?> get props => [
        status,
        attemptData,
        resultData,
        currentQuestionIndex,
        selectedAnswers,
        flaggedQuestionIds,
        timeRemainingSeconds,
        errorMessage,
        isSavingAnswer,
      ];
}
