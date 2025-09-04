import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yuppi_app/providers/kid_provider.dart';
import 'package:provider/provider.dart';

class EditChildFormWidget extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSubmit;

  const EditChildFormWidget({super.key, required this.onSubmit});

  @override
  State<EditChildFormWidget> createState() => _EditChildFormWidgetState();
}

final List<String> learningIssues = [
  'Dislexia',
  'TDAH',
  'Problemas de procesamiento auditivo',
  'Problemas de procesamiento visual',
  'Trastorno del espectro autista',
  'Otro',
];

class _EditChildFormWidgetState extends State<EditChildFormWidget> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  String? _selectedGender;
  bool? _hasLearningIssues;
  String? _IssueKid;
  final _customIssueController = TextEditingController();
  String? _selectedIssue;
  String? _selectedIcon;
  bool _hasChanges = false;
  final RegExp _onlyLettersRegExp = RegExp(
    r"^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$",
    unicode: true,
  );
  final _formKey = GlobalKey<FormState>();

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

  @override
  void initState() {
    super.initState();
    final kid = Provider.of<KidProvider>(context, listen: false).selectedKid!;
    _nameController = TextEditingController(text: kid.fullName);
    _ageController = TextEditingController(text: kid.age.toString());
    _selectedIcon = kid.icon;
    _selectedGender = kid.gender;
    _IssueKid = kid.issueKid;
    _hasLearningIssues = _IssueKid == 'Ninguno' ? false : true;
    _selectedIssue = _hasLearningIssues! ? _IssueKid : null;

    for (final controller in [
      _nameController,
      _ageController,
      _customIssueController,
    ]) {
      controller.addListener(_checkForChanges);
    }
  }

  void _checkForChanges() {
    setState(() => _hasChanges = true);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final int parsedAge = int.parse(_ageController.text.trim());

    final issueKidToSend =
        _hasLearningIssues == true
            ? (_selectedIssue == 'Otro'
                ? _customIssueController.text.trim()
                : _selectedIssue)
            : 'Ninguno';

    final updatedData = {
      'fullName': _nameController.text.trim(),
      'age': parsedAge,
      'gender': _selectedGender,
      'hasLearningIssues': _hasLearningIssues,
      'issueKid': issueKidToSend,
      'icon': _selectedIcon,
    };

    widget.onSubmit(updatedData);
  }

  Widget _buildIconSelector() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(_selectedIcon ?? iconPaths.first),
        ),
        const SizedBox(height: 8),
        const Text(
          "Toca un ícono para cambiar",
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children:
              iconPaths.map((path) {
                final isSelected = _selectedIcon == path;
                return GestureDetector(
                  onTap:
                      () => setState(() {
                        _selectedIcon = path;
                        _checkForChanges();
                      }),
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
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Datos de niño',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.teal[700],
              ),
            ),
          ),
          _buildIconSelector(),
          const SizedBox(height: 24),
          TextFormField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Edad',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Campo obligatorio';
              }
              if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
                return 'La edad solo debe contener números';
              }
              final age = int.tryParse(value.trim());
              if (age == null || age < 4 || age > 12) {
                return 'La edad debe estar entre 4 y 12 años';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre completo',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty)
                return 'Campo obligatorio';
              if (!_onlyLettersRegExp.hasMatch(value.trim()))
                return 'Solo letras y espacios';
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text('Sexo*', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children:
                ['Niño', 'Niña', 'Otro'].map((gender) {
                  return Expanded(
                    child: RadioListTile<String>(
                      title: Text(gender),
                      value: gender,
                      groupValue: _selectedGender,
                      onChanged:
                          (val) => setState(() {
                            _selectedGender = val;
                            _checkForChanges();
                          }),
                    ),
                  );
                }).toList(),
          ),
          if (_selectedGender == null)
            const Padding(
              padding: EdgeInsets.only(left: 8.0, bottom: 8),
              child: Text(
                'Selecciona una opción',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          const SizedBox(height: 16),
          const Text(
            "¿El niño cuenta con problemas de aprendizaje?*",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text("Sí"),
                  value: _hasLearningIssues == true,
                  onChanged:
                      (_) => setState(() {
                        _hasLearningIssues = true;
                        _checkForChanges();
                      }),
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text("No"),
                  value: _hasLearningIssues == false,
                  onChanged:
                      (_) => setState(() {
                        _hasLearningIssues = false;
                        _selectedIssue = null;
                        _customIssueController.clear();
                        _checkForChanges();
                      }),
                ),
              ),
            ],
          ),
          if (_hasLearningIssues == true) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value:
                  learningIssues.contains(_selectedIssue)
                      ? _selectedIssue
                      : null,
              decoration: const InputDecoration(
                labelText: 'Seleccionar problema',
                border: OutlineInputBorder(),
              ),
              items:
                  learningIssues
                      .map(
                        (issue) =>
                            DropdownMenuItem(value: issue, child: Text(issue)),
                      )
                      .toList(),
              onChanged: (val) {
                if (!learningIssues.contains(val)) return;
                setState(() {
                  _selectedIssue = val;
                  if (val != 'Otro') _customIssueController.clear();
                  _IssueKid = val;
                  _checkForChanges();
                });
              },
            ),
            if (_selectedIssue == 'Otro') ...[
              const SizedBox(height: 10),
              TextFormField(
                controller: _customIssueController,
                maxLength: 200,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Especificar problema',
                  border: const OutlineInputBorder(),
                  counterText: '${_customIssueController.text.length}/200',
                ),
                onChanged: (value) {
                  setState(() {
                    _IssueKid = value;
                    _checkForChanges();
                  });
                },
                validator: (value) {
                  if (_hasLearningIssues == true && _selectedIssue == 'Otro') {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) return 'Especifica el problema';
                    if (!_onlyLettersRegExp.hasMatch(trimmed)) {
                      return 'Solo letras y espacios';
                    }
                  }
                  return null;
                },
              ),
            ],
          ],
          FormField<bool>(
            validator: (_) {
              if (_hasLearningIssues == null) return 'Selecciona una opción';
              if (_hasLearningIssues == true && _selectedIssue == null)
                return 'Selecciona un problema';
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
            builder: (_) => const SizedBox(),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _hasChanges ? _submit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00ADEF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text(
              "Guardar cambios",
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text(
              "Cancelar",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
