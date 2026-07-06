// // To parse this JSON data, do
// //
// //     final qrResponse = qrResponseFromJson(jsonString);

// import 'dart:convert';

// import '../general/general_selectable_entity.dart';
// import '../general/teacher.dart';

// QrResponse qrResponseFromJson(String str) =>
//     QrResponse.fromJson(json.decode(str));

// String qrResponseToJson(QrResponse data) => json.encode(data.toJson());

// class QrResponse {
//   int? status;
//   String? message;
//   Data? data;

//   QrResponse({
//     this.status,
//     this.message,
//     this.data,
//   });

//   factory QrResponse.fromJson(Map<String, dynamic> json) => QrResponse(
//         status: json["status"],
//         message: json["message"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "data": data?.toJson(),
//       };
// }

// class Data {
//   int? id;
//   String? courseName;
//   String? levelName;
//   String? startDate;
//   String? endDate;
//   int? rate;
//   int? numberOfRate;
//   String? description;
//   bool? isFree;
//   bool? isFav;
//   bool? subscriptionStatus;
//   int? price;
//   List<String>? imagesUrls;
//   String? subscriptionType;
//   String? subscribeUntil;
//   Teacher? teacher;
//   Level? level;

//   Data({
//     this.id,
//     this.courseName,
//     this.levelName,
//     this.startDate,
//     this.endDate,
//     this.rate,
//     this.numberOfRate,
//     this.description,
//     this.isFree,
//     this.isFav,
//     this.subscriptionStatus,
//     this.price,
//     this.imagesUrls,
//     this.subscriptionType,
//     this.subscribeUntil,
//     this.teacher,
//     this.level,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         id: json["id"],
//         courseName: json["course_name"],
//         levelName: json["level_name"],
//         startDate: json["start_date"],
//         endDate: json["end_date"],
//         rate: json["rate"],
//         numberOfRate: json["number_of_rate"],
//         description: json["description"],
//         isFree: json["is_free"],
//         isFav: json["is_fav"],
//         subscriptionStatus: json["subscription_status"],
//         price: json["price"],
//         imagesUrls: json["imagesUrls"] == null
//             ? []
//             : List<String>.from(json["imagesUrls"]!.map((x) => x)),
//         subscriptionType: json["subscription_type"],
//         subscribeUntil: json["subscribe_until"],
//         teacher:
//             json["teacher"] == null ? null : Teacher.fromJson(json["teacher"]),
//         level: json["level"] == null ? null : Level.fromJson(json["level"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "course_name": courseName,
//         "level_name": levelName,
//         "start_date": startDate,
//         "end_date": endDate,
//         "rate": rate,
//         "number_of_rate": numberOfRate,
//         "description": description,
//         "is_free": isFree,
//         "is_fav": isFav,
//         "subscription_status": subscriptionStatus,
//         "price": price,
//         "imagesUrls": imagesUrls == null
//             ? []
//             : List<dynamic>.from(imagesUrls!.map((x) => x)),
//         "subscription_type": subscriptionType,
//         "subscribe_until": subscribeUntil,
//         "teacher": teacher?.toJson(),
//         "level": level?.toJson(),
//       };
// }

// class Level {
//   int? id;
//   Grade? university;
//   Grade? stage;
//   Grade? grade;

//   Level({
//     this.id,
//     this.university,
//     this.stage,
//     this.grade,
//   });

//   factory Level.fromJson(Map<String, dynamic> json) => Level(
//         id: json["id"],
//         university: json["university"] == null
//             ? null
//             : Grade.fromJson(json["university"]),
//         stage: json["stage"] == null ? null : Grade.fromJson(json["stage"]),
//         grade: json["grade"] == null ? null : Grade.fromJson(json["grade"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "university": university?.toJson(),
//         "stage": stage?.toJson(),
//         "grade": grade?.toJson(),
//       };
// }
