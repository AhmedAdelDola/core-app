class GeneralResponse {
  int? status;
  String? message;

  GeneralResponse({this.status, this.message});

  factory GeneralResponse.fromJson(Map<String, dynamic> json) =>
      GeneralResponse(
        status: json['status'] is num ? (json['status'] as num).toInt() : null,
        message: json['message'] as String?,
      );

  Map<String, dynamic> toJson() => {'status': status, 'message': message};
}
