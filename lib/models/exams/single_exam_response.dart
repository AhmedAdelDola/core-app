import 'course_exams_response.dart';

class SingleExamResponse {
  CourseExamItem? exam;

  SingleExamResponse({this.exam});

  factory SingleExamResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return SingleExamResponse();
    return SingleExamResponse(
      exam: json['exam'] != null
          ? CourseExamItem.fromJson(json['exam'] as Map<String, dynamic>)
          : null,
    );
  }
}
