class SecurityConfigResponse {
  final String mode; // "off" | "monitor" | "enforce"
  final String? cloudProjectNumber;
  final String? deviceId;
  final bool isEnrolled;

  SecurityConfigResponse({
    required this.mode,
    this.cloudProjectNumber,
    this.deviceId,
    this.isEnrolled = false,
  });

  bool get isEnforced => mode.toLowerCase() == 'enforce';
  bool get isMonitor => mode.toLowerCase() == 'monitor';
  bool get isOff => mode.toLowerCase() == 'off';

  factory SecurityConfigResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['security'] is Map<String, dynamic>
        ? json['security'] as Map<String, dynamic>
        : (json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : json);

    return SecurityConfigResponse(
      mode: rawData['mode']?.toString() ??
          rawData['content_protection_mode']?.toString() ??
          'off',
      cloudProjectNumber: rawData['cloud_project_number']?.toString() ??
          rawData['play_integrity_cloud_project_number']?.toString() ??
          rawData['project_number']?.toString() ??
          rawData['play_integrity_project_number']?.toString() ??
          rawData['google_cloud_project_number']?.toString(),
      deviceId: rawData['device_id']?.toString(),
      isEnrolled: rawData['is_enrolled'] == true ||
          rawData['enrolled'] == true ||
          (rawData['device_id'] != null &&
              rawData['device_id'].toString().isNotEmpty),
    );
  }

  Map<String, dynamic> toJson() => {
        'content_protection_mode': mode,
        'play_integrity_cloud_project_number': cloudProjectNumber,
        'device_id': deviceId,
        'is_enrolled': isEnrolled,
      };
}
