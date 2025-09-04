import '../repositories/tts_repository.dart';
import '../../data/models/tts_response_model.dart';

class SynthesizeTextUseCase {
  final TtsRepository repository;

  SynthesizeTextUseCase({required this.repository});

  Future<TtsResponse> call(String text) async {
    return await repository.synthesizeText(text);
  }
}
