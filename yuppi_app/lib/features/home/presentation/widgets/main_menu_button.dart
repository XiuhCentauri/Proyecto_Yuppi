import 'package:flutter/material.dart';

class MainMenuButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool comingSoon;
  final bool blocked;
  final VoidCallback? onTap;

  const MainMenuButton({
    super.key,
    required this.label,
    required this.imagePath,
    this.comingSoon = false,
    this.blocked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = comingSoon || blocked;

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Opacity(
        opacity: isDisabled ? 0.6 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent, width: 2),
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(imagePath, height: 120, fit: BoxFit.contain),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              // Etiqueta de "PRÓXIMAMENTE"
              if (comingSoon)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'PRÓXIMAMENTE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              // Candado si está bloqueado
              if (blocked)
                const Positioned(
                  top: 12,
                  right: 12,
                  child: Icon(
                    Icons.lock,
                    size: 20,
                    color: Colors.redAccent,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
