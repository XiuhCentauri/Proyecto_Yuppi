import 'parent_validator.dart';
import 'package:yuppi_app/core/servicios/firebase_service.dart';

class FirebaseParentValidator implements ParentValidator {
  FirebaseParentValidator();
  final firestore = FirebaseService().firestore;

  @override
  Future<bool> emailExists(String email, {String? excludeId}) async {
    final snapshot =
        await firestore
            .collection('parents')
            .where('email', isEqualTo: email)
            .get();

    return snapshot.docs.any((doc) => doc.id != excludeId);
  }

  @override
  Future<bool> usernameExists(String username, {String? excludeId}) async {
    final snapshot =
        await firestore
            .collection('parents')
            .where('user', isEqualTo: username)
            .get();

    return snapshot.docs.any((doc) => doc.id != excludeId);
  }

  @override
  Future<bool> phoneNumberExists(
    String phoneNumber, {
    String? excludeId,
  }) async {
    final snapshot =
        await firestore
            .collection('parents')
            .where('phoneNumber', isEqualTo: phoneNumber)
            .get();

    return snapshot.docs.any((doc) => doc.id != excludeId);
  }
}
