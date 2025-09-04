import 'dart:developer';
import 'package:yuppi_app/core/uuid_generator.dart';
import 'package:flutter/material.dart';
import 'package:yuppi_app/features/auth/dominio/entities/kid.dart';
import '../widgets/register_child_form.dart';
import 'package:yuppi_app/core/session/parent_session.dart';
import 'package:yuppi_app/core/injection_container.dart';
import 'package:yuppi_app/features/auth/presentation/pages/profiles_page.dart';
import 'package:provider/provider.dart';
import 'package:yuppi_app/providers/parent_provider.dart';
import 'package:yuppi_app/features/score/injection/score_injection.dart';
import 'package:yuppi_app/features/score/domain/usecases/new_score_mark.dart';

class RegisterChildPage extends StatelessWidget {
  final ParentSession parentSession;
  const RegisterChildPage({super.key, required this.parentSession});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Perfil')),
      body: ChildRegisterFormWidget(
        onSubmit: (data) async {
          final registerKid = InjectionContainer().registerKid;
          final refreshedSession = await parentSession.refresh();
          final List<Kid> kids = refreshedSession.children;

          final nextId = generateUuid();
          log("id: $nextId");
          log("id: $data");
          final newKid = Kid(
            id: nextId.toString(),
            fullName: data['fullName'],
            idParent: refreshedSession.parent.id,
            age: data['age'],
            gender: data['gender'],
            icon: data['iconPath'],
            issueKid: data['learningIssue'],
            hasLearningIssues: data['hasLearningIssues'],
          );
          try {
            await registerKid.call(kid: newKid);
            refreshedSession.children.add(newKid);
            sl<NewScoreMark>().createScoredKid(
              newKid.id,
              parentSession.parent.id,
            );

            // 🔥 Agregamos esto para que el ParentProvider también esté actualizado
            context.read<ParentProvider>().setParent(refreshedSession.parent);

            if (!context.mounted) return;

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ProfilesPage(parentSession: refreshedSession),
              ),
            );
          } catch (e) {
            log("Excepción: $e");
          }
        },
      ),
    );
  }
}
