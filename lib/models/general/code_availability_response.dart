class CodeAvailabilityResponse {
  final int? appleVersion;
  final bool? isCodeAvailable;

  CodeAvailabilityResponse({this.appleVersion, this.isCodeAvailable});

  factory CodeAvailabilityResponse.fromJson(Map<String, dynamic> json) =>
      CodeAvailabilityResponse(
        appleVersion: json['apple_version'] is num
            ? (json['apple_version'] as num).toInt()
            : null,
        isCodeAvailable: json['is_code_available'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'apple_version': appleVersion,
        'is_code_available': isCodeAvailable,
      };
}
