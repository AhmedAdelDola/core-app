import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/repository/repository_imports.dart';
import '../../../../models/exams/exam_attempt_response.dart';
import 'exam_attempt_state.dart';

class ExamAttemptCubit extends Cubit<ExamAttemptState> {
  final Repository repository;
  Timer? _timer;

  ExamAttemptCubit(this.repository) : super(const ExamAttemptState());

  static ExamAttemptCubit of(BuildContext context) => BlocProvider.of<ExamAttemptCubit>(context);

  /// Start a new attempt or resume active
  Future<void> startExam(dynamic examId) async {
    emit(state.copyWith(status: ExamSessionStatus.loading));
    final result = await repository.startExamAttempt(examId);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ExamSessionStatus.error,
          errorMessage: failure.toString(),
        ));
      },
      (response) {
        final attempt = response.attempt;
        if (attempt == null) {
          emit(state.copyWith(
            status: ExamSessionStatus.error,
            errorMessage: 'تعذر تحميل بيانات الامتحان',
          ));
          return;
        }

        if (attempt.status != 'in_progress') {
          // Already submitted
          loadResult(attempt.id);
          return;
        }

        _initAttempt(attempt);
      },
    );
  }

  /// Resume existing attempt
  Future<void> resumeAttempt(dynamic attemptId) async {
    emit(state.copyWith(status: ExamSessionStatus.loading));
    final result = await repository.getExamAttempt(attemptId);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ExamSessionStatus.error,
          errorMessage: failure.toString(),
        ));
      },
      (response) {
        final attempt = response.attempt;
        if (attempt == null) {
          emit(state.copyWith(
            status: ExamSessionStatus.error,
            errorMessage: 'تعذر تحميل بيانات الامتحان',
          ));
          return;
        }

        if (attempt.status != 'in_progress') {
          loadResult(attempt.id);
          return;
        }

        _initAttempt(attempt);
      },
    );
  }

  void _initAttempt(ExamAttemptData attempt) {
    _timer?.cancel();

    final Map<int, List<int>> answers = {};
    for (final q in attempt.questions ?? <ExamQuestionItem>[]) {
      if (q.questionId != null && q.selectedOptionIds != null && q.selectedOptionIds!.isNotEmpty) {
        answers[q.questionId!] = List<int>.from(q.selectedOptionIds!);
      }
    }

    final int timeRemaining = attempt.timeRemainingSeconds ?? 0;

    emit(state.copyWith(
      status: ExamSessionStatus.inProgress,
      attemptData: attempt,
      selectedAnswers: answers,
      timeRemainingSeconds: timeRemaining,
      currentQuestionIndex: 0,
    ));

    if (timeRemaining > 0) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeRemainingSeconds > 1) {
        emit(state.copyWith(timeRemainingSeconds: state.timeRemainingSeconds - 1));
      } else {
        timer.cancel();
        emit(state.copyWith(timeRemainingSeconds: 0));
        submitExam(); // Auto-submit when time expires
      }
    });
  }

  /// Select option for current question
  void selectOption(int questionId, int optionId, String? questionType) {
    if (state.status != ExamSessionStatus.inProgress) return;

    final updatedAnswers = Map<int, List<int>>.from(state.selectedAnswers);
    final currentSelected = List<int>.from(updatedAnswers[questionId] ?? []);

    if (questionType == 'multiple_choice') {
      if (currentSelected.contains(optionId)) {
        currentSelected.remove(optionId);
      } else {
        currentSelected.add(optionId);
      }
    } else {
      // single_choice or true_false
      currentSelected.clear();
      currentSelected.add(optionId);
    }

    updatedAnswers[questionId] = currentSelected;

    // Immediate UI update
    emit(state.copyWith(
      selectedAnswers: updatedAnswers,
      isSavingAnswer: true,
    ));

    // Async backend persist
    final attemptId = state.attemptData?.id;
    if (attemptId != null) {
      repository.answerExamQuestion(
        attemptId: attemptId,
        questionId: questionId,
        optionIds: currentSelected,
      ).then((result) {
        emit(state.copyWith(isSavingAnswer: false));
      });
    }
  }

  /// Toggle bookmark/flag for review
  void toggleFlag(int questionId) {
    final updatedFlags = Set<int>.from(state.flaggedQuestionIds);
    if (updatedFlags.contains(questionId)) {
      updatedFlags.remove(questionId);
    } else {
      updatedFlags.add(questionId);
    }
    emit(state.copyWith(flaggedQuestionIds: updatedFlags));
  }

  void nextQuestion() {
    final maxIndex = (state.attemptData?.questions?.length ?? 1) - 1;
    if (state.currentQuestionIndex < maxIndex) {
      emit(state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1));
    }
  }

  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      emit(state.copyWith(currentQuestionIndex: state.currentQuestionIndex - 1));
    }
  }

  void goToQuestion(int index) {
    final maxIndex = (state.attemptData?.questions?.length ?? 1) - 1;
    if (index >= 0 && index <= maxIndex) {
      emit(state.copyWith(currentQuestionIndex: index));
    }
  }

  /// Submit the attempt
  Future<void> submitExam() async {
    _timer?.cancel();
    final attemptId = state.attemptData?.id;
    if (attemptId == null) return;

    emit(state.copyWith(status: ExamSessionStatus.submitting));

    final submitResult = await repository.submitExamAttempt(attemptId);
    await submitResult.fold(
      (failure) async {
        emit(state.copyWith(
          status: ExamSessionStatus.error,
          errorMessage: failure.toString(),
        ));
      },
      (response) async {
        await loadResult(attemptId);
      },
    );
  }

  /// Fetch result of an attempt
  Future<void> loadResult(dynamic attemptId) async {
    _timer?.cancel();
    emit(state.copyWith(status: ExamSessionStatus.loading));

    final result = await repository.getExamResult(attemptId);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ExamSessionStatus.error,
          errorMessage: failure.toString(),
        ));
      },
      (resultData) {
        emit(state.copyWith(
          status: ExamSessionStatus.completed,
          resultData: resultData,
        ));
      },
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
