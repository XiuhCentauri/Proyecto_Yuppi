import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yuppi_app/core/injection_container.dart';
import 'package:yuppi_app/core/session/parent_session.dart';
import 'package:yuppi_app/features/auth/presentation/pages/initial_entry_page.dart';
import 'package:yuppi_app/features/auth/presentation/pages/profiles_page.dart';
import 'package:yuppi_app/providers/parent_provider.dart';
import 'package:provider/provider.dart';

class LoginParentForm extends StatefulWidget {
  const LoginParentForm({super.key});

  @override
  State<LoginParentForm> createState() => _LoginParentFormState();
}

class _LoginParentFormState extends State<LoginParentForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _showLoadingMessage = false;

  String? _errorText;
  String? _emailErrorText;
  String? _passwordErrorText;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _login() async {
    setState(() {
      _errorText = null;
      _isLoading = true;
      _showLoadingMessage = true;
      _emailErrorText = null;
      _passwordErrorText = null;
    });

    await Future.delayed(const Duration(seconds: 1));

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorText = "Todos los campos son obligatorios";
        _isLoading = false;
        _showLoadingMessage = false;
      });
      return;
    }

    try {
      final ParentSession session = await InjectionContainer().loginParent.call(
        email: email,
        password: password,
      );

      context.read<ParentProvider>().setParent(session.parent);

      setState(() => _showLoadingMessage = false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ProfilesPage(parentSession: session)),
      );
    } catch (e) {
      debugPrint("❌ Login error: $e");
      setState(() {
        _showLoadingMessage = false;
        final errorMsg = e.toString().toLowerCase();
        if (errorMsg.contains("correo") || errorMsg.contains("usuario")) {
          _emailErrorText = "Correo o usuario no registrado";
        } else if (errorMsg.contains("contraseña")) {
          _passwordErrorText = "Contraseña incorrecta";
        } else {
          _errorText = "Ocurrió un error inesperado";
        }
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      labelStyle: GoogleFonts.poppins(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const SizedBox(height: 32),
            Text(
              "Inicio Sesión",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                backgroundColor: const Color(0xFFCCF1F6),
              ),
            ),
            const SizedBox(height: 40),

            // Campo de correo
            TextFormField(
              controller: _emailController,
              decoration: _inputDecoration(
                "Nombre de usuario o Correo Electrónico ",
              ).copyWith(errorText: _emailErrorText),
            ),
            const SizedBox(height: 24),

            // Campo de contraseña
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: _inputDecoration("Contraseña ").copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
                errorText: _passwordErrorText,
              ),
            ),
            const SizedBox(height: 20),

            if (_errorText != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _errorText!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Botón continuar
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          "Continuar",
                          style: TextStyle(fontSize: 18),
                        ),
              ),
            ),
            const SizedBox(height: 24),

            // Botón volver
            TextButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const InitialEntryPage()),
                );
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text("Volver"),
              style: TextButton.styleFrom(
                textStyle: GoogleFonts.poppins(fontSize: 16),
              ),
            ),
          ],
        ),

        // Overlay "Iniciando sesión..."
        if (_showLoadingMessage)
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 8),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Text(
              "Iniciando sesión...",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
      ],
    );
  }
}
