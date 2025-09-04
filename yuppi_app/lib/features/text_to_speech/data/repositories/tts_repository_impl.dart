import '../../data/datasources/tts_remote_data_source.dart';
import '../../domain/repositories/tts_repository.dart';
import '../../data/models/tts_response_model.dart';

class TtsRepositoryImpl implements TtsRepository {
  final TtsRemoteDataSource remoteDataSource;

  TtsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<TtsResponse> synthesizeText(String text) {
    return remoteDataSource.synthesizeText(text);
  }
}
