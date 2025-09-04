import 'package:flutter/material.dart';

class ConfirmSendPhotoModal extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmSendPhotoModal({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54, // Fondo oscuro transparente
      child: Center(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: 280,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: Color(0xFFE3E8FF), // Lila clarito
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '¿Deseas enviar esta foto a evaluación?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: onConfirm,
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green,
                          child: Icon(Icons.check, color: Colors.white, size: 32),
                        ),
                      ),
                      GestureDetector(
                        onTap: onCancel,
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.redAccent,
                          child: Icon(Icons.close, color: Colors.white, size: 32),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
