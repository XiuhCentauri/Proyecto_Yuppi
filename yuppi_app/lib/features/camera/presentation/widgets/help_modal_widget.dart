import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:yuppi_app/features/camera/domian/entities/exercise.dart';
import 'package:yuppi_app/features/text_to_speech/domain/usecases/synthesize_text_usecase.dart';
import 'package:yuppi_app/features/text_to_speech/injection/text_to_sppech_injetion.dart';
import 'package:yuppi_app/features/gemini/data/models/gemini_fact_model.dart';
import 'package:yuppi_app/features/camera/presentation/widgets/info_box_button.dart';

class HelpModalWidget extends StatefulWidget {
  final VoidCallback onClose;
  final Exercise exercise;
  final GeminiFactModel geminiResponse;
  final bool status;

  const HelpModalWidget({
    super.key,
    required this.onClose,
    required this.exercise,
    required this.geminiResponse,
    required this.status,
  });

  @override
  State<HelpModalWidget> createState() => _HelpModalWidgetState();
}

class _HelpModalWidgetState extends State<HelpModalWidget> {
  DateTime? _lastPlayTime;
  //log(widget.)

  Future<void> _playAudioOncePerSecond(String text) async {
    final now = DateTime.now();
    if (_lastPlayTime == null ||
        now.difference(_lastPlayTime!) > const Duration(seconds: 1)) {
      _lastPlayTime = now;

      try {
        // ✅ Limpiar emojis u otros caracteres invisibles si es necesario
        final cleanText = text.replaceAll(RegExp(r'[^\x00-\x7F]+'), '');

        final synthesizeText = sl<SynthesizeTextUseCase>();
        final response = await synthesizeText(cleanText);

        final audioBytes = base64Decode(response.audioContent);

        final AudioPlayer player = AudioPlayer();
        await player.play(BytesSource(audioBytes));
        log("🔊 Reproduciendo texto: $cleanText");
      } catch (e, s) {
        log('❌ Error reproduciendo audio: $e');
        log('📌 StackTrace: $s');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al reproducir el texto')),
          );
        }
      }
    } else {
      log("⏳ Espera para volver a reproducir");
    }
  }

  @override
  Widget build(BuildContext context) {
    log(widget.geminiResponse.textC);
    return Container(
      color: Colors.black54,
      child: Center(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: 300,
              height: 380,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE3E8FF),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.blueAccent, width: 4),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap:
                        () => _playAudioOncePerSecond(
                          widget.exercise.nameObjectSpa,
                        ),
                    child: Container(
                      width: 200,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black26, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.exercise.imagePath,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Text('Error'));
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (widget.status) ...[
                    InfoBoxButton(
                      title: "Dato curioso",
                      content: widget.geminiResponse.textC,
                      color: Colors.blue.shade100,
                      borderColor: Colors.blue,
                      onTap:
                          () => _playAudioOncePerSecond(
                            widget.geminiResponse.textC,
                          ),
                    ),
                    const SizedBox(height: 10),
                    InfoBoxButton(
                      title: "Pista",
                      content: widget.geminiResponse.textP,
                      color: Colors.blue.shade100,
                      borderColor: Colors.blue,
                      onTap:
                          () => _playAudioOncePerSecond(
                            widget.geminiResponse.textP,
                          ),
                    ),
                  ],

                  // InfoBoxButton(
                  //   title: "Pista",
                  //   content: widget.geminiResponse.textC,
                  //   color: Colors.blue.shade100,
                  //   borderColor: Colors.blue,
                  //   onTap:
                  //       () => _playAudioOncePerSecond(
                  //         widget.geminiResponse.textP,
                  //       ),
                  // ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: widget.onClose,
                child: const CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
