import 'package:yuppi_app/features/rewards/presentation/pages/rewards_form_page.dart';
import 'package:flutter/material.dart';

class AddRewardPage extends StatelessWidget {
  const AddRewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF9FD),
      body: RewardForm(
        onSubmit: () {
          // Aquí va la lógica para guardar (por ahora solo cerrar)
          Navigator.pop(context, true);// Le avisa a RewardsPage que se creó algo
        },
      ),
    );
  }
}
