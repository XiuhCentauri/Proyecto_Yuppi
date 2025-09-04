import 'package:yuppi_app/features/photos/dominio/entities/captured_photo.dart';
import 'package:yuppi_app/features/vision_analysis/domain/entities/analyzed_photo.dart';
import 'package:yuppi_app/features/vision_analysis/domain/repositories/vision_analysis_repository.dart';
import 'package:yuppi_app/features/vision_analysis/data/datasource/vision_api_data_source.dart';

class AnalyzePhotoUseCase {
  final VisionAnalysisRepository repository;

  AnalyzePhotoUseCase({required this.repository});

  Future<AnalyzedPhoto> call({
    required CapturedPhoto photo,
    required String expectedObject,
    required List<String> expectedObjectA,
    bool useBase64 = false,
    String? base64Image,
    required VisionFeatureType featureType,
  }) async {
    return await repository.analyzePhoto(
      photo: photo,
      expectedObject: expectedObject,
      expectedObjectA: expectedObjectA,
      useBase64: useBase64,
      base64Image: base64Image,
      featureType: featureType,
    );
  }
}
