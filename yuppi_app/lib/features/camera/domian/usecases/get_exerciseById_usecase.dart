import 'package:yuppi_app/features/camera/domian/entities/exercise.dart';
import 'package:yuppi_app/features/camera/domian/repositories/exerciserepository.dart';

class GetExercisebyidUsecase {
  final ExerciseRepository exerciseRepository;

  GetExercisebyidUsecase({required this.exerciseRepository});

  Future<List<Exercise>> call() async {
    var exercise = await exerciseRepository.getAllExercises();

    return exercise;
  }
}
