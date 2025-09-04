import 'package:yuppi_app/features/vision_analysis/domain/entities/analyzed_record.dart';
import 'package:yuppi_app/features/vision_analysis/domain/entities/analyzed_photo.dart';
import 'package:yuppi_app/features/photos/dominio/entities/captured_photo.dart';
import 'package:yuppi_app/features/vision_analysis/data/datasource/vision_api_data_source.dart';

abstract class VisionAnalysisRepository {
  Future<AnalyzedPhoto> analyzePhoto({
    required CapturedPhoto photo,
    required String expectedObject,
    required List<String> expectedObjectA,
    bool useBase64 = false,
    String? base64Image,
    VisionFeatureType featureType = VisionFeatureType.labelDetection,
  });

  Future<List<AnalyzedRecord>> getAnalyzedPhotosByKidId(String kidId);

  Future<List<AnalyzedRecord>> getCorrectAnalyzedPhotosByKidId(String kidId);

  Future<void> saveAnalyzedResult(AnalyzedRecord analyzed);

  Future<List<AnalyzedRecord>> getCrtSTypeExsByKid(
    String kidid,
    String subType,
  );
}
