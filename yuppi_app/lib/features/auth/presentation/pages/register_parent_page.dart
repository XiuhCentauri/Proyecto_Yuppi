import 'package:flutter/material.dart';
import '../widgets/register_form.dart';

class RegisterParentPage extends StatelessWidget {
  const RegisterParentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: const RegisterForm(),
    );
  }
}

