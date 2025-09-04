import 'package:flutter/material.dart';
import "package:yuppi_app/features/activities/presentation/widgets/activity_intro_widget.dart";

class ActivityIntroPage extends StatelessWidget {
  final dynamic padre;
  final dynamic kid;
  final dynamic exercise;
  final String labelPrefix;
  const ActivityIntroPage({
    super.key,
    required this.padre,
    required this.kid,
    required this.exercise,
    required this.labelPrefix,
  });

  @override
  Widget build(BuildContext context) {
    final VoidCallback onNext = () {
      Navigator.pop(context);
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ActivityIntroWidget(
          padre: padre,
          kid: kid,
          exercise: exercise,
          labelPrefix: labelPrefix,
          onNext: () {}, // opcional si ya no se usa
        ),
      ),
    );
  }
}
