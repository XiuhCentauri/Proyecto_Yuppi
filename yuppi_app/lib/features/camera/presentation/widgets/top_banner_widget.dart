import 'package:flutter/material.dart';

class TopBannerWidget extends StatelessWidget {
  final VoidCallback onClose;
  final String label;
  final double topOffset;

  const TopBannerWidget({
    super.key,
    required this.onClose,
    required this.label,
    this.topOffset = 120, // Puedes ajustar esta altura desde camera_page
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topOffset,
      left: 20,
      right: 20,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,

                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onClose,
                child: const CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
