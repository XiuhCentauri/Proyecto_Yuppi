import 'package:yuppi_app/features/kid_profile_edit/domain/repositories/kid_profile_repository.dart';
import 'package:yuppi_app/features/kid_profile_edit/data/datasource/kid_remote_data_source.dart';
import 'dart:developer';

class KidProfileRepositoryImple implements KidProfileRepository {
  final KidRemoteDataSource remoteDataSource;

  KidProfileRepositoryImple({required this.remoteDataSource});

  @override
  Future<bool> updateKidProfile({
    required String idKid,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      await remoteDataSource.updateKid(idKid: idKid, updateData: updatedData);
      return true;
    } catch (e) {
      log("$e");
      return false;
    }
  }
}
