import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuppi_app/features/kid_profile_edit/presentation/widget/edit_child_form.dart';
import 'package:yuppi_app/providers/kid_provider.dart';
import 'package:yuppi_app/features/kid_profile_edit/domain/usecases/update_kid_profile.dart';
import 'package:yuppi_app/features/kid_profile_edit/injection/kid_profile_edit_injection.dart';

class EditChildPage extends StatelessWidget {
  const EditChildPage({super.key});

  @override
  Widget build(BuildContext context) {
    final kid = context.watch<KidProvider>().selectedKid;

    if (kid == null) {
      return const Scaffold(
        body: Center(child: Text("❌ No hay perfil de niño seleccionado")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Editar perfil del niño")),
      body: EditChildFormWidget(
        onSubmit: (updatedData) async {
          final updateKidProfile = kidProfileEditInjection<UpdateKidProfile>();

          final success = await updateKidProfile.call(
            idKid: kid.id,
            updatedData: updatedData,
          );

          if (!context.mounted) return;

          if (success) {
            // Actualizamos también el Provider para que la app esté sincronizada
            final updatedKid = kid.copyWith(
              fullName: updatedData['fullName'],
              age: updatedData['age'],
              gender: updatedData['gender'],
              hasLearningIssues: updatedData['hasLearningIssues'],
              issueKid: updatedData['issueKid'],
              icon: updatedData['icon'],
            );

            // Actualizamos el Kid en el Provider
            context.read<KidProvider>().updateKid(updatedKid);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Cambios guardados con éxito")),
            );
            Navigator.pop(context); // Regresar a la pantalla anterior
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("❌ Error al guardar los cambios")),
            );
          }
        },
      ),
    );
  }
}
