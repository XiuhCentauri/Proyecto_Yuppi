import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yuppi_app/core/servicios/hash_password.dart';
import 'package:provider/provider.dart';
import 'package:yuppi_app/providers/parent_provider.dart';
import 'package:yuppi_app/features/parent_profile/injection/profile_injection.dart';
import 'package:yuppi_app/features/parent_profile/domain/usecases/update_parent_profile.dart';

class EditParentProfilePage extends StatefulWidget {
  const EditParentProfilePage({super.key});

  @override
  State<EditParentProfilePage> createState() => _EditParentProfilePageState();
}

class _EditParentProfilePageState extends State<EditParentProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  TextEditingController? _passwordController;
  TextEditingController? _confirmPasswordController;
  late TextEditingController _phoneController;
  late String selectedState;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isSaving = false;
  bool hasChanges = false;

  String? emailError;
  String? userError;
  String? phoneError;

  @override
  void initState() {
    super.initState();
    final parent = Provider.of<ParentProvider>(context, listen: false).parent!;
    _emailController = TextEditingController(text: parent.email);
    _nameController = TextEditingController(text: parent.fullName);
    _usernameController = TextEditingController(text: parent.user);
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _phoneController = TextEditingController(text: parent.phoneNumber);
    selectedState = parent.stateCountry;

    for (final controller in [
      _emailController,
      _nameController,
      _usernameController,
      _passwordController,
      _confirmPasswordController,
      _phoneController,
    ]) {
      controller!.addListener(() => _checkForChanges());
    }

    _phoneController.addListener(() {
      if (phoneError != null) {
        setState(() => phoneError = null);
      }
      _checkForChanges();
    });

    _emailController.addListener(() {
      if (emailError != null) {
        setState(() => emailError = null);
      }
      _checkForChanges();
    });

    _usernameController.addListener(() {
      if (userError != null) {
        setState(() => userError = null);
      }
      _checkForChanges();
    });
  }

  void _checkForChanges() {
    final parent = context.read<ParentProvider>().parent!;
    final rawPassword = _passwordController?.text.trim();
    final hasNewPassword = rawPassword != null && rawPassword.isNotEmpty;

    final bool changed =
        _emailController.text.trim() != parent.email ||
        _nameController.text.trim() != parent.fullName ||
        _usernameController.text.trim() != parent.user ||
        _phoneController.text.trim() != parent.phoneNumber ||
        selectedState != parent.stateCountry ||
        hasNewPassword;

    if (changed != hasChanges) {
      setState(() => hasChanges = changed);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController?.dispose();
    _confirmPasswordController?.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _hasValidationErrors() {
    final validations = [
      _validateField(_emailController.text, _emailController),
      _validateField(_nameController.text, _nameController),
      _validateField(_usernameController.text, _usernameController),
      _validateField(_passwordController?.text ?? '', _passwordController!),
      _validateField(
        _confirmPasswordController?.text ?? '',
        _confirmPasswordController!,
      ),
      _validateField(_phoneController.text, _phoneController),
    ];

    setState(() {
      emailError = validations[0];
      userError = validations[2];
      phoneError = validations[5];
    });

    // Si alguna validación devuelve un mensaje, hay error
    return validations.any((result) => result != null);
  }

  String? _validateField(String? value, TextEditingController controller) {
    final _onlyLettersRegExp = RegExp(
      r"^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$",
      unicode: true,
    );
    final parent = context.read<ParentProvider>().parent!;

    if (controller == _emailController) {
      if (emailError != null) return emailError;
      if (value == null || value.isEmpty || value != parent.email) {
        if (!RegExp(
          r"^[\w\-\.]+@([\w\-]+\.)+[\w]{2,4}$",
        ).hasMatch(value ?? '')) {
          return 'Correo inválido';
        }
      }
    } else if (controller == _usernameController && userError != null) {
      return userError;
    } else if (controller == _passwordController) {
      if (value != null && value.isNotEmpty) {
        if (value.length < 8) return 'Mínimo 8 caracteres';
        if (!RegExp(
          r'^(?=.*[!@#\\\\$%^&*(),.?":{}|<>\-_])(?=.*[0-9])',
        ).hasMatch(value)) {
          return 'Incluye un número y símbolo';
        }
      }
    } else if (controller == _confirmPasswordController) {
      if ((_passwordController?.text ?? '').isNotEmpty &&
          value != _passwordController?.text) {
        return 'Las contraseñas no coinciden';
      }
    } else if (controller == _phoneController) {
      final cleanedValue = value?.trim() ?? '';
      if (cleanedValue != parent.phoneNumber) {
        if (!RegExp(r'^[0-9]{10}$').hasMatch(cleanedValue)) {
          return 'Teléfono inválido';
        }
        if (phoneError != null) return phoneError;
      }
    } else if (controller == _nameController) {
      if (value != null && value != parent.fullName) {
        if (!_onlyLettersRegExp.hasMatch(value)) {
          return 'Solo letras y espacios';
        }
      }
    }

    return null;
  }

  void _saveChanges() async {
    if (_hasValidationErrors()) return;

    setState(() {
      isSaving = true;
      emailError = null;
      userError = null;
      phoneError = null;
    });

    final parent = context.read<ParentProvider>().parent!;
    final rawPassword = _passwordController?.text.trim();
    final passwordHash =
        (rawPassword != null && rawPassword.isNotEmpty)
            ? hashPassword(rawPassword)
            : parent.passwordHash;

    final updatedParent = parent.copyWith(
      email: _emailController.text.trim(),
      fullName: _nameController.text.trim(),
      user: _usernameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      passwordHash: passwordHash,
      stateCountry: selectedState,
    );

    try {
      final updateParentProfile = profileInjection<UpdateParentProfile>();
      await updateParentProfile(
        parentId: parent.id,
        updatedData: updatedParent.toMap(),
      );

      context.read<ParentProvider>().updateParent(updatedParent);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cambios guardados con éxito')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('correo ya está en uso')) {
        setState(() => emailError = 'Este correo ya está en uso');
      } else if (msg.contains('usuario ya está en uso')) {
        setState(() => userError = 'Este nombre de usuario ya está en uso');
      } else if (msg.contains('teléfono ya está en uso')) {
        setState(() => phoneError = 'Este número ya está en uso');
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al guardar cambios')),
          );
        }
      }
      _formKey.currentState!.validate();
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final estadosMexico = [
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text(
                    'Datos Padre/Tutor',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF056674),
                    ),
                  ),
                ),
                _buildLimitedInput(
                  label: 'Correo Electrónico',
                  controller: _emailController,
                  maxLength: 100,
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildLimitedInput(
                  label: 'Nombre completo',
                  controller: _nameController,
                  maxLength: 30,
                ),
                _buildLimitedInput(
                  label: 'Nombre de usuario',
                  controller: _usernameController,
                  maxLength: 30,
                ),
                _buildPasswordInput('Contraseña', _passwordController!, true),
                _buildPasswordInput(
                  'Confirmar contraseña',
                  _confirmPasswordController!,
                  false,
                ),
                _buildLimitedInput(
                  label: 'Número de teléfono',
                  controller: _phoneController,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildFieldLabel('Estado donde reside'),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: selectedState,
                  items:
                      estadosMexico
                          .map(
                            (estado) => DropdownMenuItem(
                              value: estado,
                              child: Text(estado),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedState = value;
                        _checkForChanges();
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: (!hasChanges || isSaving) ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF82B1FF),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child:
                      isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Guardar cambios'),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Row(
      children: [
        Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        const Text(
          '*',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildLimitedInput({
    required String label,
    required TextEditingController controller,
    required int maxLength,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel(label),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLength: maxLength,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            validator: (value) => _validateField(value, controller),
            onChanged: (value) {
              setState(() {
                final msg = _validateField(value, controller);
                if (controller == _emailController) {
                  emailError = msg;
                } else if (controller == _usernameController) {
                  userError = msg;
                } else if (controller == _phoneController) {
                  phoneError = msg;
                }
              });
              _checkForChanges();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordInput(
    String label,
    TextEditingController controller,
    bool isMainPassword,
  ) {
    final isObscure = isMainPassword ? obscurePassword : obscureConfirmPassword;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel(label),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            obscureText: isObscure,
            maxLength: 30,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    if (isMainPassword) {
                      obscurePassword = !obscurePassword;
                    } else {
                      obscureConfirmPassword = !obscureConfirmPassword;
                    }
                  });
                },
              ),
            ),
            validator: (value) => _validateField(value, controller),
            onChanged: (_) => _checkForChanges(),
          ),
          if (isMainPassword)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Mínimo de 8 caracteres, incluir al menos un carácter especial y un número',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
        ],
      ),
    );
  }
}
