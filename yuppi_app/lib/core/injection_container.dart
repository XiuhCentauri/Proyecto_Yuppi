import 'package:yuppi_app/features/auth/dominio/usecases/login_parent.dart';
import 'package:yuppi_app/features/auth/dominio/usecases/register_kid.dart';

import '../core/servicios/firebase_service.dart';
import '../features/auth/dominio/repositories/auth_repository.dart';
import '../features/auth/dominio/usecases/register_parent.dart';

class InjectionContainer {
  static final InjectionContainer _instance = InjectionContainer._internal();

  factory InjectionContainer() => _instance;

  InjectionContainer._internal();

  late final AuthRepositoryImpl authRepository;
  late final RegisterParent registerParent;
  late final RegisterKid registerKid;
  late final LoginParent loginParent;
  Future<void> init() async {
    await FirebaseService().init();

    final firestore = FirebaseService().firestore;
    authRepository = AuthRepositoryImpl(firestore);
    registerParent = RegisterParent(authRepository);
    registerKid = RegisterKid(authRepository);
    loginParent = LoginParent(authRepository);
  }
}
