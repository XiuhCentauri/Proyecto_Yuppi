import 'dart:math';
import 'package:yuppi_app/features/camera/domian/entities/exercise.dart';
import 'package:yuppi_app/features/camera/domian/repositories/exerciserepository.dart';
import 'package:yuppi_app/features/vision_analysis/domain/repositories/vision_analysis_repository.dart';

class GetRandomExerciseBySubTypeUseCase {
  final ExerciseRepository exerciseRepository;
  final VisionAnalysisRepository visionAnalysisRepository;

  GetRandomExerciseBySubTypeUseCase(
    this.exerciseRepository,
    this.visionAnalysisRepository,
  );

  Future<Exercise?> call(String kidId, String subType) async {
    // 1. Traemos los ejercicios de ese subtipo
    final exercises = await exerciseRepository.getExercisesBySubType(subType);
    final activeExercises = exercises.where((e) => e.isActive).toList();

    if (activeExercises.isEmpty) return null;

    // 2. Obtenemos ejercicios ya jugados correctamente
    final analyzedRecords = await visionAnalysisRepository
        .getCorrectAnalyzedPhotosByKidId(kidId);
    final completedExerciseIds =
        analyzedRecords.map((record) => record.exerciseId).toSet();

    // 3. Filtramos los que aún no ha hecho correctamente
    final availableExercises =
        activeExercises
            .where(
              (exercise) => !completedExerciseIds.contains(exercise.idExercise),
            )
            .toList();

    if (availableExercises.isEmpty) return null;

    // 4. Elegimos uno aleatorio
    final random = Random();
    final randomIndex = random.nextInt(availableExercises.length);

    return availableExercises[randomIndex];
  }
}
