import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yuppi_app/core/injection_container.dart';
import 'package:yuppi_app/core/servicios/hash_password.dart';
import 'package:yuppi_app/core/session/parent_session.dart';
import 'package:yuppi_app/features/auth/dominio/entities/parent.dart';
import 'package:yuppi_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:yuppi_app/features/clientMail/injection/email_injection.dart';
import 'package:yuppi_app/features/clientMail/dominio/usecases/send_registration_usecase.dart';

const List<String> estadosMexico = [
  'Aguascalientes',
  'Baja California',
  'Baja California Sur',
  'Campeche',
  'Chiapas',
  'Chihuahua',
  'Ciudad de México',
  'Coahuila',
  'Colima',
  'Durango',
  'Estado de México',
  'Guanajuato',
  'Guerrero',
  'Hidalgo',
  'Jalisco',
  'Michoacán',
  'Morelos',
  'Nayarit',
  'Nuevo León',
  'Oaxaca',
  'Puebla',
  'Querétaro',
  'Quintana Roo',
  'San Luis Potosí',
  'Sinaloa',
  'Sonora',
  'Tabasco',
  'Tamaulipas',
  'Tlaxcala',
  'Veracruz',
  'Yucatán',
  'Zacatecas',
];

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _estadoSeleccionado;
  bool _isLoading = false;
  bool _acceptedTerms = false;

  final RegExp _onlyLettersRegExp = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$");

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  String? _emailError;
  String? _usernameError;
  String? _phoneError;

  void _showMessage(String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      _showMessage('Debes aceptar los términos y condiciones.', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
      _emailError = null;
      _usernameError = null;
      _phoneError = null;
    });

    final parent = Parent(
      id: const Uuid().v4(),
      user: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      fullName: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      stateCountry: _estadoSeleccionado ?? '',
      passwordHash: hashPassword(_passwordController.text),
    );

    final registerUseCase = InjectionContainer().registerParent;
    final emailService = emailInjection<SendRegistrationUsecase>();

    try {
      await registerUseCase.call(
        parent: parent,
        passwordHash: hashPassword(_passwordController.text),
        state: 1,
      );
      _formKey.currentState?.reset();
      setState(() {
        _estadoSeleccionado = null;
        _acceptedTerms = false;
      });

      final ParentSession parentSession = await InjectionContainer().loginParent
          .call(email: parent.email, password: _passwordController.text);

      await emailService.call(parent);
      log("se envio el correo");
      _passwordController.clear();
      _confirmPasswordController.clear();
      _showMessage("✅ Cuenta creada exitosamente");

      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WelcomePage(parentSesion: parentSession),
        ),
      );
    } catch (e) {
      log("Excepcion: $e");

      final error = e.toString().toLowerCase();

      setState(() {
        if (error.contains('correo')) {
          _emailError = 'El correo electrónico ya está en uso';
        } else if (error.contains('usuario')) {
          _usernameError = 'El nombre de usuario ya está en uso';
        } else if (error.contains('celular ')) {
          _phoneError = 'El número de teléfono ya está registrado';
        }
      });

      _showMessage(_parseError(e.toString()), isError: true);
    }

    setState(() => _isLoading = false);

    if (!_formKey.currentState!.validate()) {
      setState(() {}); // Asegura que el error se renderice
      return;
    }
  }

  String _parseError(String error) {
    if (error.toLowerCase().contains("usuario")) {
      return "El nombre de usuario ya está en uso";
    }
    if (error.toLowerCase().contains("correo")) {
      return "El correo electrónico ya está en uso";
    }
    if (error.toLowerCase().contains("celular ") ||
        error.contains("celular ")) {
      return "El número de teléfono ya está registrado";
    }

    return "Ocurrió un error inesperado"; // fallback
  }

  void _mostrarSelectorEstados(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          builder:
              (_, controller) => Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Selecciona tu estado',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: estadosMexico.length,
                      itemBuilder: (_, index) {
                        final estado = estadosMexico[index];
                        return RadioListTile<String>(
                          title: Text(estado),
                          value: estado,
                          groupValue: _estadoSeleccionado,
                          onChanged: (value) {
                            setState(() => _estadoSeleccionado = value);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
        );
      },
    );
  }

  Widget _buildCampo(
    TextEditingController controller,
    String label,
    TextInputType tipo, {
    bool obscure = false,
  }) {
    bool isPassword = controller == _passwordController;
    bool isConfirmPassword = controller == _confirmPasswordController;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText:
            obscure
                ? (isPassword ? !_passwordVisible : !_confirmPasswordVisible)
                : false,
        keyboardType: tipo,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon:
              obscure
                  ? IconButton(
                    icon: Icon(
                      (isPassword ? _passwordVisible : _confirmPasswordVisible)
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color:
                          (isPassword
                                  ? _passwordVisible
                                  : _confirmPasswordVisible)
                              ? Colors.lightBlue
                              : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isPassword) {
                          _passwordVisible = !_passwordVisible;
                        } else if (isConfirmPassword) {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        }
                      });
                    },
                  )
                  : null,
        ),
        validator: (value) {
          if (controller == _emailController) {
            if (value == null || value.isEmpty) return 'Requerido';
            if (!RegExp(r"^[\w\-\.]+@([\w\-]+\.)+[\w]{2,4}").hasMatch(value))
              return 'Correo inválido';
          } else if (controller == _passwordController) {
            if (value == null || value.length < 8) return 'Mínimo 8 caracteres';
            if (!RegExp(
              r'^(?=.*[!@#\$%^&*(),.?":{}|<>-_])(?=.*[0-9])',
            ).hasMatch(value)) {
              return 'Incluye un número y símbolo';
            }
          } else if (controller == _confirmPasswordController) {
            if (value != _passwordController.text)
              return 'Las contraseñas no coinciden';
          } else if (controller == _phoneController) {
            if (value == null || value.isEmpty) return 'Requerido';
            if (!RegExp(r'^\+?[0-9]{10}$').hasMatch(value))
              return 'Teléfono inválido';
          } else if (controller == _nameController) {
            if (value == null || value.isEmpty) return 'Requerido';
            if (!_onlyLettersRegExp.hasMatch(value)) {
              return 'Solo letras y espacios';
            }
          } else {
            if (value == null || value.isEmpty) return 'Requerido';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEstadoSelector(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : () => _mostrarSelectorEstados(context),
      child: AbsorbPointer(
        child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Estado donde reside',
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
          controller: TextEditingController(
            text: _estadoSeleccionado ?? 'Seleccionar',
          ),
          validator:
              (_) =>
                  _estadoSeleccionado == null ? 'Selecciona un estado' : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          errorStyle: TextStyle(color: Colors.redAccent),
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.lightBlue, width: 2),
          ),
          labelStyle: const TextStyle(fontSize: 14),
        ),
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            const Text(
              "Crear Cuenta",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF008B8B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildCampo(
              _emailController,
              "Correo Electrónico",
              TextInputType.emailAddress,
            ),
            _buildCampo(_nameController, "Nombre completo", TextInputType.text),
            _buildCampo(
              _usernameController,
              "Nombre de usuario",
              TextInputType.text,
            ),
            _buildCampo(
              _passwordController,
              "Contraseña",
              TextInputType.visiblePassword,
              obscure: true,
            ),
            _buildCampo(
              _confirmPasswordController,
              "Confirmar contraseña",
              TextInputType.visiblePassword,
              obscure: true,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 4, bottom: 16),
              child: Text(
                "Mínimo de 8 caracteres, incluir al menos un carácter especial y un número",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            _buildCampo(
              _phoneController,
              "Número de teléfono",
              TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildEstadoSelector(context),
            const SizedBox(height: 20),
            CheckboxListTile(
              value: _acceptedTerms,
              onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: const Text(
                "Confirmo que soy un adulto y estoy autorizado para crear esta cuenta.",
                style: TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _isLoading ? null : _submitForm,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          "Crear cuenta",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
