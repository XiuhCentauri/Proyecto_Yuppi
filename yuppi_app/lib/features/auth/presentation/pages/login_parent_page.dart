import 'package:flutter/material.dart';
import 'package:yuppi_app/features/auth/presentation/widgets/login_parent_form.dart';

class LoginParentPage extends StatelessWidget {
  const LoginParentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF2F9FF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(
            child: LoginParentForm(), // Llama al formulario
          ),
        ),
      ),
    );
  }
}
