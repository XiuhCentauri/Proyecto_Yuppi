import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuppi_app/features/rewards/dominio/entities/Reward_model.dart';
import 'package:yuppi_app/features/rewards/dominio/usecases/updateR_usecase.dart';
import 'package:yuppi_app/features/rewards/innjection/rewards_injection.dart';
import 'package:yuppi_app/providers/kid_provider.dart';

class RewardFormEdit extends StatefulWidget {
  final RewardModel reward;

  const RewardFormEdit({super.key, required this.reward});

  @override
  State<RewardFormEdit> createState() => _RewardFormEditState();
}

class _RewardFormEditState extends State<RewardFormEdit> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _costController;
  late TextEditingController _maxClaimsController;

  String? _selectedCategory;
  String? _iconSelected;
  bool _isFormValid = false;

  final Map<String, String> icons = {
    'comida': 'assets/images/rewards/comida.webp',
    'juguete': 'assets/images/rewards/juguete.webp',
    'salida': 'assets/images/rewards/salida.webp',
    'tiempo': 'assets/images/rewards/tiempo_extra.webp',
    'electrónico': 'assets/images/rewards/dispositivo.webp',
    'especial': 'assets/images/rewards/especial.webp',
    'ropa': 'assets/images/rewards/ropa.webp',
    'entretenimiento': 'assets/images/rewards/entretenimientoo.webp',
  };

  final Map<String, RangeValues> categoryRanges = {
    'Bronce': const RangeValues(10, 100),
    'Plata': const RangeValues(110, 200),
    'Oro': const RangeValues(210, 400),
    'Diamante': const RangeValues(410, 600),
    'Leyenda': const RangeValues(610, 1000),
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.reward.nameRewards);
    _costController = TextEditingController(
      text: widget.reward.countRewards.toString(),
    );
    _maxClaimsController = TextEditingController(
      text: widget.reward.maxRewards.toString(),
    );
    _selectedCategory = widget.reward.categoryRewards;

    // encontrar clave del ícono seleccionado
    _iconSelected =
        icons.entries
            .firstWhere(
              (entry) => entry.value == widget.reward.imagePath,
              orElse: () => const MapEntry('', ''),
            )
            .key;

    _validateForm();
  }

  void _validateForm() {
    final valid =
        _formKey.currentState?.validate() == true &&
        _iconSelected != null &&
        _iconSelected!.isNotEmpty;
    setState(() => _isFormValid = valid);
  }

  void _showMessage(String message, {Color backgroundColor = Colors.black87}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 80, left: 20, right: 20),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final kid = context.read<KidProvider>().selectedKid;

    if (_formKey.currentState?.validate() != true || _iconSelected == null)
      return;

    final updated = widget.reward.copyWith(
      nameRewards: _nameController.text.trim(),
      countRewards: int.parse(_costController.text.trim()),
      maxRewards: int.parse(_maxClaimsController.text.trim()),
      categoryRewards: _selectedCategory!,
      imagePath: icons[_iconSelected]!,
    );

    try {
      await sl<UpdateReward>().call(updated);
      if (mounted) {
        _showMessage(
          "Recompensa actualizada correctamente",
          backgroundColor: Colors.green,
        );
        Navigator.pop(context, true); // o redirigir donde prefieras
      }
    } catch (e) {
      _showMessage(
        "Error al actualizar la recompensa",
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              onChanged: _validateForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.cyan.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Editar Recompensa',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildLabel('Nombre de la recompensa*'),
                  _buildTextInput(
                    _nameController,
                    'Ej. Dos camisas',
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'El nombre es obligatorio';
                      if (!RegExp(
                        r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]+$',
                      ).hasMatch(value.trim())) {
                        return 'El nombre solo puede contener letras y espacios.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Categoría*'),
                  _buildDropdown(),
                  const SizedBox(height: 16),
                  _buildLabel('Costo de recompensa*'),
                  _buildTextInput(
                    _costController,
                    '00',
                    keyboardType: TextInputType.number,
                    validator: _costValidator,
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Número canjes permitidos*'),
                  _buildTextInput(
                    _maxClaimsController,
                    '+',
                    keyboardType: TextInputType.number,
                    validator: _claimsValidator,
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Tipo de recompensa*'),
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children:
                        icons.entries.map((entry) {
                          final selected = _iconSelected == entry.key;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _iconSelected = entry.key;
                                _validateForm();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    selected
                                        ? Colors.lightBlueAccent.withOpacity(
                                          0.3,
                                        )
                                        : Colors.white,
                                border: Border.all(
                                  color:
                                      selected
                                          ? Colors.blue
                                          : Colors.grey.shade300,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Image.asset(
                                entry.value,
                                fit: BoxFit.contain,
                                errorBuilder:
                                    (_, __, ___) => const Icon(Icons.image),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: _isFormValid ? _handleSubmit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Guardar cambios',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 62,
            left: 8,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 22,
                color: Colors.cyan,
              ),
              splashRadius: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    final parts = text.split('*');
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16, color: Colors.black),
          children: [
            TextSpan(text: parts[0]),
            if (text.contains('*'))
              const TextSpan(text: '*', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput(
    TextEditingController controller,
    String hintText, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade400),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade400),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: const InputDecoration(border: InputBorder.none),
        hint: const Text('Seleccionar'),
        items:
            categoryRanges.entries.map((entry) {
              return DropdownMenuItem(
                value: entry.key,
                child: Text(
                  '${entry.key} (${entry.value.start.toInt()}–${entry.value.end.toInt()})',
                ),
              );
            }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCategory = value;
            _validateForm();
          });
        },
        validator:
            (value) => value == null ? 'La categoría es obligatoria' : null,
      ),
    );
  }

  String? _costValidator(String? value) {
    if (value == null || value.isEmpty) return 'El costo es obligatorio';
    final parsed = int.tryParse(value);
    if (parsed == null) return 'Debe ser un número válido';
    if (_selectedCategory != null) {
      final range = categoryRanges[_selectedCategory]!;
      if (parsed < range.start || parsed > range.end) {
        return 'Debe estar entre ${range.start.toInt()} y ${range.end.toInt()} monedas.';
      }
    }
    return null;
  }

  String? _claimsValidator(String? value) {
    if (value == null || value.isEmpty) return 'Este campo es obligatorio';
    final parsed = int.tryParse(value);
    if (parsed == null || parsed <= 0) return 'Debe ser mayor a 0';
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    _maxClaimsController.dispose();
    super.dispose();
  }
}
