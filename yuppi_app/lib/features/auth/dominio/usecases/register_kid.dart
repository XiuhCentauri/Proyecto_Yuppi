import 'package:yuppi_app/features/auth/dominio/entities/kid.dart';

import '../repositories/auth_repository.dart';

class RegisterKid {
  final AuthRepositoryImpl repository;

  RegisterKid(this.repository);

  Future<void> call({required Kid kid}) async {
    await repository.registerKid(kid: kid);
  }
}
