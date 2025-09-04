import 'package:yuppi_app/features/camera/domian/entities/exercise.dart';

abstract class ExerciseRepository {
  Future<List<Exercise>> getAllExercises();
  Future<Exercise?> getExerciseById(String id);
  Future<List<Exercise>> getExercisesByType(String type);
  Future<List<Exercise>> getExercisesBySubType(String subType);
}
