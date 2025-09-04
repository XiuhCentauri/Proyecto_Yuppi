import 'dart:developer';
import 'package:yuppi_app/features/parent_profile/domain/repositories/parent_profile_repository.dart';
import 'package:yuppi_app/features/parent_profile/data/datasource/parent_remote_data_source.dart';

class ParentProfileRepositoryImpl implements ParentProfileRepository {
  final ParentRemoteDataSource remoteDataSource;

  ParentProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> updateParentProfile({
    required String parentId,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      await remoteDataSource.updateParent(
        parentId: parentId,
        updatedData: updatedData,
      );
      return true;
    } catch (e) {
      log("$e");
      return false;
    }
  }
}
