import 'package:flutter/material.dart';
import 'package:yuppi_app/features/auth/dominio/entities/kid.dart';
import 'package:yuppi_app/features/auth/dominio/entities/parent.dart';
import 'package:yuppi_app/features/camera/domian/entities/exercise.dart';
import 'package:yuppi_app/features/camera/presentation/pages/camera_page.dart';
import 'package:yuppi_app/features/home/presentation/pages/child_home_page.dart';
import 'package:yuppi_app/providers/kid_provider.dart';
import 'package:yuppi_app/providers/parent_provider.dart';
import 'package:provider/provider.dart';
import 'package:yuppi_app/features/gemini/data/models/gemini_fact_model.dart';

class EvaluationErrorPage extends StatelessWidget {
  final Parent padre;
  final Kid kid;
  final Exercise exercise;
  final String labelPrefix;
  final GeminiFactModel geminiResponse;
  final int attempt;

  const EvaluationErrorPage({
    super.key,
    required this.padre,
    required this.kid,
    required this.exercise,
    required this.labelPrefix,
    required this.geminiResponse,
    required this.attempt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Texto principal arriba
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '¡Ups, te equivocaste...!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Icono de error
              const Icon(Icons.cancel, color: Colors.redAccent, size: 120),
              const SizedBox(height: 24),
              // Mensaje motivador
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '¡No pasa nada!\nIntenta otra vez',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón Cancelar
                  ElevatedButton(
                    onPressed: () {
                      final parentProvider = context.read<ParentProvider>();
                      final kidProvider = context.read<KidProvider>();

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder:
                              (_) => MultiProvider(
                                providers: [
                                  ChangeNotifierProvider.value(
                                    value: parentProvider,
                                  ),
                                  ChangeNotifierProvider.value(
                                    value: kidProvider,
                                  ),
                                ],
                                child: const ChildHomePage(),
                              ),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Botón Reintentar
                  ElevatedButton(
                    onPressed: () async {
                      // Lógica de navegación
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder:
                              (context) => CameraPage(
                                padre: padre,
                                kid: kid,
                                exercise: exercise,
                                labelPrefix: labelPrefix,
                                geminiResponse: geminiResponse,
                                attempt: attempt + 1,
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Reintentar',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
