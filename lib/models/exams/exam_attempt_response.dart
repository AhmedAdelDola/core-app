class ExamAttemptResponse {
  ExamAttemptData? attempt;

  ExamAttemptResponse({this.attempt});

  factory ExamAttemptResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ExamAttemptResponse();
    return ExamAttemptResponse(
      attempt: json['attempt'] != null
          ? ExamAttemptData.fromJson(json['attempt'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ExamAttemptData {
  int? id;
  String? status;
  int? attemptNumber;
  String? startedAt;
  String? submittedAt;
  String? expiresAt;
  num? score;
  num? maxScore;
  int? questionsCount;
  int? correctAnswersCount;
  double? percentage;
  bool? passed;
  ExamMeta? exam;
  int? timeRemainingSeconds;
  List<ExamQuestionItem>? questions;

  ExamAttemptData({
    this.id,
    this.status,
    this.attemptNumber,
    this.startedAt,
    this.submittedAt,
    this.expiresAt,
    this.score,
    this.maxScore,
    this.questionsCount,
    this.correctAnswersCount,
    this.percentage,
    this.passed,
    this.exam,
    this.timeRemainingSeconds,
    this.questions,
  });

  factory ExamAttemptData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ExamAttemptData();
    return ExamAttemptData(
      id: json['id'] as int?,
      status: json['status'] as String?,
      attemptNumber: (json['attempt_number'] as num?)?.toInt(),
      startedAt: json['started_at'] as String?,
      submittedAt: json['submitted_at'] as String?,
      expiresAt: json['expires_at'] as String?,
      score: json['score'] as num?,
      maxScore: json['max_score'] as num?,
      questionsCount: (json['questions_count'] as num?)?.toInt(),
      correctAnswersCount: (json['correct_answers_count'] as num?)?.toInt(),
      percentage: (json['percentage'] as num?)?.toDouble(),
      passed: json['passed'] as bool?,
      exam: json['exam'] != null
          ? ExamMeta.fromJson(json['exam'] as Map<String, dynamic>)
          : null,
      timeRemainingSeconds: (json['time_remaining_seconds'] as num?)?.toInt(),
      questions: (json['questions'] as List<dynamic>?)
          ?.map((e) => ExamQuestionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ExamMeta {
  int? id;
  String? title;
  int? durationMinutes;
  int? passingPercentage;
  String? resultReleaseMode;
  String? resultReleaseAt;

  ExamMeta({
    this.id,
    this.title,
    this.durationMinutes,
    this.passingPercentage,
    this.resultReleaseMode,
    this.resultReleaseAt,
  });

  factory ExamMeta.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ExamMeta();
    return ExamMeta(
      id: json['id'] as int?,
      title: json['title'] as String?,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      passingPercentage: (json['passing_percentage'] as num?)?.toInt(),
      resultReleaseMode: json['result_release_mode'] as String?,
      resultReleaseAt: json['result_release_at'] as String?,
    );
  }
}

class ExamQuestionItem {
  int? questionId;
  String? questionType;
  int? sortOrder;
  String? body;
  String? explanation;
  String? imageUrl;
  List<int>? selectedOptionIds;
  List<int>? correctOptionIds;
  bool? isCorrect;
  num? awardedPoints;
  num? maxPoints;
  List<ExamOptionItem>? options;

  ExamQuestionItem({
    this.questionId,
    this.questionType,
    this.sortOrder,
    this.body,
    this.explanation,
    this.imageUrl,
    this.selectedOptionIds,
    this.correctOptionIds,
    this.isCorrect,
    this.awardedPoints,
    this.maxPoints,
    this.options,
  });

  factory ExamQuestionItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ExamQuestionItem();
    return ExamQuestionItem(
      questionId: json['question_id'] as int?,
      questionType: json['question_type'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      body: json['body'] as String?,
      explanation: json['explanation'] as String?,
      imageUrl: json['image_url'] as String?,
      selectedOptionIds: (json['selected_option_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      correctOptionIds: (json['correct_option_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      isCorrect: json['is_correct'] as bool?,
      awardedPoints: json['awarded_points'] as num?,
      maxPoints: json['max_points'] as num?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => ExamOptionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ExamOptionItem {
  int? id;
  String? body;
  String? imageUrl;
  bool? isSelected;
  bool? isCorrect;

  ExamOptionItem({
    this.id,
    this.body,
    this.imageUrl,
    this.isSelected,
    this.isCorrect,
  });

  factory ExamOptionItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ExamOptionItem();
    return ExamOptionItem(
      id: json['id'] as int?,
      body: json['body'] as String?,
      imageUrl: json['image_url'] as String?,
      isSelected: json['is_selected'] as bool?,
      isCorrect: json['is_correct'] as bool?,
    );
  }
}
