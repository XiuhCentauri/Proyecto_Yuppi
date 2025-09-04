import '../repositories/vision_analysis_repository.dart';
import '../entities/analyzed_record.dart';

class GetCorrectAnalyzedPhotosByKidIdUseCase {
  final VisionAnalysisRepository repository;

  GetCorrectAnalyzedPhotosByKidIdUseCase(this.repository);

  Future<List<AnalyzedRecord>> call(String kidId) async {
    return await repository.getCorrectAnalyzedPhotosByKidId(kidId);
  }
}
