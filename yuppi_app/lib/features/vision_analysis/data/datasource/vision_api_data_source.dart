import 'dart:convert';
import 'package:http/http.dart' as http;

enum VisionFeatureType { labelDetection, imageProperties, textDetection }

extension VisionFeatureTypeExtension on VisionFeatureType {
  String get value {
    switch (this) {
      case VisionFeatureType.labelDetection:
        return 'LABEL_DETECTION';
      case VisionFeatureType.imageProperties:
        return 'IMAGE_PROPERTIES';
      case VisionFeatureType.textDetection:
        return 'TEXT_DETECTION'; // Cambiado aquí para detectar texto
      default:
        return 'TEXT_DETECTION'; // Por defecto también detecta texto
    }
  }
}

class VisionApiDataSource {
  final String apiKey;

  VisionApiDataSource({required this.apiKey});

  // Análisis de imagen para texto en Base64
  Future<List<String>> analyzeImageTextFromBase64(
    String base64Image, {
    VisionFeatureType featureType = VisionFeatureType.textDetection,
  }) async {
    final url = Uri.parse(
        'https://vision.googleapis.com/v1/images:annotate?key=$apiKey');

    final Map<String, dynamic> requestPayload = {
      "requests": [
        {
          "image": {
            "content": base64Image, // Usamos el contenido base64 de la imagen
          },
          "features": [
            {
              "type": featureType.value, // Usamos el valor de textDetection
              "maxResults": 10,
            },
          ],
        },
      ],
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestPayload),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // Verificar si la respuesta contiene 'textAnnotations' y si no es null
      if (decoded['responses'] != null && decoded['responses'][0]['textAnnotations'] != null) {
        return _parseResponse(decoded, featureType);
      } else {
        return [];  // Devolver una lista vacía si no se encontraron textos
      }
    } else {
      throw Exception('Error al analizar la imagen: ${response.body}');
    }
  }

  // Análisis de imagen para detección de objetos en Base64
  Future<List<String>> analyzeImageObjectsFromBase64(
    String base64Image, {
    VisionFeatureType featureType = VisionFeatureType.labelDetection, // Usado para detectar objetos
  }) async {
    final url = Uri.parse(
        'https://vision.googleapis.com/v1/images:annotate?key=$apiKey');

    final Map<String, dynamic> requestPayload = {
      "requests": [
        {
          "image": {
            "content": base64Image, // Usamos el contenido base64 de la imagen
          },
          "features": [
            {
              "type": featureType.value, // Usamos el valor de labelDetection
              "maxResults": 10,
            },
          ],
        },
      ],
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestPayload),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return _parseResponse(decoded, featureType);
    } else {
      throw Exception('Error al analizar la imagen: ${response.body}');
    }
  }

  // Función para parsear la respuesta
  List<String> _parseResponse(Map<String, dynamic> decoded, VisionFeatureType featureType) {
    switch (featureType) {
      case VisionFeatureType.labelDetection:
        final List<dynamic> labels =
            decoded['responses']?[0]['labelAnnotations'] ?? [];  // Uso seguro de la clave
        return labels.map((label) => label['description'] as String).toList();

      case VisionFeatureType.textDetection:
        final List<dynamic> texts = decoded['responses']?[0]['textAnnotations'] ?? [];
        return texts.map((text) => text['description'] as String).toList();

      case VisionFeatureType.imageProperties:
        final dominantColors = decoded['responses']?[0]['imagePropertiesAnnotation']?['dominantColors']?['colors'] as List<dynamic>? ?? [];
        return dominantColors.map((color) {
          final rgb = color['color'];
          return "rgb(${rgb['red']}, ${rgb['green']}, ${rgb['blue']})";
        }).toList();
    }
    return [];
  }

}
