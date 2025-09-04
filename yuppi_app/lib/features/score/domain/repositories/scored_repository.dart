import 'package:yuppi_app/features/score/domain/entities/scored.dart';

abstract class ScoredRepository {
  Future<Scored> getScoredById(String idKid);
  Future<bool> updateScore(String idKid, Scored newScore);
  Future<bool> createScore(Scored _scored);
}
