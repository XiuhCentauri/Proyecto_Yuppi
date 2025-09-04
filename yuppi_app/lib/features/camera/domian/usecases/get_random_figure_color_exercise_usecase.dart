import 'dart:math';
import 'package:yuppi_app/features/camera/domian/entities/exercise.dart';
import 'package:yuppi_app/features/camera/domian/repositories/exerciserepository.dart';
import 'package:yuppi_app/features/vision_analysis/domain/repositories/vision_analysis_repository.dart';

class GetRandomFigureColorExerciseUseCase {
  final ExerciseRepository exerciseRepository;
  final VisionAnalysisRepository visionAnalysisRepository;

  GetRandomFigureColorExerciseUseCase({
    required this.exerciseRepository,
    required this.visionAnalysisRepository,
  });

  Future<Exercise?> call(String kidId) async {
    // 1. Traemos todos los ejercicios de tipo 'figure_color'
    final exercises = await exerciseRepository.getExercisesByType(
      'figure_color',
    );
    final activeExercises = exercises.where((e) => e.isActive).toList();

    if (activeExercises.isEmpty) return null;

    // 2. Traemos todos los ejercicios ya jugados y correctos por el niño
    final analyzedRecords = await visionAnalysisRepository
        .getCorrectAnalyzedPhotosByKidId(kidId);
    final completedExerciseIds =
        analyzedRecords.map((record) => record.exerciseId).toSet();

    // 3. Filtramos ejercicios activos que el niño NO haya hecho correctamente
    final availableExercises =
        activeExercises
            .where(
              (exercise) => !completedExerciseIds.contains(exercise.idExercise),
            )
            .toList();

    if (availableExercises.isEmpty)
      return null; // No hay más ejercicios disponibles

    // 4. Elegimos un ejercicio aleatorio de los disponibles
    final random = Random();
    final randomIndex = random.nextInt(availableExercises.length);

    return availableExercises[randomIndex];
  }
}
