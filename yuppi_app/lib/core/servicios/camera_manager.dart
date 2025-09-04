import 'package:camera/camera.dart';

class CameraManager {
  static final CameraManager _instance = CameraManager._internal();
  factory CameraManager() => _instance;
  CameraManager._internal();

  CameraController? _controller;
  bool _isInitialized = false;

  Future<void> initializeCamera(CameraLensDirection direction) async {
    if (_isInitialized) return; // 🔥 Ya está lista, no inicializar otra vez

    final cameras = await availableCameras();
    final selectedCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == direction,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await _controller!.initialize();
    _isInitialized = true;
  }

  CameraController? get controller => _controller;

  // Future<void> dispose() async {
  //   if (_isInitialized && _controller != null) {
  //     await _controller!.dispose();
  //     _isInitialized = false;
  //   }
  // }
}
