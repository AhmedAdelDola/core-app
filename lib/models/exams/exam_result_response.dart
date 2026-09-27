import 'exam_attempt_response.dart';

class ExamResultResponse {
  int? attemptId;
  String? status;
  num? score;
  num? maxScore;
  int? questionsCount;
  int? correctAnswersCount;
  double? percentage;
  bool? passed;
  int? passingPercentage;
  int? attemptNumber;
  int? maxAttempts;
  int? remainingAttempts;
  bool? canRetake;
  String? submittedAt;
  bool? canReviewAnswers;
  String? reviewAvailableAt;
  List<ExamQuestionItem>? questions;

  ExamResultResponse({
    this.attemptId,
    this.status,
    this.score,
    this.maxScore,
    this.questionsCount,
    this.correctAnswersCount,
    this.percentage,
    this.passed,
    this.passingPercentage,
    this.attemptNumber,
    this.maxAttempts,
    this.remainingAttempts,
    this.canRetake,
    this.submittedAt,
    this.canReviewAnswers,
    this.reviewAvailableAt,
    this.questions,
  });

  factory ExamResultResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ExamResultResponse();
    return ExamResultResponse(
      attemptId: json['attempt_id'] as int?,
      status: json['status'] as String?,
      score: json['score'] as num?,
      maxScore: json['max_score'] as num?,
      questionsCount: (json['questions_count'] as num?)?.toInt(),
      correctAnswersCount: (json['correct_answers_count'] as num?)?.toInt(),
      percentage: (json['percentage'] as num?)?.toDouble(),
      passed: json['passed'] as bool?,
      passingPercentage: (json['passing_percentage'] as num?)?.toInt(),
      attemptNumber: (json['attempt_number'] as num?)?.toInt(),
      maxAttempts: (json['max_attempts'] as num?)?.toInt(),
      remainingAttempts: (json['remaining_attempts'] as num?)?.toInt(),
      canRetake: json['can_retake'] as bool?,
      submittedAt: json['submitted_at'] as String?,
      canReviewAnswers: json['can_review_answers'] as bool?,
      reviewAvailableAt: json['review_available_at'] as String?,
      questions: (json['questions'] as List<dynamic>?)
          ?.map((e) => ExamQuestionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
