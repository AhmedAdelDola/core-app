import '../user_response/user_data.dart';

class FavouriteCourseResponse {
  final UserModelResponse? data;
  final int? status;
  final String? message;
  FavouriteCourseResponse({this.data, this.status, this.message});

  factory FavouriteCourseResponse.fromJson(Map<String, dynamic> json) => FavouriteCourseResponse(
        data: json['data'] == null ? null : UserModelResponse.fromJson(json['data']),
        status: json['status'],
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
        'status': status,
        'message': message,
      };
}
