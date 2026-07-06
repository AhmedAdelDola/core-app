import '../../general/teacher.dart';

class GetRecommendedFilesResponse {
  final int? status;
  final String? message;
  final List<RecommendedFilesData>? data;

  GetRecommendedFilesResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetRecommendedFilesResponse.fromJson(Map<String, dynamic> json) =>
      GetRecommendedFilesResponse(
        status: json['status'],
        message: json['message'],
        data: json['data'] == null
            ? []
            : List<RecommendedFilesData>.from(
                json['data']!.map((x) => RecommendedFilesData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class RecommendedFilesData {
  final int? id;
  final String? name;
  final bool? isFree;
  final int? pageNumbers;
  final int? courseId;
  final List<dynamic>? labels;
  final Teacher? teacher;

  RecommendedFilesData({
    this.id,
    this.name,
    this.isFree,
    this.pageNumbers,
    this.courseId,
    this.labels,
    this.teacher,
  });

  factory RecommendedFilesData.fromJson(Map<String, dynamic> json) => RecommendedFilesData(
        id: json['id'],
        name: json['name'],
        isFree: json['is_free'],
        pageNumbers: json['pageNumbers'],
        courseId: json['course_id'],
        labels: json['labels'] == null ? [] : List<dynamic>.from(json['labels']!.map((x) => x)),
        teacher: json['teacher'] == null ? null : Teacher.fromJson(json['teacher']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'is_free': isFree,
        'pageNumbers': pageNumbers,
        'course_id': courseId,
        'labels': labels == null ? [] : List<dynamic>.from(labels!.map((x) => x)),
        'teacher': teacher?.toJson(),
      };
}
