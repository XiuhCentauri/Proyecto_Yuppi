import 'package:get_it/get_it.dart';
import '../data/repositories/exercise_repository_impl.dart';
import 'package:yuppi_app/features/camera/domian/repositories/exerciserepository.dart';
import 'package:yuppi_app/features/camera/domian/usecases/get_random_object_exercise_usecase.dart';
import 'package:yuppi_app/features/camera/domian/usecases/get_RanExer_BySubType_UseCase.dart';
import 'package:yuppi_app/features/camera/domian/usecases/get_random_figure_color_exercise_usecase.dart';
import 'package:yuppi_app/features/vision_analysis/domain/repositories/vision_analysis_repository.dart';
import 'package:yuppi_app/features/camera/domian/usecases/get_exerciseById_usecase.dart';

final sl = GetIt.instance;

class CameraInjection {
  Future<void> init() async {
    sl.registerLazySingleton<ExerciseRepository>(
      () => ExerciseRepositoryImpl(),
    );

    sl.registerLazySingleton<GetRandomExerciseBySubTypeUseCase>(
      () => GetRandomExerciseBySubTypeUseCase(
        sl<ExerciseRepository>(),
        sl<VisionAnalysisRepository>(),
      ),
    );
    // Use Cases
    sl.registerLazySingleton<GetRandomObjectExerciseUseCase>(
      () => GetRandomObjectExerciseUseCase(
        sl<ExerciseRepository>(),
        sl<VisionAnalysisRepository>(),
      ),
    );

    sl.registerLazySingleton<GetRandomFigureColorExerciseUseCase>(
      () => GetRandomFigureColorExerciseUseCase(
        exerciseRepository: sl<ExerciseRepository>(),
        visionAnalysisRepository: sl<VisionAnalysisRepository>(),
      ),
    );

    sl.registerLazySingleton<GetExercisebyidUsecase>(
      () =>
          GetExercisebyidUsecase(exerciseRepository: sl<ExerciseRepository>()),
    );
  }
}
