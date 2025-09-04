import 'package:flutter/material.dart';
import 'package:yuppi_app/features/home/presentation/pages/child_home_page.dart';
import 'package:yuppi_app/providers/kid_provider.dart';
import 'package:yuppi_app/providers/parent_provider.dart';
import 'package:provider/provider.dart';

class EvaluationFailPage extends StatelessWidget {
  const EvaluationFailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Mensaje de error arriba
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
              // Icono grande
              const Icon(Icons.cancel, color: Colors.redAccent, size: 120),
              const SizedBox(height: 24),
              // Mensaje motivador
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '¡Por ahora hacemos\nuna pausa, pero podrás\nseguir después!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
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
                              ChangeNotifierProvider.value(value: kidProvider),
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
                    horizontal: 32,
                    vertical: 14,
                  ),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
