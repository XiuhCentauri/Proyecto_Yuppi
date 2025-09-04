import 'package:get_it/get_it.dart';

import 'package:yuppi_app/features/clientMail/dominio/repositories/email_repository.dart';
import 'package:yuppi_app/features/clientMail/data/repositories/email_repository_impl.dart';
import 'package:yuppi_app/features/clientMail/dominio/usecases/send_registration_usecase.dart';
import 'package:yuppi_app/features/clientMail/dominio/usecases/sned_reward_usecase.dart';

final emailInjection = GetIt.instance;

class EmailInjectionContainer {
  Future<void> init() async {
    // Repositorio de envío de correos
    emailInjection.registerLazySingleton<EmailRepository>(
      () => SendGridEmailRepository(),
    );

    emailInjection.registerLazySingleton<SendRegistrationUsecase>(
      () => SendRegistrationUsecase(repository: SendGridEmailRepository()),
    );

    emailInjection.registerLazySingleton<SendRewardUsecase>(
      () => SendRewardUsecase(repository: SendGridEmailRepository()),
    );
  }
}
