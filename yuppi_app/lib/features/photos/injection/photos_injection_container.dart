import 'package:get_it/get_it.dart';
import 'package:yuppi_app/features/photos/data/repositories/firabase_photo_repository.dart';
import 'package:yuppi_app/features/photos/dominio/repositories/photo_repository.dart';
import 'package:yuppi_app/features/photos/dominio/usecases/save_captured_photo.dart';

final photoInjection = GetIt.instance;

class PhotosInjectionContainer {
  Future<void> init() async {
    // Repositorio
    photoInjection.registerLazySingleton<PhotoRepository>(
      () => FirebasePhotoRepository(),
    );

    // Caso de uso
    photoInjection.registerLazySingleton<SaveCapturedPhoto>(
      () => SaveCapturedPhoto(photoInjection<PhotoRepository>()),
    );
  }
}
