import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:yuppi_app/core/injection_container.dart';
import 'package:yuppi_app/features/auth/dominio/entities/kid.dart';
import 'package:yuppi_app/features/auth/presentation/pages/initial_entry_page.dart';
import 'core/servicios/firebase_service.dart';
//import 'package:yuppi_app/features/auth/presentation/pages/initial_entry_page.dart';
import 'package:provider/provider.dart';
import 'package:yuppi_app/features/photos/injection/photos_injection_container.dart';
import 'package:yuppi_app/features/parent_profile/injection/profile_injection.dart';
import 'package:yuppi_app/features/kid_profile_edit/injection/kid_profile_edit_injection.dart';
import 'package:yuppi_app/providers/parent_provider.dart';
import 'package:yuppi_app/providers/kid_provider.dart';
import 'package:yuppi_app/features/vision_analysis/injection/vision_analysis_injection.dart';
import 'package:yuppi_app/features/camera/services/canera_injection.dart'
    as camera;
import 'package:yuppi_app/features/text_to_speech/injection/text_to_sppech_injetion.dart';
//import 'package:yuppi_app/features/camera/domian/usecases/get_random_object_exercise_usecase.dart';
//import 'package:yuppi_app/features/text_to_speech/injection/text_to_sppech_injetion.dart';
import 'package:camera/camera.dart';
import 'package:yuppi_app/core/servicios/camera_manager.dart';
//import 'package:yuppi_app/core/servicios/lifecycleManager.dart';
import 'package:yuppi_app/features/rewards/innjection/rewards_injection.dart';
import 'package:yuppi_app/features/score/injection/score_injection.dart'
    as score;
import 'package:yuppi_app/features/notifications/injection/notify_accessible_rewards_injection.dart';
import 'package:yuppi_app/features/gemini/injection/gemini_injection_container.dart';
import 'package:yuppi_app/features/clientMail/injection/email_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService().init();
  await InjectionContainer().init();
  await PhotosInjectionContainer().init();
  await ProfileInjectionContainer().init();
  await KidProfileEditInjection.init();
  await VisionAnalysisInjection().init();
  await camera.CameraInjection().init();
  await TextToSpeechInjection().init();
  await CameraManager().initializeCamera(CameraLensDirection.back);
  await RewardsInjection().init();
  await score.ScoreInjection().init();
  await NotifyAccessibleRewardsInjection().init();
  await GeminiInjectionContainer().init();
  await EmailInjectionContainer().init();
  //final lifecycleManager = LifecycleManager();
  //lifecycleManager.startObserving();
  // String idkid = "bc643b73-13f3-443e-8481-95d6af000484";
  // final kid = Kid(
  //   id: idkid,
  //   fullName: "Alessa Castro",
  //   idParent: "5d809922-1bc5-43bb-813c-8c17eca4f770",
  //   age: 8,
  //   gender: "Niño",
  //   icon: "assets/images/avatars/avatar12.png",
  //   issueKid: "Ninguno",
  //   hasLearningIssues: false,
  // );
  // int cash = 1000;
  // final exercise = await camera.sl<GetRandomExerciseBySubTypeUseCase>().call(
  //   idkid,
  //   'outHouse',
  // );

  // final gemini = await geminiInjection<GeminiService>().generate(
  //   exercise: exercise!,
  //   kid: kid,
  //   idGR: generateUuid(),
  // );
  // log("id: ${gemini.idGR}");
  // log("Elemento: ${gemini.element}");
  // log("Testo Curioso");
  // log(gemini.textC);
  // log("Testo Pista");
  // log(gemini.textP);

  // await geminiInjection<GeminiService>().saveDualFact(gemini);
  // log("Guardado en Base De");
  //score.sl<NewScoreMark>().changeScoreWin(idkid, 1);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ParentProvider()),
        ChangeNotifierProvider(create: (_) => KidProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crear cuenta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: InitialEntryPage(),
    );
  }
}
