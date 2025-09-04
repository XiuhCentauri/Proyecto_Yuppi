import 'package:get_it/get_it.dart';
import 'package:yuppi_app/features/text_to_speech/data/datasources/tts_remote_data_source.dart';
import 'package:yuppi_app/features/text_to_speech/domain/repositories/tts_repository.dart';
import 'package:yuppi_app/features/text_to_speech/data/repositories/tts_repository_impl.dart';
import 'package:yuppi_app/features/text_to_speech/domain/usecases/synthesize_text_usecase.dart';

final sl = GetIt.instance;

class TextToSpeechInjection {
  Future<void> init() async {
    // Data Source
    sl.registerLazySingleton<TtsRemoteDataSource>(
      () => TtsRemoteDataSource(
        apiKey:
            'API_KEY', // <<--- Pon tu API Key
      ),
    );

    // Repository
    sl.registerLazySingleton<TtsRepository>(
      () => TtsRepositoryImpl(remoteDataSource: sl()),
    );

    // Use Case
    sl.registerLazySingleton<SynthesizeTextUseCase>(
      () => SynthesizeTextUseCase(repository: sl()),
    );
  }
}
