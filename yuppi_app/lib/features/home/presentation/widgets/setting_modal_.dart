import 'package:flutter/material.dart';

class SettingsModal extends StatelessWidget {
  final VoidCallback onClose;
  final void Function() onTapEditParent;
  final void Function() onTapEditKid;
  final void Function() onTapRewardOptions;
  const SettingsModal({
    super.key,
    required this.onClose,
    required this.onTapEditParent,
    required this.onTapEditKid,
    required this.onTapRewardOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: Center(
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE3E8FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Configuración',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildOption(
                      'Editar cuenta principal Padre/Tutor',
                      onTapEditParent,
                    ),
                    const SizedBox(height: 10),
                    _buildOption('Editar perfil de niño', onTapEditKid),

                    const SizedBox(height: 10),
                    _buildOption('Recompensas', onTapRewardOptions),
                  ],
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOption(String text, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFC8DCFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
