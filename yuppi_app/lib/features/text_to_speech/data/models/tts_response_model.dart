class TtsResponse {
  final String audioContent; // Es base64 del audio

  TtsResponse({required this.audioContent});

  factory TtsResponse.fromJson(Map<String, dynamic> json) {
    return TtsResponse(audioContent: json['audioContent'] as String);
  }
}
