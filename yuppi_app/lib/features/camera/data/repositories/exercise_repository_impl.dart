import 'package:yuppi_app/features/camera/domian/entities/exercise.dart';
import 'package:yuppi_app/features/camera/domian/repositories/exerciserepository.dart';
import 'package:yuppi_app/core/servicios/firebase_service.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final FirebaseService _firebaseService = FirebaseService();

  ExerciseRepositoryImpl();

  @override
  Future<List<Exercise>> getAllExercises() async {
    final snapshot =
        await _firebaseService.firestore.collection('Exercises').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return _exerciseFromMap(data);
    }).toList();
  }

  @override
  Future<Exercise?> getExerciseById(String id) async {
    final doc =
        await _firebaseService.firestore.collection('Exercises').doc(id).get();

    if (doc.exists) {
      return _exerciseFromMap(doc.data()!);
    } else {
      return null;
    }
  }

  @override
  Future<List<Exercise>> getExercisesByType(String type) async {
    final snapshot =
        await _firebaseService.firestore
            .collection('Exercises')
            .where('Type', isEqualTo: type)
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return _exerciseFromMap(data);
    }).toList();
  }

  @override
  Future<List<Exercise>> getExercisesBySubType(String subType) async {
    final snapshot =
        await _firebaseService.firestore
            .collection('Exercises')
            .where('SubType', isEqualTo: subType)
            .where("IsActive", isEqualTo: true)
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return _exerciseFromMap(data);
    }).toList();
  }

  Exercise _exerciseFromMap(Map<String, dynamic> map) {
    return Exercise(
      idExercise: map['IdExercise'] ?? '',
      imagePath: map['ImagePath'] ?? '',
      isActive: map['IsActive'] ?? true,
      nameObjectEng: map['NameObjectEng'] ?? '',
      nameObjectEngA:List<String>.from(map['NameObjectEngA'] ?? []),
      nameObjectSpa: map['NameObjectSpa'] ?? '',
      type: map['Type'] ?? '',
      subType: map['SubType'] ?? '',
      detection: map['detection'] ?? '',
    );
  }
}
