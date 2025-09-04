import 'dart:developer';

import 'package:flutter/material.dart';
//import 'package:yuppi_app/features/auth/dominio/entities/kid.dart';

class ChildRegisterFormWidget extends StatefulWidget {
  final void Function(Map<String, dynamic> data)? onSubmit;
  const ChildRegisterFormWidget({super.key, this.onSubmit});

  @override
  State<ChildRegisterFormWidget> createState() =>
      _ChildRegisterFormWidgetState();
}

class _ChildRegisterFormWidgetState extends State<ChildRegisterFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _customIssueController = TextEditingController();
  final RegExp _onlyLettersRegExp = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$");

  String? _selectedGender;
  String? _selectedIcon;
  bool? _hasLearningIssues;
  String? _selectedIssue;

  final List<String> iconPaths = [
    'assets/images/avatars/avatar1.png',
    'assets/images/avatars/avatar2.png',
    'assets/images/avatars/avatar3.png',
    'assets/images/avatars/avatar4.png',
    'assets/images/avatars/avatar5.png',
    'assets/images/avatars/avatar6.png',
    'assets/images/avatars/avatar7.png',
    'assets/images/avatars/avatar8.png',
    'assets/images/avatars/avatar9.png',
    'assets/images/avatars/avatar10.png',
    'assets/images/avatars/avatar11.png',
    'assets/images/avatars/avatar12.png',
  ];

  final List<String> learningIssues = [
    'Dislexia',
    'TDAH',
    'Problemas de procesamiento auditivo',
    'Problemas de procesamiento visual',
    'Trastorno del espectro autista',
    'Otro',
  ];

  void _showMessage(String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedIcon == null) {
      _showMessage("Selecciona un ícono para el perfil", isError: true);
      return;
    }

    final data = {
      'fullName': _nameController.text.trim(),
      'age': int.parse(_ageController.text),
      'gender': _selectedGender,
      'iconPath': _selectedIcon,
      'hasLearningIssues': _hasLearningIssues,
      'learningIssue':
          _hasLearningIssues == true
              ? (_selectedIssue == 'Otro'
                  ? _customIssueController.text.trim()
                  : _selectedIssue)
              : 'Ninguno',
    };
    log("Antes del summit: $data");
    if (widget.onSubmit != null) widget.onSubmit!(data);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Perfil creado correctamente")),
    );
  }

  Widget _buildIconSelector() {
    return Column(
      children: [
        if (_selectedIcon != null)
          Column(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage(_selectedIcon!),
              ),
              const SizedBox(height: 6),
              const Text(
                "Toca un ícono para cambiar",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
            ],
          ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children:
              iconPaths.map((path) {
                final isSelected = _selectedIcon == path;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = path),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundImage: AssetImage(path),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFFA5F2F2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Crear Perfil",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202020),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildIconSelector(),
          const SizedBox(height: 20),
          TextFormField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Edad',
              border: OutlineInputBorder(),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Este campo es requerido';
              final age = int.tryParse(v);
              return (age == null || age < 1 || age > 12)
                  ? 'Edad entre 1 y 12'
                  : null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre completo',
              border: OutlineInputBorder(),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Campo requerido';

              final nameRegExp = RegExp(
                r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ][a-zA-ZáéíóúÁÉÍÓÚñÑ\s]*$",
              );
              if (!nameRegExp.hasMatch(v))
                return 'El primer caracter deberia ser una letra.\n Recibe: letras y espacios';

              return null;
            },
          ),
          const SizedBox(height: 20),
          const Text("Sexo", style: TextStyle(fontWeight: FontWeight.bold)),
          FormField<String>(
            validator: (value) {
              if (_selectedGender == null) {
                return 'Selecciona una opción';
              }
              return null;
            },
            builder:
                (field) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children:
                          ['Niño', 'Niña', 'Otro'].map((s) {
                            return Expanded(
                              child: RadioListTile<String>(
                                title: Text(s),
                                value: s,
                                groupValue: _selectedGender,
                                onChanged: (val) {
                                  setState(() {
                                    _selectedGender = val;
                                    field.didChange(
                                      val,
                                    ); // ← actualiza el estado del form
                                  });
                                },
                              ),
                            );
                          }).toList(),
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 4),
                        child: Text(
                          field.errorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
          ),

          const SizedBox(height: 16),
          const Text("¿El niño cuenta con problemas de aprendizaje?"),
          FormField<bool>(
            validator: (_) {
              if (_hasLearningIssues == null) {
                return 'Selecciona una opción';
              }
              if (_hasLearningIssues == true && _selectedIssue == null) {
                return 'Selecciona un problema';
              }
              if (_hasLearningIssues == true &&
                  _selectedIssue == 'Otro' &&
                  (_customIssueController.text.trim().isEmpty ||
                      !_onlyLettersRegExp.hasMatch(
                        _customIssueController.text.trim(),
                      ))) {
                return 'Especifica el problema solo con letras';
              }
              return null;
            },
            builder:
                (field) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text("Sí"),
                            value: _hasLearningIssues == true,
                            onChanged:
                                (v) => setState(() {
                                  _hasLearningIssues = true;
                                  field.didChange(true);
                                }),
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text("No"),
                            value: _hasLearningIssues == false,
                            onChanged:
                                (v) => setState(() {
                                  _hasLearningIssues = false;
                                  _selectedIssue = null;
                                  _customIssueController.clear();
                                  field.didChange(false);
                                }),
                          ),
                        ),
                      ],
                    ),
                    if (_hasLearningIssues == true)
                      Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: _selectedIssue,
                            items:
                                learningIssues
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                            onChanged:
                                (v) => setState(() => _selectedIssue = v),
                            decoration: const InputDecoration(
                              labelText: 'Seleccionar problema',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (_selectedIssue == 'Otro')
                            TextFormField(
                              controller: _customIssueController,
                              decoration: const InputDecoration(
                                labelText: 'Especificar problema',
                                border: OutlineInputBorder(),
                              ),
                            ),
                        ],
                      ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 8),
                        child: Text(
                          field.errorText!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
          ),

          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: Color(0xFF00ADEF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text("Crear perfil", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
