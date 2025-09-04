import 'package:flutter/material.dart';

class BottomButtonsWidget extends StatelessWidget {
  final VoidCallback onHelpPressed;
  final VoidCallback onCameraPressed;
  final VoidCallback onDrawPressed;

  const BottomButtonsWidget({
    super.key,
    required this.onHelpPressed,
    required this.onCameraPressed,
    required this.onDrawPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Fondo azul clarito
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 140,
              decoration: const BoxDecoration(
                color: Color(0xFFBEE3E0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón de ayuda (izquierda)
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.orangeAccent,
                    child: IconButton(
                      icon: const Icon(Icons.help_outline, color: Colors.white, size: 28),
                      onPressed: onHelpPressed,
                    ),
                  ),
                  // Espacio reservado, ya que el botón cámara estará flotando encima
                  const SizedBox(width: 72),
                  // Botón de dibujar (derecha)
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.green,
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white, size: 28),
                      onPressed: onDrawPressed,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botón de cámara (flotante, centrado y más arriba)
          Positioned(
            bottom: 45,
            child: GestureDetector(
              onTap: onCameraPressed,
              child: Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: Colors.blue[800],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
