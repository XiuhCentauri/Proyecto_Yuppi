abstract class KidProfileRepository {
  Future<bool> updateKidProfile({
    required String idKid,
    required Map<String, dynamic> updatedData,
  });
}
