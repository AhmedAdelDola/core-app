import '../../general/teacher.dart';

class RecommendedLessonsResponse {
  final int? status;
  final String? message;
  final List<RecommendedLessonsData>? data;

  RecommendedLessonsResponse({this.status, this.message, this.data});

  factory RecommendedLessonsResponse.fromJson(Map<String, dynamic> json) =>
      RecommendedLessonsResponse(
        status: json['status'],
        message: json['message'],
        data: json['data'] == null
            ? []
            : List<RecommendedLessonsData>.from(
                json['data']!.map((x) => RecommendedLessonsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class RecommendedLessonsData {
  final int? id;
  final String? title;
  final String? type;
  final String? image;
  final int? isFree;
  final int? courseId;
  final String? courseName;
  final List<dynamic>? labels;
  final Teacher? teacher;

  RecommendedLessonsData({
    this.id,
    this.title,
    this.type,
    this.image,
    this.isFree,
    this.courseId,
    this.courseName,
    this.labels,
    this.teacher,
  });

  factory RecommendedLessonsData.fromJson(Map<String, dynamic> json) => RecommendedLessonsData(
        id: json['id'],
        title: json['title'],
        type: json['type'],
        image: json['image'],
        isFree: json['is_free'],
        courseId: json['course_id'],
        courseName: json['course_name'],
        labels: json['labels'] == null ? [] : List<dynamic>.from(json['labels']!.map((x) => x)),
        teacher: json['teacher'] == null ? null : Teacher.fromJson(json['teacher']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'image': image,
        'is_free': isFree,
        'course_id': courseId,
        'course_name': courseName,
        'labels': labels == null ? [] : List<dynamic>.from(labels!.map((x) => x)),
        'teacher': teacher?.toJson(),
      };
}
