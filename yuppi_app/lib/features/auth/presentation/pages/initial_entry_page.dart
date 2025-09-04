import 'package:flutter/material.dart';
import 'package:yuppi_app/features/auth/presentation/widgets/initial_entry_content.dart';

class InitialEntryPage extends StatelessWidget {
  const InitialEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF2F9FF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: InitialEntryContent(),
          ),
        ),
      ),
    );
  }
}
