import '../../../../core/session/parent_session.dart';
import '../repositories/auth_repository.dart';
import 'package:yuppi_app/core/servicios/hash_password.dart';
import 'package:yuppi_app/features/auth/data/models/parent_user.dart';

class LoginParent {
  final AuthRepository repository;

  LoginParent(this.repository);

  Future<ParentSession> call({
    required String email,
    required String password,
  }) async {
    ParentUser? userData;
    if (RegExp(r"^[\w\-\.]+@([\w\-]+\.)+[\w]{2,4}").hasMatch(email)) {
      userData = await repository.getParentByEmail(email);
    } else {
      userData = await repository.getParentByUser(email);
    }

    if (userData == null) {
      throw Exception('Nombre de usuario o correo electrónico no registrado');
    }

    final hashed = hashPassword(password);

    if (userData.passwordHash != hashed) {
      throw Exception('Contraseña incorrecta');
    }

    final parent = userData.toEntity();

    return await ParentSession.create(parent);
  }
}
