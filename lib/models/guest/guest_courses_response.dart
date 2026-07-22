import '../home_entities/home/get_home.dart';

class GuestCoursesResponse {
  final List<RecommendedCourse> courses;

  GuestCoursesResponse({required this.courses});

  factory GuestCoursesResponse.fromJson(Map<String, dynamic> json) {
    return GuestCoursesResponse(
      courses: json["courses"] == null
          ? []
          : List<RecommendedCourse>.from(
              json["courses"]!.map((x) => RecommendedCourse.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "courses": List<dynamic>.from(courses.map((x) => x.toJson())),
    };
  }
}
