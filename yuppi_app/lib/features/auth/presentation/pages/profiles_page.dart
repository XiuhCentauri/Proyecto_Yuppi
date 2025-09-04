import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yuppi_app/core/servicios/hash_password.dart';
import 'package:yuppi_app/core/session/parent_session.dart';
import 'package:yuppi_app/features/home/presentation/pages/child_home_page.dart';
import 'package:yuppi_app/features/auth/presentation/pages/register_child_page.dart';
import 'package:provider/provider.dart';
import 'package:yuppi_app/providers/kid_provider.dart';

class ProfilesPage extends StatelessWidget {
  final ParentSession parentSession;

  const ProfilesPage({super.key, required this.parentSession});

  void _mostrarDialogoContrasena(BuildContext context, ParentSession session) {
    final passwordController = TextEditingController();
    bool passwordVisible = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text("Confirmar contraseña"),
              content: TextField(
                controller: passwordController,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  labelText: "Contraseña del padre",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: passwordVisible ? Colors.lightBlue : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final password = passwordController.text.trim();
                    if (password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("La contraseña no puede estar vacía"),
                        ),
                      );
                    } else {
                      if (hashPassword(password) ==
                          session.parent.passwordHash) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    RegisterChildPage(parentSession: session),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Contraseña incorrecta"),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text("Confirmar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ParentSession>(
      future: ParentSession.create(parentSession.parent),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data!;
        final kids = session.children;
        for (final kid in kids) {
          log('Niño: ${kid.fullName}, edad: ${kid.age}, ícono: ${kid.icon}');
        }

        return Scaffold(
          backgroundColor: const Color(0xFFE6EFFF),
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Yuppi",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 8, 7),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Perfiles",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...kids.map(
                          (kid) => GestureDetector(
                            onTap: () async {
                              debugPrint('✅ Tap en perfil: ${kid.fullName}');
                              context.read<KidProvider>().setKid(kid);
                              await Future.delayed(Duration.zero);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChildHomePage(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 60,
                                          backgroundImage: AssetImage(kid.icon),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      kid.fullName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildBotonAgregar(context, session),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBotonAgregar(BuildContext context, ParentSession session) {
    return GestureDetector(
      onTap: () => _mostrarDialogoContrasena(context, session),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.deepPurple, width: 5),
            ),
            child: const Icon(Icons.add, size: 50, color: Colors.deepPurple),
          ),
          const SizedBox(height: 8),
          const Text(
            "Agregar",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
