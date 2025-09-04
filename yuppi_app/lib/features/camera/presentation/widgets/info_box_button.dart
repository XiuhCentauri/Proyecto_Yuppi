// Archivo: info_box_button.dart
import 'package:flutter/material.dart';

class InfoBoxButton extends StatelessWidget {
  final String title;
  final String content;
  final Color color;
  final Color borderColor;
  final void Function()? onTap;

  const InfoBoxButton({
    super.key,
    required this.title,
    required this.content,
    required this.color,
    required this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isValid = content.trim().isNotEmpty;
    final displayText = isValid ? content : "⚠️ Texto no disponible";

    return GestureDetector(
      onTap: isValid ? onTap : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              displayText,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
