// welcome_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profiles_page.dart';
//import '../../dominio/entities/parent.dart';
import 'package:yuppi_app/core/session/parent_session.dart';

class WelcomePage extends StatelessWidget {
  final ParentSession parentSesion;

  const WelcomePage({super.key, required this.parentSesion});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Contenido principal
          Column(
            children: [
              const SizedBox(height: 70),
              // 🔷 Contenedor del título con otra fuente
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 8, 120, 173),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Yuppi",
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 8, 7),
                  ),
                ),
              ),

              Text(
                "Sesión: ${parentSesion.parent.user}", // <- puedes cambiar a .email si prefieres
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 30),

              // 🔷 Mensaje más arriba (alrededor del 1/3 superior de la pantalla)
              SizedBox(
                height: size.height * 0.55,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        '¡Tu cuenta de papá/mamá se creó con éxito en Yupi!\nAhora podrás gestionar los perfiles, actividades y progreso de tu o tus pequeños. ¡Bienvenido a la familia Yupi!',
                        style: TextStyle(fontSize: 19),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 🔷 Imagen puede sobresalir (abajo izquierda)
          Positioned(
            bottom: -20,
            left: -20,
            child: Image.asset('assets/images/Robot1.png', height: 330),
          ),

          // 🔷 Flecha (abajo derecha)
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfilesPage(parentSession: parentSesion),
                  ),
                );
              },
              child: const Icon(
                Icons.arrow_forward,
                size: 50,
                color: Colors.lightBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
