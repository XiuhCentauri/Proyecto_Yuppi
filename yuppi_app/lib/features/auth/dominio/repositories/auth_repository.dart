import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/parent.dart';
import "../../data/models/parent_user.dart";
import "../entities/kid.dart";
import "../../data/models/kid_user.dart";

abstract class AuthRepository {
  Future<void> registerParent({
    required Parent parent,
    required String passwordHash,
    required int state,
    required bool emailVerified,
  });
  Future<ParentUser?> getParentByEmail(String email);
  Future<ParentUser?> getParentByUser(String user);
  Future<void> registerKid({required Kid kid});

  Future<bool> emailExists(String email);
  Future<bool> usernameExists(String username);
  Future<bool> phoneNumberExists(String phoneNumber);
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseFirestore firestore;
  final CollectionReference parentsCollection;
  final CollectionReference kidsCollection;

  AuthRepositoryImpl(this.firestore)
    : parentsCollection = firestore.collection('parents'),
      kidsCollection = firestore.collection('kids');

  @override
  Future<void> registerParent({
    required Parent parent,
    required String passwordHash,
    required int state,
    required bool emailVerified,
  }) async {
    final parentUser = ParentUser.fromEntity(
      parent,
      passwordHash: passwordHash,
      state: state,
      role: 1,
      emailVerified: emailVerified,
      createdAt: DateTime.now(),
    );

    await parentsCollection.doc(parentUser.id).set(parentUser.toMap());
  }

  @override
  Future<void> registerKid({required Kid kid}) async {
    final kidUser = KidUser.fromEntity(
      kid,
      state: 2,
      createdAt: DateTime.now(),
    );

    await kidsCollection.doc(kid.id).set(kidUser.toMap());
  }

  @override
  Future<ParentUser?> getParentByEmail(String email) async {
    final snapshot =
        await firestore
            .collection('parents')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

    if (snapshot.docs.isEmpty) return null;

    final doc = snapshot.docs.first;
    return ParentUser.fromMap(doc.data(), email: email);
  }

  @override
  Future<ParentUser?> getParentByUser(String user) async {
    final snapshot =
        await firestore
            .collection('parents')
            .where('user', isEqualTo: user)
            .limit(1)
            .get();

    if (snapshot.docs.isEmpty) return null;

    final doc = snapshot.docs.first;
    return ParentUser.fromMap(doc.data(), email: doc.data()['email']);
  }

  @override
  Future<bool> emailExists(String email) async {
    final snapshot =
        await parentsCollection.where('email', isEqualTo: email).get();

    return snapshot.docs.isNotEmpty;
  }

  @override
  Future<bool> usernameExists(String username) async {
    final snapshot =
        await parentsCollection.where('user', isEqualTo: username).get();

    return snapshot.docs.isNotEmpty;
  }

  @override
  Future<bool> phoneNumberExists(String phoneNumber) async {
    final snapshot =
        await parentsCollection
            .where('phoneNumber', isEqualTo: phoneNumber)
            .get();

    return snapshot.docs.isNotEmpty;
  }
}
