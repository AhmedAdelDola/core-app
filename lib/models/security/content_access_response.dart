class ContentAccessResponse {
  final String? playbackToken;
  final String? playerUrl;
  final String? resolveEndpoint;
  final String? pdfUrl;

  ContentAccessResponse({
    this.playbackToken,
    this.playerUrl,
    this.resolveEndpoint,
    this.pdfUrl,
  });

  factory ContentAccessResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] is Map<String, dynamic> ? json['data'] : json;

    return ContentAccessResponse(
      playbackToken: rawData['playback_token']?.toString(),
      playerUrl: rawData['player_url']?.toString(),
      resolveEndpoint: rawData['resolve_endpoint']?.toString(),
      pdfUrl: rawData['pdf_url']?.toString() ??
          rawData['url']?.toString() ??
          rawData['link']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'playback_token': playbackToken,
        'player_url': playerUrl,
        'resolve_endpoint': resolveEndpoint,
        'pdf_url': pdfUrl,
      };
}
