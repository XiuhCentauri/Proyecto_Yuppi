import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ConfirmPhotoWidget extends StatelessWidget {
  final XFile photo;
  final VoidCallback onConfirm;
  final VoidCallback onRetake;

  const ConfirmPhotoWidget({
    super.key,
    required this.photo,
    required this.onConfirm,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.black,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(File(photo.path), fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: onRetake,
              icon: const Icon(Icons.refresh),
              label: const Text('Repetir'),
            ),
            const SizedBox(width: 20),
            ElevatedButton.icon(
              onPressed: onConfirm,
              icon: const Icon(Icons.check),
              label: const Text('Confirmar'),
            ),
          ],
        ),
      ],
    );
  }
}
