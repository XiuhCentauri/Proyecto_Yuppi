import '../entities/captured_photo.dart';

abstract class PhotoRepository {
  /// Guarda una foto capturada en la base de datos (y/o storage)
  Future<String> saveCapturedPhoto(CapturedPhoto photo);
}
