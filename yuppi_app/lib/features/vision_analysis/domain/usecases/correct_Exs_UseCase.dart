import 'package:yuppi_app/features/vision_analysis/domain/repositories/vision_analysis_repository.dart';

class CountCorrectExercisesBySubTypeUseCase {
  final VisionAnalysisRepository repository;

  CountCorrectExercisesBySubTypeUseCase(this.repository);

  Future<int> call(String kidId, String subType) async {
    final records = await repository.getCrtSTypeExsByKid(kidId, subType);
    return records.length;
  }
}
