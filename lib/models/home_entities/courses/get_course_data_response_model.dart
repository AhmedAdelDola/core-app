class GetCourseDataResponse {
  String? accessMode;
  Subscription? subscription;
  Progress? progress;
  dynamic nextSession;
  Course? course;

  GetCourseDataResponse({
    this.accessMode,
    this.subscription,
    this.progress,
    this.nextSession,
    this.course,
  });

  factory GetCourseDataResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return GetCourseDataResponse();
    return GetCourseDataResponse(
      accessMode: json['access_mode'] as String?,
      subscription: json['subscription'] == null
          ? null
          : Subscription.fromJson(json['subscription'] as Map<String, dynamic>),
      progress: json['progress'] == null
          ? null
          : Progress.fromJson(json['progress'] as Map<String, dynamic>),
      nextSession: json['next_session'],
      course: json['course'] == null
          ? null
          : Course.fromJson(json['course'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'access_mode': accessMode,
        'subscription': subscription?.toJson(),
        'progress': progress?.toJson(),
        'next_session': nextSession,
        'course': course?.toJson(),
      };
}

class Subscription {
  bool? hasActiveSubscription;
  bool? hasSessionSubscription;
  bool? canSubscribe;
  String? price;

  Subscription({
    this.hasActiveSubscription,
    this.hasSessionSubscription,
    this.canSubscribe,
    this.price,
  });

  factory Subscription.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Subscription();
    return Subscription(
      hasActiveSubscription: json['has_active_subscription'] as bool?,
      hasSessionSubscription: json['has_session_subscription'] as bool?,
      canSubscribe: json['can_subscribe'] as bool?,
      price: json['price'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'has_active_subscription': hasActiveSubscription,
        'has_session_subscription': hasSessionSubscription,
        'can_subscribe': canSubscribe,
        'price': price,
      };
}

class Progress {
  int? completedSessions;
  int? totalSessions;
  int? completionPercent;

  Progress({this.completedSessions, this.totalSessions, this.completionPercent});

  factory Progress.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Progress();
    return Progress(
      completedSessions: (json['completed_sessions'] as num?)?.toInt(),
      totalSessions: (json['total_sessions'] as num?)?.toInt(),
      completionPercent: (json['completion_percent'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'completed_sessions': completedSessions,
        'total_sessions': totalSessions,
        'completion_percent': completionPercent,
      };
}

class Course {
  int? id;
  String? title;
  String? description;
  String? price;
  bool? hasActiveSubscription;
  bool? hasSessionSubscription;
  Stage? stage;
  Level? level;
  Teacher? teacher;
  String? imageUrl;
  String? promoUrl;
  List<Chapter>? chapters;

  Course({
    this.id,
    this.title,
    this.description,
    this.price,
    this.hasActiveSubscription,
    this.hasSessionSubscription,
    this.stage,
    this.level,
    this.teacher,
    this.imageUrl,
    this.promoUrl,
    this.chapters,
  });

  factory Course.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Course();
    return Course(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      price: json['price'] as String?,
      hasActiveSubscription: json['has_active_subscription'] as bool?,
      hasSessionSubscription: json['has_session_subscription'] as bool?,
      stage: json['stage'] == null
          ? null
          : Stage.fromJson(json['stage'] as Map<String, dynamic>),
      level: json['level'] == null
          ? null
          : Level.fromJson(json['level'] as Map<String, dynamic>),
      teacher: json['teacher'] == null
          ? null
          : Teacher.fromJson(json['teacher'] as Map<String, dynamic>),
      imageUrl: json['image_url'] as String?,
      promoUrl: json['promo_url'] as String?,
      chapters: (json['chapters'] as List?)
          ?.map((e) => Chapter.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'has_active_subscription': hasActiveSubscription,
        'has_session_subscription': hasSessionSubscription,
        'stage': stage?.toJson(),
        'level': level?.toJson(),
        'teacher': teacher?.toJson(),
        'image_url': imageUrl,
        'promo_url': promoUrl,
        'chapters': chapters?.map((e) => e.toJson()).toList(),
      };
}

class Stage {
  int? id;
  String? name;

  Stage({this.id, this.name});

  factory Stage.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Stage();
    return Stage(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class Level {
  int? id;
  String? name;

  Level({this.id, this.name});

  factory Level.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Level();
    return Level(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class Teacher {
  int? id;
  String? name;
  String? imageUrl;

  Teacher({this.id, this.name, this.imageUrl});

  factory Teacher.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Teacher();
    return Teacher(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'image_url': imageUrl};
}

class Chapter {
  int? id;
  String? title;
  int? sortOrder;
  List<Lesson>? lessons;

  Chapter({this.id, this.title, this.sortOrder, this.lessons});

  factory Chapter.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Chapter();
    return Chapter(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      lessons: (json['lessons'] as List?)
          ?.map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'sort_order': sortOrder,
        'lessons': lessons?.map((e) => e.toJson()).toList(),
      };
}

class Lesson {
  int? id;
  String? title;
  int? sortOrder;
  List<Session>? sessions;

  Lesson({this.id, this.title, this.sortOrder, this.sessions});

  factory Lesson.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Lesson();
    return Lesson(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      sessions: (json['sessions'] as List?)
          ?.map((e) => Session.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'sort_order': sortOrder,
        'sessions': sessions?.map((e) => e.toJson()).toList(),
      };
}

class Session {
  int? id;
  int? chapterId;
  int? lessonId;
  String? title;
  String? type;
  int? sortOrder;
  bool? canAccess;
  String? blockedReason;
  String? deliveryType;
  bool? isPublished;
  String? progressStatus;
  int? progressPercent;
  int? resumeFrom;
  int? durationMinutes;
  String? durationLabel;

  Session({
    this.id,
    this.chapterId,
    this.lessonId,
    this.title,
    this.type,
    this.sortOrder,
    this.canAccess,
    this.blockedReason,
    this.deliveryType,
    this.isPublished,
    this.progressStatus,
    this.progressPercent,
    this.resumeFrom,
    this.durationMinutes,
    this.durationLabel,
  });

  factory Session.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Session();
    return Session(
      id: (json['id'] as num?)?.toInt(),
      chapterId: (json['chapter_id'] as num?)?.toInt(),
      lessonId: (json['lesson_id'] as num?)?.toInt(),
      title: json['title'] as String?,
      type: json['type'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      canAccess: json['can_access'] as bool?,
      blockedReason: json['blocked_reason'] as String?,
      deliveryType: json['delivery_type'] as String?,
      isPublished: json['is_published'] as bool?,
      progressStatus: json['progress_status'] as String?,
      progressPercent: (json['progress_percent'] as num?)?.toInt(),
      resumeFrom: (json['resume_from'] as num?)?.toInt(),
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      durationLabel: json['duration_label'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'chapter_id': chapterId,
        'lesson_id': lessonId,
        'title': title,
        'type': type,
        'sort_order': sortOrder,
        'can_access': canAccess,
        'blocked_reason': blockedReason,
        'delivery_type': deliveryType,
        'is_published': isPublished,
        'progress_status': progressStatus,
        'progress_percent': progressPercent,
        'resume_from': resumeFrom,
        'duration_minutes': durationMinutes,
        'duration_label': durationLabel,
      };
}