import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  final bytes = utf8.encode(password); // convierte a bytes
  final digest = sha256.convert(bytes); // aplica SHA-256
  return digest.toString(); // devuelve el hash en texto
}
