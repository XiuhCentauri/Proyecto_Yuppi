import 'package:yuppi_app/features/kid_profile_edit/domain/repositories/kid_profile_repository.dart';

class UpdateKidProfile {
  final KidProfileRepository repository;

  UpdateKidProfile(this.repository);

  /// Actualiza el perfil del niño usando el ID y un mapa con los cambios.
  /// Retorna `true` si se guardó exitosamente, `false` si hubo error.
  Future<bool> call({
    required String idKid,
    required Map<String, dynamic> updatedData,
  }) async {
    return await repository.updateKidProfile(
      idKid: idKid,
      updatedData: updatedData,
    );
  }
}
