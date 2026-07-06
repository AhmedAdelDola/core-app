import '../../general/teacher.dart';

class GetAttachmentResponse {
  final int status;
  final String message;
  final GetAttachmentData data;

  GetAttachmentResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetAttachmentResponse.fromJson(Map<String, dynamic> json) => GetAttachmentResponse(
        status: json['status'],
        message: json['message'],
        data: GetAttachmentData.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.toJson(),
      };
}

class GetAttachmentData {
  final int id;
  final String name;
  final String description;
  final bool isFree;
  final int price;
  final int availability;
  final int isSubscribe;
  final int pageNumbers;
  final int courseId;
  final String course;
  final String chapterName;
  final int chapterId;
  final String sessionId;
  final String sessionTitle;
  final dynamic subjectId;
  final String subjectName;
  final String isSecondary;
  final Teacher teacher;

  GetAttachmentData({
    required this.id,
    required this.name,
    required this.description,
    required this.isFree,
    required this.price,
    required this.availability,
    required this.isSubscribe,
    required this.pageNumbers,
    required this.courseId,
    required this.course,
    required this.chapterName,
    required this.chapterId,
    required this.sessionId,
    required this.sessionTitle,
    required this.subjectId,
    required this.subjectName,
    required this.isSecondary,
    required this.teacher,
  });

  factory GetAttachmentData.fromJson(Map<String, dynamic> json) => GetAttachmentData(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        isFree: json['is_free'],
        price: json['price'],
        availability: json['availability'],
        isSubscribe: json['is_subscribe'],
        pageNumbers: json['pageNumbers'],
        courseId: json['course_id'],
        course: json['course'],
        chapterName: json['chapter_name'],
        chapterId: json['chapter_id'],
        sessionId: json['session_id'],
        sessionTitle: json['session_title'],
        subjectId: json['subject_id'],
        subjectName: json['subject_name'],
        isSecondary: json['is_secondary'],
        teacher: Teacher.fromJson(json['teacher']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'is_free': isFree,
        'price': price,
        'availability': availability,
        'is_subscribe': isSubscribe,
        'pageNumbers': pageNumbers,
        'course_id': courseId,
        'course': course,
        'chapter_name': chapterName,
        'chapter_id': chapterId,
        'session_id': sessionId,
        'session_title': sessionTitle,
        'subject_id': subjectId,
        'subject_name': subjectName,
        'is_secondary': isSecondary,
        'teacher': teacher.toJson(),
      };
}
