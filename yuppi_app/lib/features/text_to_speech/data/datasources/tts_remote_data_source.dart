import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tts_response_model.dart';

class TtsRemoteDataSource {
  final String apiKey; // Inyectable

  TtsRemoteDataSource({required this.apiKey});

  Future<TtsResponse> synthesizeText(String text) async {
    final url = Uri.parse(
      'https://texttospeech.googleapis.com/v1/text:synthesize?key=$apiKey',
    );

    final body = jsonEncode({
      "input": {"text": text},
      "voice": {
        "languageCode": "es-ES",
        "ssmlGender": "FEMALE",
        "name": "es-ES-Neural2-C", // 👈 Sí existe y es buena
      },
      "audioConfig": {
        "audioEncoding": "MP3",
        "speakingRate": 0.9, // 👈 Un poquito más lento
        "pitch": 2.0, // 👈 Un poquito más agudo
      },
    });

    final response = await http.post(
      url,
      body: body,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return TtsResponse.fromJson(data);
    } else {
      throw Exception('Failed to synthesize text: ${response.body}');
    }
  }
}
