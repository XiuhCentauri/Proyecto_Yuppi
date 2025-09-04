import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yuppi_app/features/auth/presentation/pages/register_parent_page.dart';
import 'package:yuppi_app/features/auth/presentation/pages/login_parent_page.dart';

class InitialEntryContent extends StatelessWidget {
  const InitialEntryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Bienvenid@s',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        Image.asset(
          'assets/images/Robot1.png',
          width: 180,
        ),
        const SizedBox(height: 40),
        _customButton(
          context,
          label: 'Crear cuenta',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterParentPage()),
            );
          },
        ),
        const SizedBox(height: 20),
        _customButton(
          context,
          label: 'Iniciar Sesión',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginParentPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _customButton(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
