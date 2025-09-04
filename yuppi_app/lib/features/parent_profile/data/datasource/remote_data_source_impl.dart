import 'package:yuppi_app/core/servicios/firebase_service.dart';
import 'parent_remote_data_source.dart';

class ParentRemoteDataSourceImpl implements ParentRemoteDataSource {
  final _firestore = FirebaseService().firestore;

  @override
  Future<void> updateParent({
    required String parentId,
    required Map<String, dynamic> updatedData,
  }) async {
    await _firestore.collection('parents').doc(parentId).update(updatedData);
  }
}
