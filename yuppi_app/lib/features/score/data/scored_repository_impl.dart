import 'package:yuppi_app/features/score/domain/repositories/scored_repository.dart';
import 'package:yuppi_app/core/servicios/firebase_service.dart';
import 'package:yuppi_app/features/score/domain/entities/scored.dart';

class ScoredRepositoryImpl implements ScoredRepository {
  final _firestore = FirebaseService().firestore;

  final String collectionPath = "scoreKidGame";

  @override
  Future<Scored> getScoredById(String IdKid) async {
    try {
      final snapshot =
          await _firestore
              .collection(collectionPath)
              .where("IdKid", isEqualTo: IdKid)
              .get();

      if (snapshot.docs.isEmpty) {
        throw Exception("No hay un registro");
      }

      final scored = Scored.fromMap(snapshot.docs.first.data());

      return scored;
    } catch (e) {
      throw Exception("Algo ocurrio al obtener los datos ${e}");
    }
  }

  @override
  Future<bool> createScore(Scored _scored) async {
    try {
      final snapshot = await _firestore
          .collection(collectionPath)
          .doc(_scored.idScored)
          .set(_scored.toMap());

      return true;
    } catch (e) {
      throw Exception("Algo ocurrio al obtener los datos ${e}");
    }
  }

  @override
  Future<bool> updateScore(String IdKid, Scored newScore) async {
    try {
      final snapshot =
          await _firestore
              .collection(collectionPath)
              .where("IdKid", isEqualTo: IdKid)
              .get();

      if (snapshot.docs.isEmpty) {
        throw Exception("No hay registro del nino");
      }
      await _firestore
          .collection(collectionPath)
          .doc(newScore.idScored)
          .update(newScore.toMap());

      return true;
    } catch (e) {
      throw Exception("Error: ${e}");
    }
  }
}
