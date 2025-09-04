import 'package:flutter/material.dart';
import 'package:yuppi_app/features/rewards/dominio/entities/Reward_model.dart';
import 'package:yuppi_app/features/rewards/dominio/usecases/create_reward_usecase.dart';
import 'package:yuppi_app/features/rewards/innjection/rewards_injection.dart';
import 'package:yuppi_app/providers/kid_provider.dart';
import 'package:yuppi_app/providers/parent_provider.dart';
import 'package:provider/provider.dart';
import 'package:yuppi_app/core/uuid_generator.dart';
import 'package:yuppi_app/features/rewards/dominio/usecases/get_rewards_by_kid_id_usecase.dart';

class RewardForm extends StatefulWidget {
  final VoidCallback? onSubmit;

  const RewardForm({super.key, this.onSubmit});

  @override
  State<RewardForm> createState() => _RewardFormState();
}

class _RewardFormState extends State<RewardForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  String? _selectedCategory;
  String? _iconSelected;
  int? _selectedClaims;
  bool _isFormValid = false;
  int bronzeCount = 0;
  int silverCount = 0;
  int goldCount = 0;
  int diamondCount = 0;
  int legendCount = 0;

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
    _fetchAndCountRewards();
  }

  bool _hasReachedCategoryLimit(String category) {
    switch (category) {
      case 'Bronce': return bronzeCount >= 10;
      case 'Plata': return silverCount >= 10;
      case 'Oro': return goldCount >= 10;
      case 'Diamante': return diamondCount >= 10;
      case 'Leyenda': return legendCount >= 10;
      default: return false;
    }
  }

  Future<void> _fetchAndCountRewards() async {
    final kid = context.read<KidProvider>().selectedKid;
    if (kid == null) return;

    final useCase = sl<GetRewardsByKidIdUseCase>();
    final rewards = await useCase.call(kid.id);

    bronzeCount = 0;
    silverCount = 0;
    goldCount = 0;
    diamondCount = 0;
    legendCount = 0;

    for (var reward in rewards) {
      switch (reward.categoryRewards) {
        case 'Bronce': bronzeCount++; break;
        case 'Plata': silverCount++; break;
        case 'Oro': goldCount++; break;
        case 'Diamante': diamondCount++; break;
        case 'Leyenda': legendCount++; break;
      }
    }

    if (mounted) setState(() {});
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

  void _validateForm() {
    final valid = _formKey.currentState?.validate() == true &&
        _iconSelected != null &&
        _iconSelected!.isNotEmpty &&
        _selectedClaims != null;
    setState(() => _isFormValid = valid);
  }

  void _handleSubmit() async {
    final parent = context.read<ParentProvider>().parent;
    final kid = context.read<KidProvider>().selectedKid;

    if (_selectedCategory != null && _hasReachedCategoryLimit(_selectedCategory!)) {
      _showMessage('Ya has registrado 10 recompensas para esta categoría.', backgroundColor: Colors.purple);
      return;
    }

    if (_formKey.currentState?.validate() == true && _iconSelected != null && _iconSelected!.isNotEmpty && _selectedClaims != null) {
      final reward = RewardModel(
        idReward: generateUuid(),
        nameRewards: _nameController.text.trim(),
        categoryRewards: _selectedCategory!,
        imagePath: icons[_iconSelected]!,
        idParent: parent!.id,
        idKid: kid!.id,
        status: 1,
        countRewards: int.parse(_costController.text.trim()),
        maxRewards: _selectedClaims!,
      );

      try {
        await sl<CreateRewardUseCase>().call(reward);
        if (mounted) widget.onSubmit?.call();
      } catch (e) {
        _showMessage('Ocurrió un error al guardar la recompensa.', backgroundColor: Colors.red);
      }
    }
  }

  String? _costValidator(String? value) {
    if (value == null || value.isEmpty) return 'El costo es obligatorio';
    final parsed = int.tryParse(value);
    if (parsed == null) return 'Debe ser un número válido';
    if (_selectedCategory != null) {
      final range = categoryRanges[_selectedCategory]!;
      if (parsed < range.start || parsed > range.end) {
        return 'El costo debe estar entre ${range.start.toInt()} y ${range.end.toInt()} monedas, según la categoría seleccionada.';
      }
    }
    return null;
  }

  String _getClaimsText(int value) {
    switch (value) {
      case 1: return '(una vez)';
      case 2: return '(dos veces)';
      case 3: return '(tres veces)';
      case 4: return '(cuatro veces)';
      case 5: return '(cinco veces)';
      default: return '';
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
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.cyan.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('Recompensa', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildLabel('Nombre de la recompensa*'),
                  _buildTextInput(_nameController, 'Ej. Dos camisas', validator: (value) {
                    if (value == null || value.isEmpty) return 'El nombre es obligatorio';
                    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]+$').hasMatch(value.trim())) {
                      return 'El nombre solo puede contener letras y espacios.';
                    }
                    return null;
                  }),
                  const SizedBox(height: 16),
                  _buildLabel('Categoría*'),
                  _buildDropdown(),
                  const SizedBox(height: 16),
                  _buildLabel('Costo de recompensa*'),
                  _buildTextInput(_costController, '00', keyboardType: TextInputType.number, validator: _costValidator),
                  const SizedBox(height: 16),
                  _buildLabel('Número canjes permitidos*'),
                  DropdownButtonFormField<int>(
                    value: _selectedClaims,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade400)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    ),
                    hint: const Text('Seleccionar'),
                    items: List.generate(5, (index) {
                      final value = index + 1;
                      return DropdownMenuItem(
                        value: value,
                        child: Text('$value ${_getClaimsText(value)}'),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        _selectedClaims = value;
                        _validateForm();
                      });
                    },
                    validator: (value) => value == null ? 'Este campo es obligatorio' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Tipo de recompensa*'),
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: icons.entries.map((entry) {
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
                            color: selected ? Colors.lightBlueAccent.withOpacity(0.3) : Colors.white,
                            border: Border.all(color: selected ? Colors.blue : Colors.grey.shade300, width: 2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(entry.value, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.image)),
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
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text('Aceptar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22, color: Colors.cyan),
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
            if (text.contains('*')) const TextSpan(text: '*', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput(TextEditingController controller, String hintText, {TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator}) {
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
        decoration: InputDecoration(border: InputBorder.none, hintText: hintText),
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
        items: categoryRanges.entries.map((entry) {
          return DropdownMenuItem(
            value: entry.key,
            child: Text('${entry.key} (${entry.value.start.toInt()}–${entry.value.end.toInt()})'),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCategory = value;
            _validateForm();
          });
        },
        validator: (value) => value == null ? 'La categoría es obligatoria' : null,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    super.dispose();
  }
}
