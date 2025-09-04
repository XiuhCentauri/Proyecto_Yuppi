import 'package:yuppi_app/features/photos/dominio/entities/captured_photo.dart';

class AnalyzedPhoto {
  final CapturedPhoto capturedPhoto;
  final List<String> labels;
  final bool isCorrect;
  final String evaluatedObject;

  AnalyzedPhoto({
    required this.capturedPhoto,
    required this.labels,
    required this.isCorrect,
    required this.evaluatedObject,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': capturedPhoto.id,
      'url': capturedPhoto.url,
      'kidId': capturedPhoto.kidId,
      'parentId': capturedPhoto.parentId,
      'timestamp': capturedPhoto.timestamp.toIso8601String(),
      'labels': labels,
      'isCorrect': isCorrect,
      'evaluatedObject': evaluatedObject,
    };
  }

  factory AnalyzedPhoto.fromMap(Map<String, dynamic> map) {
    return AnalyzedPhoto(
      capturedPhoto: CapturedPhoto(
        id: map['id'],
        url: map['url'],
        kidId: map['kidId'],
        parentId: map['parentId'],
        timestamp: DateTime.parse(map['timestamp']),
      ),
      labels: List<String>.from(map['labels']),
      isCorrect: map['isCorrect'],
      evaluatedObject: map['evaluatedObject'],
    );
  }
}
