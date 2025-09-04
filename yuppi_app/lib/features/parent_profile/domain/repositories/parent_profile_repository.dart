//import "package:yuppi_app/features/parent_profile/domain/entities/parent_profile.dart";

abstract class ParentProfileRepository {
  Future<bool> updateParentProfile({
    required String parentId,
    required Map<String, dynamic> updatedData,
  });
}
