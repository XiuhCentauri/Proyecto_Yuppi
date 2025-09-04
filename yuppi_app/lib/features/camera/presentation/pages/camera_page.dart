import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:yuppi_app/features/camera/domian/entities/exercise.dart';
import 'package:yuppi_app/features/camera/presentation/widgets/top_banner_widget.dart';
import 'package:yuppi_app/features/camera/presentation/widgets/bottom_buttons_widget.dart';
import 'package:yuppi_app/features/camera/presentation/widgets/help_modal_widget.dart';
import 'package:yuppi_app/features/camera/presentation/widgets/confirm_send_photo_modal.dart';
import 'package:yuppi_app/features/camera/presentation/widgets/confirm_draw_modal.dart';
import 'package:yuppi_app/features/auth/dominio/entities/kid.dart';
import 'package:yuppi_app/features/auth/dominio/entities/parent.dart';
import 'package:yuppi_app/features/photos/dominio/entities/captured_photo.dart';
import 'package:yuppi_app/features/photos/injection/photos_injection_container.dart';
import 'package:yuppi_app/features/photos/dominio/repositories/photo_repository.dart';
import 'package:yuppi_app/features/vision_analysis/injection/vision_analysis_injection.dart';
import 'package:yuppi_app/features/vision_analysis/domain/usecases/analyze_photo_case.dart';
import 'package:yuppi_app/features/vision_analysis/domain/usecases/analyze_save_case.dart';
import 'package:yuppi_app/features/vision_analysis/domain/entities/analyzed_photo.dart';
import 'package:yuppi_app/features/camera/presentation/widgets/show_captured_photo_widget.dart';
import 'package:yuppi_app/features/vision_analysis/domain/entities/analyzed_record.dart';
import 'package:yuppi_app/features/camera/presentation/widgets/exit_confirmation_modal_widget.dart';
import 'package:yuppi_app/features/vision_analysis/data/datasource/vision_api_data_source.dart';
import 'package:yuppi_app/features/camera/presentation/pages/evaluation_error_page.dart';
import 'package:yuppi_app/core/servicios/camera_manager.dart';
import 'package:yuppi_app/features/camera/presentation/pages/evaluation_fail_page.dart';
import 'package:yuppi_app/features/camera/presentation/pages/evaluation_result_page.dart';
import 'package:yuppi_app/features/score/domain/usecases/new_score_mark.dart';
import 'package:yuppi_app/features/score/injection/score_injection.dart'
    as scorelib;
import 'package:yuppi_app/features/gemini/data/models/gemini_fact_model.dart';
import 'package:yuppi_app/features/gemini/injection/gemini_injection_container.dart';
import 'package:yuppi_app/features/gemini/domain/usecases/GeminiService.dart';

class CameraPage extends StatefulWidget {
  final Parent padre;
  final Kid kid;
  final Exercise exercise;
  final String labelPrefix; // Texto que irá antes del nombre del ejercicio
  final int attempt;
  final GeminiFactModel geminiResponse;

  const CameraPage({
    super.key,
    required this.padre,
    required this.kid,
    required this.exercise,
    required this.labelPrefix,
    required this.geminiResponse,
    this.attempt = 1,
  });

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isCameraInitialized = false;
  XFile? _capturedImage;
  Exercise? _exercise;
  GeminiFactModel? _gemini;
  DateTime? _startTime;
  Duration? _elapsedTime;
  bool _isObject = false;
  bool _isDrawing = false;
  AnalyzedPhoto? analyzed;
  late int _currentAttempt;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _exercise = widget.exercise; // <<--- Cargar el ejercicio cuando inicia
    _startTime = DateTime.now();
    _gemini = widget.geminiResponse;
    _currentAttempt = widget.attempt;
    log(widget.geminiResponse.textC);
    log(widget.geminiResponse.textP);
    if (widget.exercise.subType == "outHouse" ||
        widget.exercise.subType == "inHouse") {
      _isObject = true;
    }
  }

  Future<void> _initializeCamera() async {
    // 🔥 Ya no inicialices otra vez
    if (CameraManager().controller != null &&
        CameraManager().controller!.value.isInitialized) {
      setState(() {
        _isCameraInitialized = true;
      });
    } else {
      log('❌ La cámara no está inicializada, posible error.');
      // Aquí podrías mostrar un error visual si quieres
    }
  }

  Future<void> _takePhoto() async {
    if (!_isCameraInitialized) {
      log('❌ Cámara no está lista.');
      return;
    }

    try {
      final controller = CameraManager().controller;
      final photo = await controller?.takePicture();
      if (photo != null) {
        log('✅ Foto capturada correctamente');
        setState(() {
          _capturedImage = photo;
        });

        // Pequeño delay de seguridad ANTES de abrir el modal
        await Future.delayed(const Duration(milliseconds: 200));

        if (!mounted) return; // Protege si el widget fue destruido

        _openConfirmSendPhotoModal(); // ahora sí abrir el modal
      } else {
        log('❌ No se pudo capturar foto.');
      }
    } catch (e) {
      log('❌ Error tomando foto: $e');
    }
  }

  // @override
  // void dispose() {
  //   _cameraService.dispose(); // sigue igual
  //   super.dispose();
  // }

  void _openHelpModal() {
    bool showHints = false;

    // Intento 2 siempre muestra pistas
    if (_currentAttempt >= 2) {
      showHints = true;
    }

    // En el primer intento, se debe esperar mínimo 30 segundos
    if (_currentAttempt == 1 && _startTime != null) {
      final duration = DateTime.now().difference(_startTime!);
      if (duration.inSeconds >= 30) {
        showHints = true;
      }
    }

    log("📌 Mostrar pistas: $showHints");

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return HelpModalWidget(
          onClose: () {
            Navigator.of(context).pop();
          },
          exercise: _exercise!,
          geminiResponse: _gemini!,
          status: showHints, // ✅ pasar el booleano calculado
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  void _showExitConfirmationModal() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ExitConfirmationModalWidget(
          onConfirm: () {
            Navigator.of(context).pop(); // Cierra el modal
            Navigator.of(context).pop();
          },
          onCancel: () {
            Navigator.of(context).pop(); // Solo cierra el modal
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  void _goToIncorrectPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => EvaluationErrorPage(
              padre: widget.padre,
              kid: widget.kid,
              labelPrefix: widget.labelPrefix,
              exercise: _exercise!,
              attempt: _currentAttempt,
              geminiResponse: _gemini!,
            ),
      ),
    );
  }

  void _goToSuccessPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => EvaluationResultPage(
              padre: widget.padre,
              kid: widget.kid,
              exercise: _exercise!,
              labelPrefix: widget.labelPrefix,
              currentAttempt: _currentAttempt,
            ),
      ),
    );
  }

  void _openConfirmSendPhotoModal() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ConfirmSendPhotoModal(
          onConfirm: () {
            log(_capturedImage.toString());
            Navigator.of(context).pop();
            Future.delayed(const Duration(milliseconds: 100), () {
              if (_startTime != null) {
                _elapsedTime = DateTime.now().difference(_startTime!);
              }
              _analyzePhoto();
            });
          },
          onCancel: () {
            Navigator.of(context).pop();
            setState(() {
              _capturedImage = null; // borrar foto si cancela
            });
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  AnalyzedRecord _buildAnalyzedRecord({
    required AnalyzedPhoto analyzedPhoto,
    required String photoId,
    required Duration timeElapsed,
    required String sourceType,
    required String sourceSubType,
    required bool IsPhoto,
  }) {
    return AnalyzedRecord(
      parentId: analyzedPhoto.capturedPhoto.parentId,
      kidId: analyzedPhoto.capturedPhoto.kidId,
      exerciseId: _exercise!.idExercise,
      evaluatedObject: _exercise!.nameObjectSpa,
      labelsDetected: analyzedPhoto.labels,
      isCorrect: analyzedPhoto.isCorrect,
      photoId: photoId,
      timeElapsed: timeElapsed,
      sourceType: sourceType,
      sourceSubType: sourceSubType,
      timestamp: DateTime.now(),
      IsPhoto: IsPhoto,
    );
  }

  void _openConfirmDrawModal() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ConfirmDrawModal(
          onConfirm: () {
            Navigator.of(context).pop();
            setState(() {
              _isDrawing = true;
            });
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  void _goToEvaluationFailPage(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const EvaluationFailPage()));
  }

  Future<void> _analyzePhoto() async {
    final parent = widget.padre;
    final kid = widget.kid;

    final bytes = await _capturedImage!.readAsBytes();
    final base64Image = base64Encode(bytes);

    final captured = CapturedPhoto(
      id: '',
      url: _capturedImage!.path,
      kidId: kid.id,
      parentId: parent.id,
      timestamp: DateTime.now(),
    );

    try {
      log("Intento hecho por el nino: ${_currentAttempt.toString()}");
      log("analizando...");

      if (_exercise!.detection == "labelDetection") {
        analyzed = await visionInjection<AnalyzePhotoUseCase>().call(
          photo: captured,
          expectedObject: _exercise!.nameObjectEng,
          expectedObjectA: _exercise!.nameObjectEngA,
          useBase64: true,
          base64Image: base64Image,
          featureType: VisionFeatureType.labelDetection,
        );
      } else {
        analyzed = await visionInjection<AnalyzePhotoUseCase>().call(
          photo: captured,
          expectedObject: _exercise!.nameObjectEng,
          expectedObjectA: _exercise!.nameObjectEngA,
          useBase64: true,
          base64Image: base64Image,
          featureType: VisionFeatureType.textDetection,
        );
      }
      log("ELemento a analizar ${analyzed!.evaluatedObject}");
      log("La Foto se analizo.....");
      log("El Resultado analizado es: ${analyzed!.isCorrect}");
      log('La Foto se analizo.....${analyzed!.labels}');

      final Duration timeElapsedToSave =
          _isDrawing ? Duration.zero : _elapsedTime!;

      final bool isPhoto = _isDrawing ? false : true;

      if (analyzed!.isCorrect) {
        // final idsavedPhoto = await photoInjection<PhotoRepository>()
        //     .saveCapturedPhoto(captured);

        final analyzedWithResult = _buildAnalyzedRecord(
          analyzedPhoto: analyzed!,
          photoId: "",
          timeElapsed: timeElapsedToSave,
          sourceType: _exercise!.type,
          sourceSubType: _exercise!.subType,
          IsPhoto: isPhoto,
        );

        await visionInjection<SaveAnalyzedPhotoUseCase>().call(
          analyzedWithResult,
        );
        if (widget.exercise.subType == "outHouse" ||
            widget.exercise.subType == "inHouse") {
          await scorelib.sl<NewScoreMark>().changeScoreWin(kid.id, 15);
        } else {
          await scorelib.sl<NewScoreMark>().changeScoreWin(kid.id, 10);
        }
        await geminiInjection<GeminiService>().saveDualFact(
          widget.geminiResponse,
        );
        _goToSuccessPage();

        log('⏱️ Tiempo que tardó: ${analyzedWithResult.timeElapsed} segundos');
      } else {
        final analyzedWithResult = _buildAnalyzedRecord(
          analyzedPhoto: analyzed!,
          photoId: '',
          timeElapsed: timeElapsedToSave,
          sourceType: _exercise!.type,
          sourceSubType: _exercise!.subType,
          IsPhoto: isPhoto,
        );

        await visionInjection<SaveAnalyzedPhotoUseCase>().call(
          analyzedWithResult,
        );
        await scorelib.sl<NewScoreMark>().changeScoreLoss(kid.id);
        if (_currentAttempt < 3) {
          _goToIncorrectPage();
        } else {
          _goToEvaluationFailPage(context);
        }

        log('⏱️ Tiempo que tardó: ${analyzedWithResult.timeElapsed} segundos');
      }
    } catch (e, s) {
      log('❌ Error analizando la foto: $e');
      log('📌 Stack trace: $s');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_exercise == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    // Calcular márgenes y espaciamientos relativos al ancho de la pantalla
    final horizontalMargin = screenWidth * 0.05; // 5% de margen horizontal
    final bottomActionAreaHeight =
        screenHeight * 0.15; // 15% de altura para la barra de acciones
    final bannerHeight = screenHeight * 0.07; // 7% de altura para el banner
    final bannerTopPadding =
        topPadding + screenHeight * 0.02; // Ajuste para el banner

    // Calcular el tamaño de los botones de acción inferiores
    final actionButtonSize = screenWidth * 0.18;

    return Scaffold(
      backgroundColor: const Color(0xFFE1F5FE),
      body: Stack(
        children: [
          // Vista de Cámara (Centrada y con márgenes redondeados adaptativos)
          Positioned(
            top: bannerTopPadding + bannerHeight + 16, // Espacio para el banner
            left: horizontalMargin,
            right: horizontalMargin,
            bottom:
                bottomActionAreaHeight +
                16, // Espacio para la barra de acciones
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.black12, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child:
                    _isCameraInitialized
                        ? (_capturedImage != null
                            ? ShowCapturedPhotoWidget(photo: _capturedImage!)
                            : AspectRatio(
                              aspectRatio:
                                  CameraManager().controller!.value.aspectRatio,
                              child: CameraPreview(CameraManager().controller!),
                            ))
                        : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),

          // Banner Superior (Flotante con fondo distintivo y tamaño adaptativo)
          Positioned(
            top: bannerTopPadding,
            left: horizontalMargin,
            right: horizontalMargin,
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFF4FC3F7),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      // Para que el texto se ajuste si es largo
                      child: Text(
                        '${widget.labelPrefix}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _showExitConfirmationModal,
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Barra de Acciones Inferior (Fija con botones flotantes circulares adaptativos)
          Positioned(
            left: 0,
            right: 0,
            bottom:
                screenHeight *
                0.04, // Un pequeño margen desde la parte inferior
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Material(
                    color: const Color(0xFFFFD54F),
                    shape: const CircleBorder(),
                    elevation: 4,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(actionButtonSize / 2),
                      onTap: _openHelpModal,
                      child: Padding(
                        padding: EdgeInsets.all(actionButtonSize * 0.18),
                        child: Icon(
                          Icons.question_mark_outlined,
                          size: actionButtonSize * 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: const Color(0xFF5C6BC0),
                    shape: const CircleBorder(),
                    elevation: 6,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(actionButtonSize / 2),
                      onTap: _takePhoto,
                      child: Padding(
                        padding: EdgeInsets.all(actionButtonSize * 0.25),
                        child: Icon(
                          Icons.camera_rounded,
                          size: actionButtonSize * 0.6,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  if (!_isObject) ...[
                    Material(
                      color: const Color(0xFF66BB6A),
                      shape: const CircleBorder(),
                      elevation: 4,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                          actionButtonSize / 2,
                        ),
                        onTap: _openConfirmDrawModal,
                        child: Padding(
                          padding: EdgeInsets.all(actionButtonSize * 0.18),
                          child: Icon(
                            Icons.edit_outlined,
                            size: actionButtonSize * 0.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
