import 'package:yuppi_app/features/gemini/data/models/gemini_fact_model.dart';
import 'package:yuppi_app/features/gemini/domain/repositories/gemini_repository.dart';
import 'package:yuppi_app/features/camera/domian/entities/exercise.dart';
import 'package:yuppi_app/features/auth/dominio/entities/kid.dart';

class GeminiService {
  final GeminiRepository repository;
  GeminiService({required this.repository});

  /// Genera un dato curioso y una pista, los guarda en Firestore y los retorna
  Future<GeminiFactModel> generate({
    required String idGR,
    required Exercise exercise,
    required Kid kid,
  }) async {
    try {
      final DateTime now = DateTime.now();

      // Generar prompts dinámicamente
      final String promptCurious = _buildCuriousFactPrompt(exercise, kid);
      final String promptHint = _buildVisualHintPrompt(exercise, kid);

      // Obtener respuestas de Gemini
      final textC = (await repository.fetchGeneratedText(promptCurious)).text;
      final textP = (await repository.fetchGeneratedText(promptHint)).text;

      // Crear modelo
      final GeminiFactModel model = GeminiFactModel(
        idGR: idGR,
        element: exercise.nameObjectSpa,
        SubType: exercise.subType,
        textC: textC,
        textP: textP,
        createdAt: now,
      );

      // Guardar en Firestore
      //await repository.saveRegistPyC(model);

      return model;
    } catch (e) {
      throw Exception("Error al generar y guardar los datos: $e");
    }
  }

  Future<void> saveDualFact(GeminiFactModel _model) async {
    try {
      // Guardar en Firestore
      await repository.saveRegistPyC(_model);
    } catch (e) {
      throw Exception("Error al generar y guardar los datos: $e");
    }
  }

  // Prompt para dato curioso (máximo 90 caracteres)
  String _buildCuriousFactPrompt(Exercise element, Kid kid) {
    return '''
    Actúa como un asistente educativo para una app móvil infantil llamada "Yuppi". 
    Yuppi ayuda a niños pequeños de ${kid.age} años a aprender letras, números y objetos reconociéndolos con la cámara.

    Genera una frase divertida, muy corta y fácil de entender para describir cómo es y dónde se puede encontrar el objeto "${element.nameObjectSpa}". 

    Debe cumplir:
    - Solo una oración.
    - Máximo 90 caracteres.
    - Lenguaje muy simple y visual.
    - Sin palabras complicadas ni técnicas.
    - No uses introducción ni despedida.
    - Escribe solo la frase.
    - intenta que sean frases que sea facil para un tts pronunciar en español
    

    Ejemplo del estilo:
    > Redonda, rebotona y vive en el patio.
    Elemento: ${element.nameObjectSpa}
    ''';
  }

  // Prompt para pista visual
  String _buildVisualHintPrompt(Exercise element, Kid kid) {
    return '''
                  Actúa como un asistente para una app educativa llamada "Yuppi", donde los niños deben encontrar objetos o letras en su entorno. 
                  Genera una pista visual muy simple para ayudar a un niño de ${kid.age} años a reconocer el siguiente elemento: ${element.nameObjectSpa}.

                  Debe cumplir:
                  - Solo una frase.
                  - Máximo 90 caracteres.
                  - Lenguaje visual, simple y directo.
                  - Nada técnico ni complicado.
                  - No uses introducciones ni adornos.
                  - intenta que sean frases que sea facil para un tts pronunciar en español

                  Elemento: ${element.nameObjectSpa}
                  ''';
  }
}
