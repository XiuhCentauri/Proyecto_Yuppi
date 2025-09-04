import 'package:get_it/get_it.dart';
import 'package:yuppi_app/features/parent_profile/data/datasource/parent_remote_data_source.dart';
import 'package:yuppi_app/features/parent_profile/data/datasource/remote_data_source_impl.dart';
import 'package:yuppi_app/features/parent_profile/data/repositories/parent_profile_repository_impl.dart';
import 'package:yuppi_app/features/parent_profile/domain/repositories/parent_profile_repository.dart';
import 'package:yuppi_app/features/parent_profile/domain/usecases/update_parent_profile.dart';
import 'package:yuppi_app/core/validators/firebase_parent_validator.dart';
import 'package:yuppi_app/core/validators/parent_validator.dart';

final profileInjection = GetIt.instance;

class ProfileInjectionContainer {
  Future<void> init() async {
    // Datasource
    profileInjection.registerLazySingleton<ParentRemoteDataSource>(
      () => ParentRemoteDataSourceImpl(),
    );

    // Validator (usa el singleton de FirebaseService internamente)
    profileInjection.registerLazySingleton<ParentValidator>(
      () => FirebaseParentValidator(),
    );

    // Repositorio
    profileInjection.registerLazySingleton<ParentProfileRepository>(
      () => ParentProfileRepositoryImpl(
        remoteDataSource: profileInjection<ParentRemoteDataSource>(),
      ),
    );

    // UseCase
    profileInjection.registerLazySingleton<UpdateParentProfile>(
      () => UpdateParentProfile(
        repository: profileInjection<ParentProfileRepository>(),
        validator: profileInjection<ParentValidator>(),
      ),
    );
  }
}
