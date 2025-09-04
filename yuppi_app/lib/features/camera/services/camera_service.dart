import 'package:camera/camera.dart';

class CameraService {
  CameraController? _controller;
  late List<CameraDescription> _availableCameras;
  bool isDisposing = false; // 🔥 Agregado

  /// Inicializa la cámara según la dirección deseada (por defecto: trasera).
  Future<void> initializeCamera({
    CameraLensDirection direction = CameraLensDirection.back,
  }) async {
    _availableCameras = await availableCameras();

    final selectedCamera = _availableCameras.firstWhere(
      (camera) => camera.lensDirection == direction,
      orElse: () => _availableCameras.first,
    );

    _controller = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await _controller!.initialize();
  }

  /// Devuelve el controlador para usarlo en el preview.
  CameraController? get controller => _controller;

  /// Toma una foto y devuelve el archivo resultante.
  Future<XFile?> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return null;
    if (_controller!.value.isTakingPicture) return null;

    try {
      return await _controller!.takePicture();
    } catch (_) {
      return null;
    }
  }

  /// Libera recursos de la cámara.
  Future<void> dispose() async {
    if (_controller != null) {
      isDisposing = true; // 🔥 Marcar que está liberando
      await _controller!.dispose();
      isDisposing = false; // 🔥 Listo, ya liberado
      _controller = null;
    }
  }
}
