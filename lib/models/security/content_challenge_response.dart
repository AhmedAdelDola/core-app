class ContentChallengeResponse {
  final String challengeId;
  final String payloadToSign;
  final bool playIntegrityRefreshDue;
  final bool playIntegrityTokenRequired;
  final String? playIntegrityRequestHash;

  ContentChallengeResponse({
    required this.challengeId,
    required this.payloadToSign,
    required this.playIntegrityRefreshDue,
    required this.playIntegrityTokenRequired,
    this.playIntegrityRequestHash,
  });

  bool get needsPlayIntegrityToken =>
      playIntegrityRefreshDue || playIntegrityTokenRequired;

  factory ContentChallengeResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] is Map<String, dynamic> ? json['data'] : json;

    return ContentChallengeResponse(
      challengeId: rawData['challenge_id']?.toString() ??
          rawData['id']?.toString() ??
          '',
      payloadToSign: rawData['payload_to_sign']?.toString() ?? '',
      playIntegrityRefreshDue:
          rawData['play_integrity_refresh_due'] == true,
      playIntegrityTokenRequired:
          rawData['play_integrity_token_required'] == true,
      playIntegrityRequestHash:
          rawData['play_integrity_request_hash']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'challenge_id': challengeId,
        'payload_to_sign': payloadToSign,
        'play_integrity_refresh_due': playIntegrityRefreshDue,
        'play_integrity_token_required': playIntegrityTokenRequired,
        'play_integrity_request_hash': playIntegrityRequestHash,
      };
}
