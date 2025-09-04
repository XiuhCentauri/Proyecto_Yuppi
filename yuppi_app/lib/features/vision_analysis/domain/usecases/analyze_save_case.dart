import 'package:yuppi_app/features/vision_analysis/domain/entities/analyzed_record.dart';
import 'package:yuppi_app/features/vision_analysis/domain/repositories/vision_analysis_repository.dart';

class SaveAnalyzedPhotoUseCase {
  final VisionAnalysisRepository repository;

  SaveAnalyzedPhotoUseCase({required this.repository});

  Future<void> call(AnalyzedRecord analyzed) async {
    await repository.saveAnalyzedResult(analyzed);
  }
}
