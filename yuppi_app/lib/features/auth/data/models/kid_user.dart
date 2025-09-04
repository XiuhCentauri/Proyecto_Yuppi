import '../../dominio/entities/kid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KidUser {
  final String fullName;
  final String idParent;
  final String id;
  final String gender;
  final String issueKid;
  final int age;
  final int state;
  final String icon;
  final DateTime createdAt;
  KidUser({
    required this.id,
    required this.fullName,
    required this.idParent,
    required this.age,
    required this.gender,
    required this.issueKid,
    required this.icon,
    required this.state,
    required this.createdAt,
  });

  // Convierte a entidad Kid (más simple, para mostrar o usar en lógica)
  Kid toEntity() => Kid(
    id: id,
    fullName: fullName,
    idParent: idParent,
    age: age,
    gender: gender,
    icon: icon,
    issueKid: issueKid,
    hasLearningIssues: true,
  );

  // Crea KidUser desde Kid, agregando los campos que no están en Kid
  factory KidUser.fromEntity(
    Kid kid, {
    required int state,
    required DateTime createdAt,
  }) {
    return KidUser(
      id: kid.id,
      fullName: kid.fullName,
      idParent: kid.idParent,
      age: kid.age,
      gender: kid.gender,
      icon: kid.icon,
      issueKid: kid.issueKid,
      state: state,
      createdAt: createdAt,
    );
  }

  // Convierte a Map para base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'idParent': idParent,
      'age': age,
      'gender': gender,
      'issueKid': issueKid,
      'icon': icon,
      'state': state,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory KidUser.fromMap(Map<String, dynamic> map, {required String id}) {
    return KidUser(
      id: map['id'],
      fullName: map['fullName'] ?? '',
      idParent: map['idParent'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
      issueKid: map['issueKid'] ?? '',
      icon: map['icon'] ?? 0,
      state: map['state'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
