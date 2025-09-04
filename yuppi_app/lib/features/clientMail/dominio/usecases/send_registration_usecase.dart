import 'package:yuppi_app/features/auth/dominio/entities/parent.dart';
import 'package:yuppi_app/features/clientMail/dominio/repositories/email_repository.dart';

class SendRegistrationUsecase {
  final EmailRepository repository;

  SendRegistrationUsecase({required this.repository});

  Future<bool> call(Parent parent) async {
    await repository.sendRegistrationEmail(
      email: parent.email,
      name: parent.fullName,
    );

    return true;
  }
}
