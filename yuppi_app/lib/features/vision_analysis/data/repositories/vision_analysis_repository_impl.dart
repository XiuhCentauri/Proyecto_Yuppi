import 'dart:developer';

import 'package:yuppi_app/features/photos/dominio/entities/captured_photo.dart';
import 'package:yuppi_app/features/vision_analysis/data/datasource/vision_api_data_source.dart';
import 'package:yuppi_app/features/vision_analysis/domain/entities/analyzed_photo.dart';
import 'package:yuppi_app/features/vision_analysis/domain/entities/analyzed_record.dart';
import 'package:yuppi_app/features/vision_analysis/domain/repositories/vision_analysis_repository.dart';
import 'package:yuppi_app/features/vision_analysis/data/datasource/vision_analysis_firebase_DS.dart';

class VisionAnalysisRepositoryImpl implements VisionAnalysisRepository {
  final VisionApiDataSource visionApiDataSource;
  final VisionAnalysisFirestoreDataSource firestoreDataSource;

  VisionAnalysisRepositoryImpl({
    required this.visionApiDataSource,
    required this.firestoreDataSource,
  });

  @override
  Future<AnalyzedPhoto> analyzePhoto({
    required CapturedPhoto photo,
    required String expectedObject,
    required List<String> expectedObjectA,
    bool useBase64 = true,
    String? base64Image,
    VisionFeatureType featureType = VisionFeatureType.labelDetection,
  }) async {
    List<String> labels = [];
    final bool isCorrect;
    log('🔍 Lista de sinónimos esperados (${expectedObjectA.length}):');
    for (final synonym in expectedObjectA) {
      log('👉 $synonym');
    }
    if (useBase64) {
      if (base64Image == null) {
        throw ArgumentError(
          'Se requiere la imagen en base64 si useBase64 es true',
        );
      }

      labels = featureType == VisionFeatureType.textDetection
          ? await visionApiDataSource.analyzeImageTextFromBase64(base64Image) ?? []
          : await visionApiDataSource.analyzeImageObjectsFromBase64(base64Image) ?? [];
    }

    final expectedUpper = expectedObject.toUpperCase();
    final synonymsUpper = expectedObjectA.map((e) => e.toUpperCase()).toList();

    bool matchesExpectedOrSynonyms(String label) {
      final labelUpper = label.toUpperCase();
      final labelParts = labelUpper.split(" ");

      // 1. Contiene el objeto esperado
      if (labelUpper.contains(expectedUpper)) return true;

      // 2. Contiene alguno de los sinónimos completos
      if (synonymsUpper.any((syn) => labelUpper.contains(syn))) return true;

      // 3. Coincide parcialmente por palabras individuales
      if (labelParts.any((part) => part == expectedUpper || synonymsUpper.contains(part))) {
        return true;
      }

      return false;
    }

    isCorrect = labels.any(matchesExpectedOrSynonyms);

    return AnalyzedPhoto(
      capturedPhoto: photo,
      labels: labels,
      isCorrect: isCorrect,
      evaluatedObject: expectedObject,
    );
  }


  bool _containsVowels(String label) {
    final vowels = ['A', 'E', 'I', 'O', 'U'];
    return label.split('').any((char) => vowels.contains(char));
  }

  bool _containsSpecificNumbers(String label) {
    final specificNumbers = ['1', '2', '3', '4', '5'];
    return label.split('').any((char) => specificNumbers.contains(char));
  }

  bool _containsExpectedCharacters(String label, String expectedObject) {
    return label.contains(expectedObject);
  }

  @override
  Future<void> saveAnalyzedResult(AnalyzedRecord analyzed) async {
    await firestoreDataSource.saveAnalyzedPhoto(analyzed);
  }

  @override
  Future<List<AnalyzedRecord>> getAnalyzedPhotosByKidId(String kidId) async {
    try {
      final snapshots = await firestoreDataSource.getAnalyzedPhotosByKidId(
        kidId,
      );
      return snapshots;
    } catch (e) {
      throw Exception('Error obteniendo resultados para el niño: $e');
    }
  }

  @override
  Future<List<AnalyzedRecord>> getCorrectAnalyzedPhotosByKidId(
    String kidId,
  ) async {
    try {
      final snapshots = await firestoreDataSource
          .getCorrectAnalyzedPhotosByKidId(kidId);
      return snapshots;
    } catch (e) {
      throw Exception('Error obteniendo resultados para el niño: $e');
    }
  }

  @override
  Future<List<AnalyzedRecord>> getCrtSTypeExsByKid(
    String kidId,
    String subType,
  ) async {
    try {
      final snapshots = await firestoreDataSource.getCrtSTypeExsByKid(
        kidId,
        subType,
      );

      return snapshots;
    } catch (e) {
      throw Exception('Error obteniendo resultados para el niño: $e');
    }
  }
}
