import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuppi_app/providers/kid_provider.dart';
import 'package:yuppi_app/providers/parent_provider.dart';
import 'dart:developer';
import 'package:yuppi_app/core/servicios/hash_password.dart';
import 'package:yuppi_app/features/parent_profile/presentation/widgets/password_confirmation_dialog.dart';
import 'package:yuppi_app/features/rewards/presentation/pages/add_reward_page.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final parentProvider = context.read<ParentProvider>();
      final kidProvider = context.read<KidProvider>();
      final parent = parentProvider.parent;
      final kid = kidProvider.selectedKid;
      log('Parent: ${parent?.fullName}, Kid: ${kid?.fullName}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final parentProvider = context.read<ParentProvider>();
    final kidProvider = context.read<KidProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.cyan),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.cyan),
              onPressed: () async {
                final result = await showPasswordConfirmationDialog(
                  context: context,
                  onConfirm: (password) async {
                    final parent = parentProvider.parent;
                    if (parent == null) return false;

                    return hashPassword(password) == parent.passwordHash;
                  },
                );

                if (result == true) {
                  final resultReward = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddRewardPage(),
                    ),
                  );

                  if (resultReward == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('La recompensa se guardó correctamente'),
                        backgroundColor: Color.fromARGB(255, 112, 126, 203),
                      ),
                    );
                  }
                } else if (result == null) {
                  // Usuario canceló
                } else {
                  // Contraseña incorrecta (ya se mostró mensaje, no hace falta manejarlo aquí)
                }
              },
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Aquí se mostrarán las recompensas (por ahora ocultas)',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
