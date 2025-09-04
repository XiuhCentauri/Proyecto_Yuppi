import 'package:get_it/get_it.dart';
import 'package:yuppi_app/features/kid_profile_edit/data/datasource/kid_remote_data_source.dart';

import "package:yuppi_app/features/kid_profile_edit/data/repositories/kid_profile_repository_imple.dart";
import 'package:yuppi_app/features/kid_profile_edit/data/datasource/kid_remote_data_source_Imple.dart';
import 'package:yuppi_app/features/kid_profile_edit/domain/repositories/kid_profile_repository.dart';
import 'package:yuppi_app/features/kid_profile_edit/domain/usecases/update_kid_profile.dart';

final kidProfileEditInjection = GetIt.instance;

class KidProfileEditInjection {
  static Future<void> init() async {
    // DataSource
    kidProfileEditInjection.registerLazySingleton<KidRemoteDataSource>(
      () => KidRemoteDataSourceImple(),
    );

    // Repositorio
    kidProfileEditInjection.registerLazySingleton<KidProfileRepository>(
      () => KidProfileRepositoryImple(
        remoteDataSource: kidProfileEditInjection(),
      ),
    );

    // Caso de uso
    kidProfileEditInjection.registerLazySingleton<UpdateKidProfile>(
      () => UpdateKidProfile(kidProfileEditInjection()),
    );
  }
}
