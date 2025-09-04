import 'package:get_it/get_it.dart';

import 'package:yuppi_app/features/score/data/scored_repository_impl.dart';
import 'package:yuppi_app/features/score/domain/repositories/scored_repository.dart';

import 'package:yuppi_app/features/score/domain/usecases/new_score_mark.dart';  // <— importa tu clase

final sl = GetIt.instance;

class ScoreInjection {
  Future<void> init() async {
    // 1) Repositorio
    sl.registerLazySingleton<ScoredRepository>(
      () => ScoredRepositoryImpl(),
    );


    // 3) Tu nueva clase de lógica de puntuación
    sl.registerLazySingleton<NewScoreMark>(
      () => NewScoreMark(repository: sl()),
    );
  }
}
