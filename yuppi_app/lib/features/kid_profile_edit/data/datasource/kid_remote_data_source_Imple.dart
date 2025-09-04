import 'package:yuppi_app/features/kid_profile_edit/data/datasource/kid_remote_data_source.dart';
import 'package:yuppi_app/core/servicios/firebase_service.dart';

class KidRemoteDataSourceImple implements KidRemoteDataSource {
  final _firestore = FirebaseService().firestore;

  @override
  Future<void> updateKid({
    required String idKid,
    required Map<String, dynamic> updateData,
  }) async {
    await _firestore.collection('kids').doc(idKid).update(updateData);
  }
}
