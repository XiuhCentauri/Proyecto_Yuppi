import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyzedRecord {
  final String parentId;
  final String kidId;
  final String exerciseId;
  final String evaluatedObject;
  final List<String> labelsDetected;
  final bool isCorrect;
  final String photoId;
  final Duration timeElapsed;
  final String sourceType; // "photo" o "drawing"
  final String sourceSubType;
  final DateTime timestamp;
  final bool IsPhoto;

  AnalyzedRecord({
    required this.parentId,
    required this.kidId,
    required this.exerciseId,
    required this.evaluatedObject,
    required this.labelsDetected,
    required this.isCorrect,
    required this.photoId,
    required this.timeElapsed,
    required this.sourceType,
    required this.sourceSubType,
    required this.timestamp,
    required this.IsPhoto,
  });

  factory AnalyzedRecord.fromMap(Map<String, dynamic> map) {
    return AnalyzedRecord(
      parentId: map['parentId'] ?? '',
      kidId: map['kidId'] ?? '',
      exerciseId: map['exerciseId'] ?? '',
      evaluatedObject: map['evaluatedObject'] ?? '',
      labelsDetected: List<String>.from(map['labelsDetected'] ?? []),
      isCorrect: map['isCorrect'] ?? false,
      photoId: map['photoId'] ?? '',
      timeElapsed: Duration(milliseconds: map['timeElapsed'] ?? 0),
      sourceType: map['sourceType'] ?? '',
      sourceSubType: map['sourceSubType'] ?? '',
      timestamp: _parseTimestamp(map['timestamp']),
      IsPhoto: map['IsPhoto'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parentId': parentId,
      'kidId': kidId,
      'exerciseId': exerciseId,
      'evaluatedObject': evaluatedObject,
      'labelsDetected': labelsDetected,
      'isCorrect': isCorrect,
      'photoId': photoId,
      'timeElapsed': timeElapsed.inMinutes, // Guardamos como int
      'sourceType': sourceType,
      'sourceSubType': sourceSubType,
      'timestamp': timestamp,
      'IsPhoto': IsPhoto,
    };
  }

  static DateTime _parseTimestamp(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }
}
