import 'package:flutter/material.dart';
import 'package:yuppi_app/features/activities/presentation/pages/colors_level_screen.dart';

class ChooseObjectAreaPage extends StatelessWidget {
  const ChooseObjectAreaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F9FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4FA8F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Selecciona tu actividad',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Botón Casa
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ColorsLevelScreen(
                          title: 'Casa',
                          subType: 'inHouse',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCAF0F8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Image(
                          image: AssetImage(
                            'assets/images/actividades/casa.webp',
                          ),
                          height: 140,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Casa',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Botón Exterior
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ColorsLevelScreen(
                          title: 'Exterior',
                          subType: 'outHouse',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCAF0F8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Image(
                          image: AssetImage(
                            'assets/images/actividades/parque.webp',
                          ),
                          height: 140,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Exterior',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Botón de regreso
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 40,
                    color: Color(0xFF4FA8F6),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
