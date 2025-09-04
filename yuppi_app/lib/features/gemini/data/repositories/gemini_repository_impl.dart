import 'package:yuppi_app/features/gemini/data/datasource/gemini_remote_datasource.dart';
import 'package:yuppi_app/features/gemini/data/models/gemini_fact_model.dart';
import 'package:yuppi_app/features/gemini/domain/entities/gemini_response.dart';
import 'package:yuppi_app/features/gemini/domain/repositories/gemini_repository.dart';
import 'package:yuppi_app/core/servicios/firebase_service.dart';

class GeminiRepositoryImpl implements GeminiRepository {
  final GeminiRemoteDataSource remoteDataSource;
  final FirebaseService _firebaseService = FirebaseService();
  GeminiRepositoryImpl(this.remoteDataSource);

  @override
  Future<GeminiResponse> fetchGeneratedText(String prompt) async {
    final model = await remoteDataSource.getTextFromPrompt(prompt);
    return GeminiResponse(text: model.text);
  }

  @override
  Future<bool> saveRegistPyC(GeminiFactModel geminiFact) async {
    final snapshot = await _firebaseService.firestore
        .collection('fun_facts')
        .doc(geminiFact.idGR)
        .set(geminiFact.toMap());

    return true;
  }
}
