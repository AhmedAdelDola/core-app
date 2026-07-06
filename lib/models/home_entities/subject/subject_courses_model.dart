// import '../../general/rating.dart';
// import '../../general/teacher.dart';
// import '../../profile/get_notifications_response.dart';

// class SubjectCoursesResponse {
//   final List<SubjectCourses>? data;
//   final Links? links;
//   final Meta? meta;

//   SubjectCoursesResponse({
//     this.data,
//     this.links,
//     this.meta,
//   });

//   factory SubjectCoursesResponse.fromJson(Map<String, dynamic> json) => SubjectCoursesResponse(
//         data: json['data'] == null
//             ? []
//             : List<SubjectCourses>.from(json['data']!.map((x) => SubjectCourses.fromJson(x))),
//         links: json['links'] == null ? null : Links.fromJson(json['links']),
//         meta: json['meta'] == null ? null : Meta.fromJson(json['meta']),
//       );

//   Map<String, dynamic> toJson() => {
//         'data': data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
//         'links': links?.toJson(),
//         'meta': meta?.toJson(),
//       };
// }

// class SubjectCourses {
//   final int? id;
//   final String? sliders;
//   final String? title;
//   final int? isFree;
//   final bool? isFavourite;
//   final int? notificationCounter;
//   final Rating? rating;
//   final Teacher? teacher;
//   final bool? subscribed;
//   final List<dynamic>? labels;

//   SubjectCourses({
//     this.id,
//     this.sliders,
//     this.title,
//     this.isFree,
//     this.isFavourite,
//     this.notificationCounter,
//     this.rating,
//     this.teacher,
//     this.subscribed,
//     this.labels,
//   });

//   factory SubjectCourses.fromJson(Map<String, dynamic> json) => SubjectCourses(
//         id: json['id'],
//         sliders: json['sliders'],
//         title: json['title'],
//         isFree: json['is_free'],
//         isFavourite: json['is_favourite'],
//         notificationCounter: json['notification_counter'],
//         rating: json['rating'] == null ? null : Rating.fromJson(json['rating']),
//         teacher: json['teacher'] == null ? null : Teacher.fromJson(json['teacher']),
//         subscribed: json['subscribed'],
//         labels: json['labels'] == null ? [] : List<dynamic>.from(json['labels']!.map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'sliders': sliders,
//         'title': title,
//         'is_free': isFree,
//         'is_favourite': isFavourite,
//         'notification_counter': notificationCounter,
//         'rating': rating?.toJson(),
//         'teacher': teacher?.toJson(),
//         'subscribed': subscribed,
//         'labels': labels == null ? [] : List<dynamic>.from(labels!.map((x) => x)),
//       };
// }
