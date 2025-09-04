import '../repositories/vision_analysis_repository.dart';
import '../entities/analyzed_record.dart';

class GetAnalyzedPhotosByKidIdUseCase {
  final VisionAnalysisRepository repository;

  GetAnalyzedPhotosByKidIdUseCase(this.repository);

  Future<List<AnalyzedRecord>> call(String kidId) async {
    return await repository.getAnalyzedPhotosByKidId(kidId);
  }
}
