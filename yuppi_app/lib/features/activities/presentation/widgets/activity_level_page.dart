import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yuppi_app/features/camera/domian/entities/exercise.dart';

import 'package:yuppi_app/features/text_to_speech/domain/usecases/synthesize_text_usecase.dart';
import 'package:yuppi_app/features/text_to_speech/injection/text_to_sppech_injetion.dart';
import 'package:audioplayers/audioplayers.dart';

class ActivityLevelPage extends StatefulWidget {
  final String title;
  final int correctCount;
  final List<Exercise> listExercises;
  final int totalActivities;
  final String subType;
  final VoidCallback onAddPressed;
  final VoidCallback onBackPressed;

  const ActivityLevelPage({
    super.key,
    required this.title,
    required this.correctCount,
    required this.totalActivities,
    required this.onAddPressed,
    required this.onBackPressed,
    required this.subType,
    required this.listExercises,
  });

  @override
  State<ActivityLevelPage> createState() => _ActivityLevelPageState();
}

class _ActivityLevelPageState extends State<ActivityLevelPage> {
  DateTime? _lastPlayTime;

  Color getTextColor() {
    if (widget.correctCount >= 3) return Colors.green;
    if (widget.correctCount > 0) return Colors.red;
    return Colors.blue;
  }

  Future<void> _playAudioOncePerSecond(String text) async {
    final now = DateTime.now();
    if (_lastPlayTime == null ||
        now.difference(_lastPlayTime!) > const Duration(milliseconds: 1500)) {
      _lastPlayTime = now;

      try {
        final cleanText = text.replaceAll(RegExp(r'[^\x00-\x7F]+'), '');

        final synthesizeText = sl<SynthesizeTextUseCase>();
        final response = await synthesizeText(cleanText);

        final audioBytes = base64Decode(response.audioContent);
        final AudioPlayer player = AudioPlayer();
        await player.play(BytesSource(audioBytes));

        log("🔊 Reproduciendo: $cleanText");
      } catch (e, s) {
        log('❌ Error al reproducir TTS: $e');
        log('📌 Stack: $s');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al reproducir el texto')),
          );
        }
      }
    } else {
      log("⏳ Espera antes de reproducir otra vez");
    }
  }

  @override
  //@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // 🔹 Contenido scrollable
            CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.lightBlue[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${widget.correctCount}/${widget.totalActivities}",
                            style: TextStyle(
                              color: getTextColor(),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Grid
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 80,
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (widget.correctCount < widget.totalActivities &&
                            index == widget.listExercises.length) {
                          return GestureDetector(
                            onTap: widget.onAddPressed,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                border: Border.all(
                                  color: Colors.cyan,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  size: 36,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          );
                        }

                        final exercise = widget.listExercises[index];
                        return buildExerciseCard(exercise);
                      },
                      childCount:
                          widget.listExercises.length +
                          (widget.correctCount < widget.totalActivities
                              ? 1
                              : 0),
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1,
                        ),
                  ),
                ),
              ],
            ),

            // 🔽 Flecha siempre fija
            Positioned(
              bottom: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.blue,
                  size: 32,
                ),
                onPressed: widget.onBackPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExerciseCard(Exercise exercise) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  Container(
                    width: double.infinity,
                    height: constraints.maxHeight * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.cyan, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: TextButton(
                        onPressed:
                            () => _playAudioOncePerSecond(
                              exercise.nameObjectSpa ?? '',
                            ),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Image.network(
                          exercise.imagePath ?? '',
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.indigo[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FittedBox(
                  child: Text(
                    exercise.nameObjectSpa ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
