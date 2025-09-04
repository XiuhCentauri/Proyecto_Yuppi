import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yuppi_app/features/clientMail/dominio/usecases/send_registration_usecase.dart';
import 'package:yuppi_app/features/clientMail/dominio/usecases/sned_reward_usecase.dart';
import 'package:yuppi_app/features/clientMail/injection/email_injection.dart';
import 'package:yuppi_app/features/score/domain/usecases/new_score_mark.dart';
import 'package:yuppi_app/features/score/injection/score_injection.dart'
    as scorelib;
import 'package:yuppi_app/providers/kid_provider.dart';
import 'package:yuppi_app/providers/parent_provider.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'package:yuppi_app/features/rewards/dominio/entities/Reward_model.dart';
import 'package:yuppi_app/features/rewards/innjection/rewards_injection.dart';
import 'package:yuppi_app/features/rewards/dominio/usecases/get_rewards_StatusP.dart';
import 'package:yuppi_app/features/rewards/dominio/usecases/updateR_usecase.dart';
import 'package:yuppi_app/features/rewards/dominio/usecases/deleteR_usecase.dart';
import 'package:yuppi_app/features/rewards/presentation/wigdet/not_enough_coins_dialog.dart';
import 'package:yuppi_app/features/rewards/presentation/wigdet/redeem_confirmation_dialog.dart';
import 'package:yuppi_app/features/rewards/presentation/pages/reward_form_edit.dart';

// --- Página con estado ---
// ... todas las imports igual que antes

class RewardViewPage extends StatefulWidget {
  final bool isEditMode;
  final bool isDeleteMode;

  const RewardViewPage({
    super.key,
    this.isEditMode = false,
    this.isDeleteMode = false,
  });

  @override
  State<RewardViewPage> createState() => _RewardViewPageState();
}

class _RewardViewPageState extends State<RewardViewPage> {
  int currentCoins = 0;
  bool isLoading = true;

  late Map<String, List<RewardModel>> categorizedRewards = {};
  final Map<String, String> categoryImages = {
    'Bronce': 'assets/images/rewards/Bronce.webp',
    'Plata': 'assets/images/rewards/Plata.webp',
    'Oro': 'assets/images/rewards/Oro.webp',
    'Diamante': 'assets/images/rewards/Diamante.webp',
    'Leyenda': 'assets/images/rewards/Leyenda.webp',
  };
  final _allCategories = ['Bronce', 'Plata', 'Oro', 'Diamante', 'Leyenda'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _showSnack(String msg, {Color color = Colors.black}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 80, left: 20, right: 20),
      ),
    );
  }

  void _goToEditForm(RewardModel reward) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RewardFormEdit(reward: reward)),
    );
    if (result == true) await _loadData();
  }

  void _onDelete(RewardModel reward) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFD6E5FF), // color de fondo similar al mockup
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/rewards/advertencia.webp', // <== usa aquí tu ruta real
                    height: 100,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '¿Estás seguro de que deseas eliminar esta recompensa?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Aceptar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );

    if (confirm == true) {
      try {
        await sl<DeleteReward>().call(reward.idReward);
        _showSnack('Recompensa eliminada exitosamente', color: Colors.green);
        await _loadData();
      } catch (_) {
        _showSnack('Error al eliminar la recompensa', color: Colors.red);
      }
    }
  }

  Future<bool> _redeemReward(RewardModel reward) async {
    final kid = context.read<KidProvider>().selectedKid;
    final parent = context.read<ParentProvider>().parent;
    if (kid == null || currentCoins < reward.countRewards) return false;
    if (parent == null) return false;
    try {
      final int newCash = currentCoins - reward.countRewards;

      await scorelib.sl<NewScoreMark>().changeScoreWin(
        kid.id,
        -reward.countRewards,
      );

      if (reward.maxRewards > 1) {
        final updatedReward = reward.copyWith(
          maxRewards: reward.maxRewards - 1,
        );
        await sl<UpdateReward>().call(updatedReward);
        final emailService = emailInjection<SendRewardUsecase>();
        await emailService.call(
          reward.nameRewards,
          parent.email,
          kid.fullName,
          newCash,
          reward.maxRewards - 1,
        );
      } else if (reward.maxRewards == 1) {
        final update2 = reward.copyWith(
          maxRewards: reward.maxRewards - 1,
        );
        await sl<UpdateReward>().call(update2);
        final emailService = emailInjection<SendRewardUsecase>();
        await emailService.call(
          reward.nameRewards,
          parent.email,
          kid.fullName,
          newCash,
          reward.maxRewards - 1,
        );
        await sl<DeleteReward>().call(reward.idReward);
      }

       
      await _loadData();
      return true;
    } catch (e) {
      log("Error al canjear: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hubo un error al canjear la recompensa')),
      );
      return false;
    }
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);

    final parent = context.read<ParentProvider>().parent;
    final kid = context.read<KidProvider>().selectedKid;

    if (kid == null || parent == null) {
      log("Error: no se encontró kid o parent");
      setState(() => isLoading = false);
      return;
    }

    final listRewards = await sl<GetRewardsStatusp>().getListRewardStatusP(
      kid.id,
    );

    final Map<String, List<RewardModel>> catRewards = {
      for (var cat in _allCategories) cat: [],
    };

    for (var raw in listRewards) {
      final model = RewardModel.fromMap(raw.toMap());
      final cat = model.categoryRewards;
      if (catRewards.containsKey(cat)) {
        catRewards[cat]!.add(model);
      } else {
        catRewards[cat] = [model];
      }
    }

    final scoredPrevious = await scorelib.sl<NewScoreMark>().getScore(kid.id);

    setState(() {
      currentCoins = scoredPrevious.cash;
      categorizedRewards = catRewards;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bool noRewards = categorizedRewards.values.every(
      (list) => list.isEmpty,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child:
                  noRewards
                      ? const Center(
                        child: Text(
                          'No hay recompensas disponibles por el momento.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                      : ListView(
                        padding: const EdgeInsets.all(16),
                        children:
                            categorizedRewards.entries.map((entry) {
                              final category = entry.key;
                              final rewards = entry.value;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildCategoryHeader(category),
                                  const SizedBox(height: 8),
                                  if (rewards.isEmpty)
                                    const Text(
                                      'No hay recompensas en esta categoría.',
                                    ),
                                  ...rewards.map(_buildRewardCard).toList(),
                                  const SizedBox(height: 16),
                                ],
                              );
                            }).toList(),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFFCCE6FF),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Recompensas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          if (!widget.isEditMode && !widget.isDeleteMode) ...[
            const Icon(Icons.monetization_on, color: Colors.amber),
            const SizedBox(width: 4),
            Text(
              '$currentCoins',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String category) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          if (categoryImages.containsKey(category))
            Image.asset(categoryImages[category]!, width: 24, height: 24),
          const SizedBox(width: 8),
          Text(
            category,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(RewardModel reward) {
    final bool canAfford = currentCoins >= reward.countRewards;
    final String textoDina =
        widget.isEditMode
            ? "Editar"
            : widget.isDeleteMode
            ? "Eliminar"
            : "Canjear";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade400, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: Colors.grey[200],
                  width: 50,
                  height: 50,
                  child: Image.asset(reward.imagePath, fit: BoxFit.contain),
                ),
              ),
              if (reward.maxRewards > 0)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      '×${reward.maxRewards}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              reward.nameRewards,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: canAfford ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.monetization_on,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${reward.countRewards}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () async {
              if (widget.isEditMode) {
                _goToEditForm(reward);
              } else if (widget.isDeleteMode) {
                _onDelete(reward);
              } else {
                if (!canAfford) {
                  showNotEnoughCoinsDialog(context);
                  return;
                }

                final confirmed = await showRedeemConfirmationDialog(context);
                if (confirmed == true) {
                  final success = await _redeemReward(reward);
                  _showSnack(
                    success
                        ? '¡Recompensa canjeada exitosamente!'
                        : 'No se pudo canjear la recompensa.',
                    color: success ? Colors.green : Colors.red,
                  );
                }
              }
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.blue),
            ),
            child: Text(textoDina),
          ),
        ],
      ),
    );
  }
}
