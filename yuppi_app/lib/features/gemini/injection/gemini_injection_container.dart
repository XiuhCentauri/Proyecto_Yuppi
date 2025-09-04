import 'package:get_it/get_it.dart';

import 'package:yuppi_app/features/gemini/data/datasource/gemini_remote_datasource.dart';
import 'package:yuppi_app/features/gemini/data/repositories/gemini_repository_impl.dart';
import 'package:yuppi_app/features/gemini/domain/repositories/gemini_repository.dart';
import 'package:yuppi_app/features/gemini/domain/usecases/GeminiService.dart';

final geminiInjection = GetIt.instance;

class GeminiInjectionContainer {
  Future<void> init() async {
    geminiInjection.registerLazySingleton<GeminiRemoteDataSource>(
      () => GeminiRemoteDataSourceImpl(),
    );

    // Repository
    geminiInjection.registerLazySingleton<GeminiRepository>(
      () => GeminiRepositoryImpl(geminiInjection<GeminiRemoteDataSource>()),
    );

    // Service
    geminiInjection.registerLazySingleton<GeminiService>(
      () => GeminiService(repository: geminiInjection<GeminiRepository>()),
    );
  }
}
