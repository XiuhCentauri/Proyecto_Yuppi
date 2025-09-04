import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuppi_app/providers/parent_provider.dart';
import 'package:yuppi_app/providers/kid_provider.dart';
import 'package:yuppi_app/features/home/presentation/pages/child_home_page.dart';
import 'package:yuppi_app/features/auth/dominio/entities/parent.dart';
import 'package:yuppi_app/features/auth/dominio/entities/kid.dart';
import 'package:yuppi_app/features/camera/domian/entities/exercise.dart';
import 'package:yuppi_app/features/camera/services/canera_injection.dart'
    as cameraInjection;
import 'package:yuppi_app/features/camera/domian/usecases/get_random_figure_color_exercise_usecase.dart';
import 'package:yuppi_app/features/camera/domian/usecases/get_RanExer_BySubType_UseCase.dart';
import 'package:yuppi_app/features/activities/presentation/widgets/activity_intro_widget.dart';

class EvaluationResultPage extends StatelessWidget {
  final Parent padre;
  final Kid kid;
  final Exercise exercise;
  final String labelPrefix;
  final int currentAttempt;

  const EvaluationResultPage({
    super.key,
    required this.padre,
    required this.kid,
    required this.exercise,
    required this.labelPrefix,
    required this.currentAttempt,
  });

  @override
  Widget build(BuildContext context) {
    final subtype = exercise.subType;
    int newCash = 10;
    if (subtype == "outHouse" || subtype == "inHouse") {
      newCash = 15;
    }

    //String cashsg = newCash.toString();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.stars, color: Colors.amber, size: 60),
              const SizedBox(height: 16),
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
                  '¡Actividad completada!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 120,
              ),
              const SizedBox(height: 24),

              // Recompensa visual: +10 monedas
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.lightBlue),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4FA8F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Recompensa:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      newCash.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.star, color: Colors.amber, size: 24),
                  ],
                ),
              ),

              // Botones Finalizar y Siguiente
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _goToHomePage(context);
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
                      'Finalizar',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      _goToActivityIntro(context, subtype);
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
                      'Siguiente',
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

  void _goToHomePage(BuildContext context) {
    final parentProvider = context.read<ParentProvider>();
    final kidProvider = context.read<KidProvider>();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder:
            (_) => MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: parentProvider),
                ChangeNotifierProvider.value(value: kidProvider),
              ],
              child: const ChildHomePage(),
            ),
      ),
      (route) => false,
    );
  }

  void _goToActivityIntro(BuildContext context, String subtype) async {
    final parentProvider = context.read<ParentProvider>();
    final kidProvider = context.read<KidProvider>();

    final exercise = await cameraInjection
        .sl<GetRandomExerciseBySubTypeUseCase>()
        .call(kidProvider.selectedKid!.id, subtype);

    if (exercise == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Se acabaron todos los juegos de esta categoría'),
            duration: Duration(seconds: 3),
          ),
        );

        await Future.delayed(const Duration(seconds: 3));
        _goToHomePage(context); // Llama a tu función personalizada
      }
      return;
    }
    String txtlabel = '';
    if (exercise.subType == 'vocales') {
      txtlabel = 'Identifica esta vocal: ' + exercise!.nameObjectSpa;
    } else if (exercise.subType == 'primary') {
      txtlabel = 'Identifica este número: ' + exercise!.nameObjectSpa;
    } else if (exercise.subType == 'inHouse' ||
        exercise.subType == 'outHouse') {
      txtlabel = 'Identifica este objeto: ' + exercise!.nameObjectSpa;
    }
    // Si hay ejercicio, navegar a la intro
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (_) => Scaffold(
              body: ActivityIntroWidget(
                padre: parentProvider.parent!,
                kid: kidProvider.selectedKid!,
                exercise: exercise,
                labelPrefix: txtlabel,
                onNext: () {},
              ),
            ),
      ),
    );
  }
}
