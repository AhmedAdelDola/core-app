class CourseExamsResponse {
  int? courseId;
  List<CourseExamItem>? exams;

  CourseExamsResponse({this.courseId, this.exams});

  factory CourseExamsResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CourseExamsResponse();
    return CourseExamsResponse(
      courseId: json['course_id'] as int?,
      exams: (json['exams'] as List<dynamic>?)
          ?.map((e) => CourseExamItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CourseExamItem {
  int? id;
  int? courseId;
  int? chapterId;
  int? lessonId;
  ScopeTitle? chapter;
  ScopeTitle? lesson;
  String? title;
  String? description;
  int? durationMinutes;
  int? passingPercentage;
  int? totalPoints;
  int? maxAttempts;
  bool? allowReview;
  bool? showCorrectAnswers;
  String? availabilityMode;
  String? availableFrom;
  String? availableUntil;
  bool? isAvailableNow;
  int? questionsCount;
  int? attemptsCount;
  int? remainingAttempts;
  bool? canRetake;
  ExamAttemptSummary? attempt;

  CourseExamItem({
    this.id,
    this.courseId,
    this.chapterId,
    this.lessonId,
    this.chapter,
    this.lesson,
    this.title,
    this.description,
    this.durationMinutes,
    this.passingPercentage,
    this.totalPoints,
    this.maxAttempts,
    this.allowReview,
    this.showCorrectAnswers,
    this.availabilityMode,
    this.availableFrom,
    this.availableUntil,
    this.isAvailableNow,
    this.questionsCount,
    this.attemptsCount,
    this.remainingAttempts,
    this.canRetake,
    this.attempt,
  });

  factory CourseExamItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CourseExamItem();
    return CourseExamItem(
      id: json['id'] as int?,
      courseId: json['course_id'] as int?,
      chapterId: json['chapter_id'] as int?,
      lessonId: json['lesson_id'] as int?,
      chapter: json['chapter'] != null ? ScopeTitle.fromJson(json['chapter'] as Map<String, dynamic>) : null,
      lesson: json['lesson'] != null ? ScopeTitle.fromJson(json['lesson'] as Map<String, dynamic>) : null,
      title: json['title'] as String?,
      description: json['description'] as String?,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      passingPercentage: (json['passing_percentage'] as num?)?.toInt(),
      totalPoints: (json['total_points'] as num?)?.toInt(),
      maxAttempts: (json['max_attempts'] as num?)?.toInt(),
      allowReview: json['allow_review'] as bool?,
      showCorrectAnswers: json['show_correct_answers'] as bool?,
      availabilityMode: json['availability_mode'] as String?,
      availableFrom: json['available_from'] as String?,
      availableUntil: json['available_until'] as String?,
      isAvailableNow: json['is_available_now'] as bool?,
      questionsCount: (json['questions_count'] as num?)?.toInt(),
      attemptsCount: (json['attempts_count'] as num?)?.toInt(),
      remainingAttempts: (json['remaining_attempts'] as num?)?.toInt(),
      canRetake: json['can_retake'] as bool?,
      attempt: json['attempt'] != null ? ExamAttemptSummary.fromJson(json['attempt'] as Map<String, dynamic>) : null,
    );
  }
}

class ScopeTitle {
  int? id;
  String? title;

  ScopeTitle({this.id, this.title});

  factory ScopeTitle.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ScopeTitle();
    return ScopeTitle(
      id: json['id'] as int?,
      title: json['title'] as String?,
    );
  }
}

class ExamAttemptSummary {
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

  ExamAttemptSummary({
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
  });

  factory ExamAttemptSummary.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ExamAttemptSummary();
    return ExamAttemptSummary(
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
    );
  }
}
