//import 'package:yuppi_app/core/services/firebase_service.dart';
import 'package:yuppi_app/core/servicios/firebase_service.dart';
import 'package:yuppi_app/features/vision_analysis/domain/entities/analyzed_record.dart';
import 'dart:developer';

class VisionAnalysisFirestoreDataSource {
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> saveAnalyzedPhoto(AnalyzedRecord analyzed) async {
    final firestore = _firebaseService.firestore;

    await firestore.collection('analyzed_photos').add({
      'photoId': analyzed.photoId,
      'kidId': analyzed.kidId,
      'exerciseId': analyzed.exerciseId,
      'parentId': analyzed.parentId,
      'timestamp': analyzed.timestamp.toIso8601String(),
      'evaluatedObject': analyzed.evaluatedObject,
      'isCorrect': analyzed.isCorrect,
      'labels': analyzed.labelsDetected,
      'timeElapsed': analyzed.timeElapsed.inSeconds,
      'sourceType': analyzed.sourceType,
      'sourceSubType': analyzed.sourceSubType,
      'isPhoto': analyzed.IsPhoto,
    });

    log("se guardo en la base de datos");
  }

  Future<List<AnalyzedRecord>> getAnalyzedPhotosByKidId(String kidId) async {
    final firestore = _firebaseService.firestore;
    final querySnapshot =
        await firestore
            .collection('analyzed_photos')
            .where('kidId', isEqualTo: kidId)
            .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return AnalyzedRecord.fromMap(data);
    }).toList();
  }

  Future<List<AnalyzedRecord>> getCorrectAnalyzedPhotosByKidId(
    String kidId,
  ) async {
    final firestore = _firebaseService.firestore;
    final querySnapshot =
        await firestore
            .collection('analyzed_photos')
            .where('kidId', isEqualTo: kidId)
            .where('isCorrect', isEqualTo: true)
            .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return AnalyzedRecord.fromMap(data);
    }).toList();
  }

  Future<List<AnalyzedRecord>> getCrtSTypeExsByKid(
    String kidid,
    String subType,
  ) async {
    final firestore = _firebaseService.firestore;
    final querySnapshot =
        await firestore
            .collection('analyzed_photos')
            .where('kidId', isEqualTo: kidid)
            .where('isCorrect', isEqualTo: true)
            .where('sourceSubType', isEqualTo: subType)
            .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return AnalyzedRecord.fromMap(data);
    }).toList();
  }
}
