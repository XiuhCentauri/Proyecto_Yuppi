import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:yuppi_app/core/uuid_generator.dart';
import 'package:yuppi_app/features/photos/dominio/entities/captured_photo.dart';
import 'package:yuppi_app/features/photos/dominio/repositories/photo_repository.dart';
import 'dart:developer';

class FirebasePhotoRepository implements PhotoRepository {
  final FirebaseStorage storage;
  final FirebaseFirestore firestore;

  FirebasePhotoRepository({
    FirebaseStorage? storage,
    FirebaseFirestore? firestore,
  }) : storage = storage ?? FirebaseStorage.instance,
       firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<String> saveCapturedPhoto(CapturedPhoto photo) async {
    log("Entrando al repositorio...");
    final file = File(photo.url);
    final photoId = photo.id.isNotEmpty ? photo.id : generateUuid();
    final storagePath = 'photos/${photo.kidId}/$photoId.jpg';

    try {
      log('🟢 Subiendo archivo a: $storagePath');
      if (!file.existsSync()) {
        log('❌ El archivo temporal no existe: ${file.path}');
        throw Exception('Archivo no encontrado');
      }

      final ref = storage.ref().child(storagePath);
      final bytes = await file.readAsBytes();
      await ref.putData(bytes);

      final downloadUrl = await ref.getDownloadURL();
      log('✅ URL obtenida: $downloadUrl');

      final docRef = await firestore.collection('photos').add({
        'id': photoId,
        'parentId': photo.parentId,
        'kidId': photo.kidId,
        'url': downloadUrl,
        'date': photo.timestamp,
      });

      log('📦 Documento guardado en Firestore: ${docRef.id}');
      return photoId;
    } catch (e, s) {
      log('❌ Error al subir la imagen o guardar en Firestore: $e');
      log('📌 Stack trace: $s');
      rethrow;
    }
  }
}
