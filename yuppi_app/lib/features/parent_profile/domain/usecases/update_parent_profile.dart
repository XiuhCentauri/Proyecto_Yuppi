import 'package:yuppi_app/core/validators/parent_validator.dart';
import '../repositories/parent_profile_repository.dart';

class UpdateParentProfile {
  final ParentProfileRepository repository;
  final ParentValidator validator;

  UpdateParentProfile({required this.repository, required this.validator});

  Future<bool> call({
    required String parentId,
    required Map<String, dynamic> updatedData,
  }) async {
    if (updatedData.isEmpty) {
      throw ArgumentError('No se proporcionaron datos para actualizar');
    }

    // Validaciones de unicidad
    if (updatedData.containsKey('email')) {
      final exists = await validator.emailExists(
        updatedData['email'],
        excludeId: parentId,
      );
      if (exists) throw Exception('El correo ya está en uso');
    }

    if (updatedData.containsKey('user')) {
      final exists = await validator.usernameExists(
        updatedData['user'],
        excludeId: parentId,
      );
      if (exists) throw Exception('El nombre de usuario ya está en uso');
    }

    if (updatedData.containsKey('phoneNumber')) {
      final exists = await validator.phoneNumberExists(
        updatedData['phoneNumber'],
        excludeId: parentId,
      );
      if (exists) throw Exception('El número de teléfono ya está en uso');
    }

    // Si pasa todo, actualiza el perfil
    return await repository.updateParentProfile(
      parentId: parentId,
      updatedData: updatedData,
    );
  }
}
