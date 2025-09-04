import 'package:yuppi_app/features/vision_analysis/domain/repositories/vision_analysis_repository.dart';
import '../entities/analyzed_record.dart';

class GetExcercisegoodSubtypeUsecase {
  final VisionAnalysisRepository repository;

  GetExcercisegoodSubtypeUsecase(this.repository);

  Future<List<AnalyzedRecord>> call(String kidId, String subType) async {
    final records = await repository.getCrtSTypeExsByKid(kidId, subType);

    return records;
  }
}
