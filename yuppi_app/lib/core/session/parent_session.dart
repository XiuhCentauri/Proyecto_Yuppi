import 'package:yuppi_app/core/servicios/firebase_service.dart';
import 'package:yuppi_app/features/auth/data/models/kid_user.dart';
import 'package:yuppi_app/features/auth/dominio/entities/parent.dart';
import 'package:yuppi_app/features/auth/dominio/entities/kid.dart';

class ParentSession {
  final Parent parent;
  final List<Kid> children;

  ParentSession._({required this.parent, required this.children});

  static Future<ParentSession> create(Parent parent) async {
    final firestore = FirebaseService().firestore;

    final snapshot =
        await firestore
            .collection('kids')
            .where('idParent', isEqualTo: parent.id)
            .get();

    final children =
        snapshot.docs
            .map((doc) => KidUser.fromMap(doc.data(), id: doc.id).toEntity())
            .toList();

    return ParentSession._(parent: parent, children: children);
  }

  Future<ParentSession> refresh() async {
    return await ParentSession.create(parent);
  }
}
