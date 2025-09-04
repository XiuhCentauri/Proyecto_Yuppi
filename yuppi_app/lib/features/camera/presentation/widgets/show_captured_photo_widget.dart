import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ShowCapturedPhotoWidget extends StatelessWidget {
  final XFile photo;

  const ShowCapturedPhotoWidget({
    super.key,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.file(
        File(photo.path),
        fit: BoxFit.cover,
      ),
    );
  }
}
