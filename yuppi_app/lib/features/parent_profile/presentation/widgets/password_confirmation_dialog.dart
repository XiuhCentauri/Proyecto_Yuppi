import 'package:flutter/material.dart';

Future<bool?> showPasswordConfirmationDialog({
  required BuildContext context,
  required Future<bool> Function(String password) onConfirm,
}) async {
  final TextEditingController _controller = TextEditingController();
  bool showError = false;
  bool obscurePassword = true;

  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Ingresa la contraseña',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'contraseña',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  if (showError)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Contraseña incorrecta, inténtalo de nuevo.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed:
                            () => Navigator.pop(
                              dialogContext,
                              null,
                            ), // <- CORREGIDO
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final password = _controller.text.trim();
                          final isValid = await onConfirm(password);
                          if (isValid) {
                            Navigator.pop(dialogContext, true);
                          } else {
                            setState(() {
                              showError = true;
                            });
                          }
                        },
                        child: const Text('Confirmar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
