import 'package:get_it/get_it.dart';
import 'package:yuppi_app/features/vision_analysis/data/datasource/vision_api_data_source.dart';
import 'package:yuppi_app/features/vision_analysis/data/repositories/vision_analysis_repository_impl.dart';
import 'package:yuppi_app/features/vision_analysis/domain/repositories/vision_analysis_repository.dart';
import 'package:yuppi_app/features/vision_analysis/data/datasource/vision_analysis_firebase_DS.dart';

import 'package:yuppi_app/features/vision_analysis/domain/usecases/analyze_photo_case.dart';
import 'package:yuppi_app/features/vision_analysis/domain/usecases/analyze_save_case.dart';
import 'package:yuppi_app/features/vision_analysis/domain/usecases/get_crtald_photosbykidid_usecase.dart';
import 'package:yuppi_app/features/vision_analysis/domain/usecases/get_ap_bykidid_usecase.dart';
import 'package:yuppi_app/features/vision_analysis/domain/usecases/correct_Exs_UseCase.dart';
import 'package:yuppi_app/features/vision_analysis/domain/usecases/get_excerciseGood_Subtype_usecase.dart';

final visionInjection = GetIt.instance;

class VisionAnalysisInjection {
  Future<void> init() async {
    // Data Sources
    visionInjection.registerLazySingleton<VisionApiDataSource>(
      () => VisionApiDataSource(
        apiKey: 'Tu_API_KEY',
      ),
    );

    visionInjection.registerLazySingleton<VisionAnalysisFirestoreDataSource>(
      () => VisionAnalysisFirestoreDataSource(),
    );

    // Repository
    visionInjection.registerLazySingleton<VisionAnalysisRepository>(
      () => VisionAnalysisRepositoryImpl(
        visionApiDataSource: visionInjection<VisionApiDataSource>(),
        firestoreDataSource:
            visionInjection<VisionAnalysisFirestoreDataSource>(),
      ),
    );

    // UseCases
    visionInjection.registerLazySingleton<AnalyzePhotoUseCase>(
      () => AnalyzePhotoUseCase(
        repository: visionInjection<VisionAnalysisRepository>(),
      ),
    );

    visionInjection.registerLazySingleton<SaveAnalyzedPhotoUseCase>(
      () => SaveAnalyzedPhotoUseCase(
        repository: visionInjection<VisionAnalysisRepository>(),
      ),
    );

    visionInjection.registerLazySingleton<GetAnalyzedPhotosByKidIdUseCase>(
      () => GetAnalyzedPhotosByKidIdUseCase(
        visionInjection<VisionAnalysisRepository>(),
      ),
    );

    visionInjection
        .registerLazySingleton<GetCorrectAnalyzedPhotosByKidIdUseCase>(
          () => GetCorrectAnalyzedPhotosByKidIdUseCase(
            visionInjection<VisionAnalysisRepository>(),
          ),
        );

    visionInjection
        .registerLazySingleton<CountCorrectExercisesBySubTypeUseCase>(
          () => CountCorrectExercisesBySubTypeUseCase(
            visionInjection<VisionAnalysisRepository>(),
          ),
        );

    visionInjection.registerLazySingleton<GetExcercisegoodSubtypeUsecase>(
      () => GetExcercisegoodSubtypeUsecase(
        visionInjection<VisionAnalysisRepository>(),
      ),
    );
  }
}
