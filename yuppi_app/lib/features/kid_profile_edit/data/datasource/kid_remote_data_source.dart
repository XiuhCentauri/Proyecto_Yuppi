abstract class KidRemoteDataSource {
  Future<void> updateKid({
    required String idKid,
    required Map<String, dynamic> updateData,
  });
}
