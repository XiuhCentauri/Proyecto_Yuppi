import 'package:flutter/material.dart';

Future<bool?> showRedeemConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color(0xFFE8F1FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '¿Estás seguro de que quieres canjear la recompensa?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: Colors.white, // <-- Aquí se fuerza a blanco
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text(
              'Aceptar',
              style: TextStyle(
                color: Colors.white, // <-- Aquí se fuerza a blanco
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
