import 'package:uuid/uuid.dart';

final Uuid _uuid = Uuid();

/// Genera un UUID v4 (aleatorio)
String generateUuid() {
  return _uuid.v4();
}
