import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yuppi_app/features/gemini/data/models/gemini_response_model.dart';

abstract class GeminiRemoteDataSource {
  Future<GeminiResponseModel> getTextFromPrompt(String prompt);
}

class GeminiRemoteDataSourceImpl implements GeminiRemoteDataSource {
  final String _apiKey = 'API_KEY';

  @override
  Future<GeminiResponseModel> getTextFromPrompt(String prompt) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      return GeminiResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error: ${response.body}');
    }
  }
}
