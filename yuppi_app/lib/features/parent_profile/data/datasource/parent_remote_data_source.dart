abstract class ParentRemoteDataSource {
  Future<void> updateParent({
    required String parentId,
    required Map<String, dynamic> updatedData,
  });
}
