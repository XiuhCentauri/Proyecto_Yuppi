import '../../data/models/tts_response_model.dart';

abstract class TtsRepository {
  Future<TtsResponse> synthesizeText(String text);
}
