import '../entities/parent.dart';
import '../repositories/auth_repository.dart';

class RegisterParent {
  final AuthRepositoryImpl repository;

  RegisterParent(this.repository);

  Future<void> call({
    required Parent parent,
    required String passwordHash,
    required int state,
    bool emailVerified = false,
  }) async {
    if (await repository.emailExists(parent.email)) {
      throw Exception('El correo ya esta registrado');
    }

    if (await repository.usernameExists(parent.user)) {
      throw Exception('El nombre de usuario ya existe');
    }

    if (await repository.phoneNumberExists(parent.phoneNumber)) {
      throw Exception('El numero de celular ya existe');
    }

    await repository.registerParent(
      parent: parent,
      passwordHash: passwordHash,
      state: state,
      emailVerified: emailVerified,
    );
  }
}
