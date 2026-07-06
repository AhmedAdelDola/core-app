import '../../general/teacher.dart';

class GetRecommendedLessonResponse {
  final int? status;
  final String? message;
  final GetRecommendedLessonData? data;

  GetRecommendedLessonResponse({this.status, this.message, this.data});

  factory GetRecommendedLessonResponse.fromJson(Map<String, dynamic> json) =>
      GetRecommendedLessonResponse(
        status: json['status'],
        message: json['message'],
        data: json['data'] == null ? null : GetRecommendedLessonData.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class GetRecommendedLessonData {
  final int? id;
  final String? title;
  final String? note;
  final String? chapterName;
  final int? courseId;
  final int? chapterId;
  final int? lessonId;
  final String? lessonName;
  final String? modelType;
  final String? startDate;
  final String? endDate;
  final int? duration;
  final int? isFree;
  final int? isMp3;
  final int? price;
  final bool? isYoutube;
  final bool? isPointEarned;
  final dynamic sessionViews;
  final int? userViewsCounter;
  final int? userViewsDuration;
  final String? lastView;
  final int? progress;
  final int? point;
  final int? availability;
  final String? status;
  final dynamic subscriptionType;
  final dynamic startSubscriptionAt;
  final dynamic endSubscriptionAt;
  final int? subscriptionStatus;
  final Teacher? teacher;

  GetRecommendedLessonData({
    this.id,
    this.title,
    this.note,
    this.chapterName,
    this.courseId,
    this.chapterId,
    this.lessonId,
    this.lessonName,
    this.modelType,
    this.startDate,
    this.endDate,
    this.duration,
    this.isFree,
    this.isMp3,
    this.price,
    this.isYoutube,
    this.isPointEarned,
    this.sessionViews,
    this.userViewsCounter,
    this.userViewsDuration,
    this.lastView,
    this.progress,
    this.point,
    this.availability,
    this.status,
    this.subscriptionType,
    this.startSubscriptionAt,
    this.endSubscriptionAt,
    this.subscriptionStatus,
    this.teacher,
  });

  factory GetRecommendedLessonData.fromJson(Map<String, dynamic> json) => GetRecommendedLessonData(
        id: json['id'],
        title: json['title'],
        note: json['note'],
        chapterName: json['chapter_name'],
        courseId: json['course_id'],
        chapterId: json['chapter_id'],
        lessonId: json['lesson_id'],
        lessonName: json['lesson_name'],
        modelType: json['model_type'],
        startDate: json['start_date'],
        endDate: json['end_date'],
        duration: json['duration'],
        isFree: json['is_free'],
        isMp3: json['is_mp3'],
        price: json['price'],
        isYoutube: json['is_youtube'],
        isPointEarned: json['is_point_earned'],
        sessionViews: json['session_views'],
        userViewsCounter: json['user_views_counter'],
        userViewsDuration: json['user_views_duration'],
        lastView: json['last_view'],
        progress: json['progress'],
        point: json['point'],
        availability: json['availability'],
        status: json['status'],
        subscriptionType: json['subscription_type'],
        startSubscriptionAt: json['start_subscription_at'],
        endSubscriptionAt: json['end_subscription_at'],
        subscriptionStatus: json['subscription_status'],
        teacher: json['teacher'] == null ? null : Teacher.fromJson(json['teacher']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'note': note,
        'chapter_name': chapterName,
        'course_id': courseId,
        'chapter_id': chapterId,
        'lesson_id': lessonId,
        'lesson_name': lessonName,
        'model_type': modelType,
        'start_date': startDate,
        'end_date': endDate,
        'duration': duration,
        'is_free': isFree,
        'is_mp3': isMp3,
        'price': price,
        'is_youtube': isYoutube,
        'is_point_earned': isPointEarned,
        'session_views': sessionViews,
        'user_views_counter': userViewsCounter,
        'user_views_duration': userViewsDuration,
        'last_view': lastView,
        'progress': progress,
        'point': point,
        'availability': availability,
        'status': status,
        'subscription_type': subscriptionType,
        'start_subscription_at': startSubscriptionAt,
        'end_subscription_at': endSubscriptionAt,
        'subscription_status': subscriptionStatus,
        'teacher': teacher?.toJson(),
      };
}
