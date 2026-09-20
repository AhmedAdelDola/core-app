class AttestationChallengeResponse {
  final String challengeId;
  final String payloadToSign;
  final String playIntegrityRequestHash;
  final String? cloudProjectNumber;

  AttestationChallengeResponse({
    required this.challengeId,
    required this.payloadToSign,
    required this.playIntegrityRequestHash,
    this.cloudProjectNumber,
  });

  factory AttestationChallengeResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] is Map<String, dynamic> ? json['data'] : json;

    return AttestationChallengeResponse(
      challengeId: rawData['challenge_id']?.toString() ??
          rawData['id']?.toString() ??
          '',
      payloadToSign: rawData['payload_to_sign']?.toString() ?? '',
      playIntegrityRequestHash:
          rawData['play_integrity_request_hash']?.toString() ?? '',
      cloudProjectNumber: rawData['play_integrity_cloud_project_number']
              ?.toString() ??
          rawData['cloud_project_number']?.toString() ??
          rawData['project_number']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'challenge_id': challengeId,
        'payload_to_sign': payloadToSign,
        'play_integrity_request_hash': playIntegrityRequestHash,
        'cloud_project_number': cloudProjectNumber,
      };
}
