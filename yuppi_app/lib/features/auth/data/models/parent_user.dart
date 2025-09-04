import "../../dominio/entities/parent.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentUser {
  final String id;
  final String user;
  final String email;
  final bool emailVerified;
  final String fullName;
  final int role;
  final String passwordHash;
  final String phoneNumber;
  final int state;
  final String stateCountry;
  final DateTime createdAt;

  ParentUser({
    required this.id,
    required this.user,
    required this.email,
    required this.emailVerified,
    required this.fullName,
    required this.passwordHash,
    required this.phoneNumber,

    required this.role,
    required this.state,
    required this.stateCountry,
    required this.createdAt,
  });

  Parent toEntity() => Parent(
    id: id,
    email: email,
    fullName: fullName,
    user: user,
    phoneNumber: phoneNumber,
    stateCountry: stateCountry,
    passwordHash: passwordHash,
  );

  factory ParentUser.fromEntity(
    Parent parent, {
    required String passwordHash,
    required bool emailVerified,
    required int role,
    required int state,
    required DateTime createdAt,
  }) {
    return ParentUser(
      id: parent.id,
      user: parent.user,
      email: parent.email,
      fullName: parent.fullName,
      phoneNumber: parent.phoneNumber,
      stateCountry: parent.stateCountry,
      passwordHash: passwordHash,
      emailVerified: emailVerified,
      role: role,
      state: state,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
      'email': email,
      'fullName': fullName,
      'emailVerified': emailVerified,
      'passwordHash': passwordHash,
      'phoneNumber': phoneNumber,
      'role': role,
      'state': state,
      'stateCountry': stateCountry,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ParentUser.fromMap(
    Map<String, dynamic> map, {
    required String email,
  }) {
    return ParentUser(
      id: map['id'],
      user: map['user'] ?? '',
      fullName: map['fullName'] ?? '',
      email: email,
      emailVerified: map['emailVerified'] ?? false,
      passwordHash: map['passwordHash'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      stateCountry: map['stateCountry'],
      role: map['role'] ?? 1,
      state: map['state'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
