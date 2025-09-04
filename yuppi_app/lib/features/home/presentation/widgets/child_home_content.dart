import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:yuppi_app/core/servicios/hash_password.dart';
import 'package:yuppi_app/features/home/presentation/widgets/main_menu_button.dart';
import 'package:yuppi_app/features/home/presentation/widgets/setting_modal_.dart';
import 'package:yuppi_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:yuppi_app/features/parent_profile/presentation/pages/edit_parent_profile_page.dart';
import 'package:yuppi_app/features/parent_profile/presentation/widgets/password_confirmation_dialog.dart';
import 'package:provider/provider.dart';
import 'package:yuppi_app/providers/parent_provider.dart';
import 'package:yuppi_app/providers/kid_provider.dart';
import 'package:yuppi_app/features/kid_profile_edit/presentation/pages/edit_child_page.dart';
import 'package:yuppi_app/features/activities/presentation/pages/choose_color_or_shape_page.dart';
import 'package:yuppi_app/features/activities/presentation/pages/choose_object_area_page.dart';
import 'package:yuppi_app/features/vision_analysis/injection/vision_analysis_injection.dart';
import 'package:yuppi_app/features/vision_analysis/domain/usecases/correct_Exs_UseCase.dart';
import 'package:yuppi_app/features/auth/dominio/entities/kid.dart';
import 'package:yuppi_app/features/auth/dominio/entities/parent.dart';
import 'package:yuppi_app/features/rewards/presentation/pages/rewards_form_page.dart';
import 'package:yuppi_app/features/activities/presentation/pages/choose_number_pager.dart';
import 'package:yuppi_app/features/rewards/presentation/pages/reward_view_page.dart';
import 'package:yuppi_app/features/home/presentation/widgets/rewars_modal.dart';
import 'package:yuppi_app/features/notifications/injection/notify_accessible_rewards_injection.dart';
import 'package:yuppi_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:yuppi_app/features/notifications/presentacion/notifications_page.dart';

class ChildHomeContent extends StatefulWidget {
  const ChildHomeContent({super.key});

  @override
  State<ChildHomeContent> createState() => _ChildHomeContentState();
}

class _ChildHomeContentState extends State<ChildHomeContent> {
  bool showSettings = false;
  bool isObjectUnlocked = false;
  bool isLoadingUnlockStatus = true;
  bool hasInitialized = false;

  late Parent parent;
  late Kid kid;
  int? previousAge;
  int? previousVocals;
  int? previousNumber;
  bool _kidChangeHandled = false;
  bool showAddRewardModal = false;
  List<NotificationEntity> _listNotif = [];

  bool hasUnreadNotifications = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
    context.read<KidProvider>().addListener(_onKidDataChanged);
  }

  void _initializeData() {
    if (!hasInitialized) {
      hasInitialized = true;
      parent = context.read<ParentProvider>().parent!;
      kid = context.read<KidProvider>().selectedKid!;
      previousAge = 0;
      previousVocals = 0;
      previousNumber = 0;
      _loadObjectUnlockStatus(kid.id, kid.age);
      _checkUnreadNotifications();
    }
  }

  Future<void> _checkUnreadNotifications() async {
    final kidId = context.read<KidProvider>().selectedKid?.id;
    if (kidId == null) return;

    final notifications =
        await notifyAccessibleInjection<NotificationRepository>()
            .getNotificationsForUser(kidId);
    _listNotif = notifications.where((notif) => notif.read == false).toList();
    final unread = notifications.any((n) => !n.read);

    setState(() => hasUnreadNotifications = unread);
  }

  void _onKidDataChanged() async {
    if (!mounted) return;
    final kidProvider = context.read<KidProvider>();
    final newFigures = kidProvider.correctFigures;
    final newColors = kidProvider.correctColors;
    final newAge = kidProvider.selectedKid?.age ?? 0;
    if (newFigures != previousVocals ||
        newColors != previousNumber ||
        newAge != previousAge) {
      previousVocals = newFigures;
      previousNumber = newColors;
      previousAge = newAge;
      await _loadObjectUnlockStatus(kid.id, newAge);
    }
  }

  Future<void> _loadObjectUnlockStatus(String kidId, int age) async {
    setState(() => isLoadingUnlockStatus = true);
    final countNumbers =
        await visionInjection<CountCorrectExercisesBySubTypeUseCase>().call(
          kidId,
          'primary',
        );
    final countVocals =
        await visionInjection<CountCorrectExercisesBySubTypeUseCase>().call(
          kidId,
          'vocales',
        );

    log("figures: $countNumbers");
    log("colores: $countVocals");

    bool unlocked = false;
    if (countVocals >= 3 && countNumbers >= 5) unlocked = true;
    if (age >= 8) unlocked = true;

    setState(() {
      isObjectUnlocked = unlocked;
      isLoadingUnlockStatus = false;
      previousVocals = countVocals;
      previousNumber = countNumbers;
      previousAge = age;
    });

    context.read<KidProvider>().updateCorrectExercises(
      figures: countVocals,
      colors: countNumbers,
    );
  }

  void _navigateToEditParent() async {
    setState(() => showSettings = false);
    await Future.delayed(const Duration(milliseconds: 300));
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const EditParentProfilePage()),
    );
    setState(() => showSettings = true);
  }

  void _onTapRewardOptions() async {
    setState(() {
      showSettings = false;
      showAddRewardModal = true;
    });
  }

  void onTapEditKid() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditChildPage()),
    );
  }

  double getActivityAspectRatio() => 0.65;

  @override
  Widget build(BuildContext context) {
    final kid = context.watch<KidProvider>().selectedKid;
    if (kid == null || isLoadingUnlockStatus) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_kidChangeHandled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onKidDataChanged();
      });
      _kidChangeHandled = true;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F9FF),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: onTapEditKid,
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage(kid.icon),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        kid.fullName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => NotificationsPage(
                                    listNotif: _listNotif,
                                    onUnreadStatusChanged: (hasUnread) {
                                      setState(
                                        () =>
                                            hasUnreadNotifications = hasUnread,
                                      );
                                    },
                                  ),
                            ),
                          );
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCAE4F9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Yuppi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            if (hasUnreadNotifications)
                              const Positioned(
                                top: -4,
                                right: -4,
                                child: CircleAvatar(
                                  radius: 6,
                                  backgroundColor: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      childAspectRatio: getActivityAspectRatio(),
                      children: [
                        MainMenuButton(
                          label: 'Letras',
                          imagePath: 'assets/images/home/LetrasIcono.webp',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ChooseLettersPage(),
                              ),
                            );
                          },
                        ),
                        MainMenuButton(
                          label: 'Objetos',
                          imagePath: 'assets/images/home/Objetos.png',
                          onTap:
                              isObjectUnlocked
                                  ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => const ChooseObjectAreaPage(),
                                      ),
                                    );
                                  }
                                  : null,
                          blocked: !isObjectUnlocked,
                        ),
                        MainMenuButton(
                          label: 'Números',
                          imagePath: 'assets/images/home/NumerosIcono.webp',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ChooseNumberPage(),
                              ),
                            );
                          },
                        ),
                        const MainMenuButton(
                          label: 'Reconocimiento de voz',
                          imagePath: 'assets/images/home/Pronunciacion.png',
                          comingSoon: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 25,
              right: 24,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/home/Enciclopedia.png',
                        width: 55,
                        height: 55,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Enciclopedia',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (showSettings)
              SettingsModal(
                onClose: () => setState(() => showSettings = false),
                onTapEditParent: _navigateToEditParent,
                onTapEditKid: onTapEditKid,
                onTapRewardOptions: _onTapRewardOptions,
              ),
            if (showAddRewardModal)
              AddRewardModal(
                onClose: () => setState(() => showAddRewardModal = false),
                onAddPressed: () async {
                  setState(() => showSettings = true);
                  setState(() => showAddRewardModal = true);
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => RewardForm(
                            onSubmit: () => Navigator.pop(context, true),
                          ),
                    ),
                  );
                  if (!mounted) return;
                  if (result == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('La recompensa se guardó correctamente'),
                      ),
                    );
                  }
                },
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: const Color(0xFF6BA5FF),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                onPressed: () async {
                  final parent = context.read<ParentProvider>().parent;
                  if (parent == null) return;

                  final bool? isConfirmed =
                      await showPasswordConfirmationDialog(
                        context: context,
                        onConfirm:
                            (String password) async =>
                                hashPassword(password) == parent.passwordHash,
                      );

                  if (isConfirmed == true) {
                    setState(() => showSettings = true);
                  } else if (isConfirmed == false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contraseña incorrecta')),
                    );
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 28),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.stars, color: Colors.white, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RewardViewPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
