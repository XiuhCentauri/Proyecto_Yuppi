class GeminiResponseModel {
  final String text;

  GeminiResponseModel({required this.text});

  factory GeminiResponseModel.fromJson(Map<String, dynamic> json) {
    return GeminiResponseModel(
      text: json['candidates'][0]['content']['parts'][0]['text'],
    );
  }
}
