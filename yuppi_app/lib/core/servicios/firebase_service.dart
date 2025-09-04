import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;

  FirebaseService._internal();

  bool _initialized = false;

  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;

  /// Llama esto al inicio de la app
  Future<void> init() async {
    if (_initialized) return;

    await Firebase.initializeApp();
    firestore = FirebaseFirestore.instance;
    storage = FirebaseStorage.instance;

    _initialized = true;
  }
}
