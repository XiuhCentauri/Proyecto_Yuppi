import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';
import 'dart:typed_data';

//import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:yuppi_app/features/camera/presentation/pages/camera_page.dart';
import 'package:yuppi_app/features/auth/dominio/entities/parent.dart';
import 'package:yuppi_app/features/auth/dominio/entities/kid.dart';
import 'package:yuppi_app/features/camera/domian/entities/exercise.dart';
import 'package:yuppi_app/features/text_to_speech/domain/usecases/synthesize_text_usecase.dart';
import 'package:yuppi_app/features/text_to_speech/injection/text_to_sppech_injetion.dart';
import 'package:yuppi_app/features/gemini/data/models/gemini_fact_model.dart';
import 'package:yuppi_app/features/gemini/injection/gemini_injection_container.dart';
import 'package:yuppi_app/features/gemini/domain/usecases/GeminiService.dart';
import 'package:yuppi_app/core/uuid_generator.dart';

class ActivityIntroWidget extends StatefulWidget {
  final VoidCallback onNext;
  final Parent padre;
  final Kid kid;
  final Exercise exercise;
  final String labelPrefix;

  const ActivityIntroWidget({
    super.key,
    required this.onNext,
    required this.padre,
    required this.kid,
    required this.exercise,
    required this.labelPrefix,
  });

  @override
  State<ActivityIntroWidget> createState() => _ActivityIntroWidgetState();
}

class _ActivityIntroWidgetState extends State<ActivityIntroWidget> {
  final AudioPlayer _player = AudioPlayer();
  Uint8List? _cachedAudio; // <- Aquí guardas el audio ya decodificado
  DateTime? _lastPlayTime;
  GeminiFactModel? geminiResponse;
  bool _isLoadingGemini = true;
  @override
  void initState() {
    super.initState();
    _prepareCyC();
    _prepareAudio(widget.labelPrefix);
  }

  Future<void> _prepareAudio(String text) async {
    try {
      final synthesizeText = sl<SynthesizeTextUseCase>();
      final response = await synthesizeText(text);
      _cachedAudio = base64Decode(response.audioContent);

      await _player.play(BytesSource(_cachedAudio!));
    } catch (e, s) {
      debugPrint('❌ Error reproduciendo audio: $e');
      debugPrint('📌 StackTrace: $s');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al reproducir el audio')),
        );
      }
    }
  }

  Future<void> _prepareCyC() async {
    geminiResponse = await geminiInjection<GeminiService>().generate(
      exercise: widget.exercise,
      kid: widget.kid,
      idGR: generateUuid(),
    );

    setState(() {
      _isLoadingGemini = false;
    });
  }

  @override
  void dispose() {
    _player.dispose(); // 🔥 libera el reproductor
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage = widget.exercise.imagePath.startsWith('http');
    final media = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 💬 Instrucción con fondo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              widget.labelPrefix,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          // 🖼 Imagen tocable
          GestureDetector(
            onTap: () {
              final now = DateTime.now();
              if (_lastPlayTime == null ||
                  now.difference(_lastPlayTime!) > const Duration(seconds: 1)) {
                _lastPlayTime = now;
                _prepareAudio(widget.exercise.nameObjectSpa);
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(32),
              ),
              padding: const EdgeInsets.all(24),
              child:
                  isNetworkImage
                      ? Image.network(
                        widget.exercise.imagePath,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (_, __, ___) => const Center(
                              child: Text("Imagen no disponible"),
                            ),
                      )
                      : Image.asset(
                        widget.exercise.imagePath,
                        fit: BoxFit.contain,
                      ),
            ),
          ),

          // ✅ Botón más suave y legible
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _isLoadingGemini
                      ? null // 🔒 Desactiva el botón si aún no está listo
                      : () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => CameraPage(
                                  padre: widget.padre,
                                  kid: widget.kid,
                                  exercise: widget.exercise,
                                  labelPrefix: widget.labelPrefix,
                                  geminiResponse: geminiResponse!,
                                  attempt: 1,
                                ),
                          ),
                        );
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade400,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  _isLoadingGemini
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : const Text(
                        "Siguiente",
                        style: TextStyle(color: Colors.white),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
