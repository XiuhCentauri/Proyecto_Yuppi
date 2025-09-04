import 'package:yuppi_app/features/photos/dominio/repositories/photo_repository.dart';
import 'package:yuppi_app/features/photos/dominio/entities/captured_photo.dart';

class SaveCapturedPhoto {
  final PhotoRepository repository;

  SaveCapturedPhoto(this.repository);

  Future<String> call(CapturedPhoto photo) async {
    String id = await repository.saveCapturedPhoto(photo);
    return id;
  }
}
