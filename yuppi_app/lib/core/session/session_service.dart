import 'package:yuppi_app/features/auth/dominio/entities/parent.dart';
import 'package:yuppi_app/features/auth/dominio/entities/kid.dart';

class ParentSession {
  final Parent parent;
  final List<Kid> children;

  ParentSession({required this.parent, required this.children});

  // Puedes agregar getters o funciones de utilidad si lo necesitas más adelante
}
