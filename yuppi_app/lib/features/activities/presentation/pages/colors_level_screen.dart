// features/activities/presentation/pages/colors_level_screen.dart

import 'package:flutter/material.dart';
import 'package:yuppi_app/features/auth/dominio/entities/parent.dart';
import 'package:yuppi_app/features/camera/domian/entities/exercise.dart';
import '../widgets/activity_level_page.dart';
import 'package:provider/provider.dart';
import 'package:yuppi_app/providers/kid_provider.dart';
import 'package:yuppi_app/providers/parent_provider.dart';
import 'package:yuppi_app/features/vision_analysis/injection/vision_analysis_injection.dart';
import 'package:yuppi_app/features/vision_analysis/domain/usecases/correct_Exs_UseCase.dart';

import 'package:yuppi_app/features/camera/services/canera_injection.dart';
import 'package:yuppi_app/features/camera/domian/usecases/get_RanExer_BySubType_UseCase.dart';
import 'package:yuppi_app/features/auth/dominio/entities/kid.dart';
import 'dart:developer';
import 'package:yuppi_app/features/activities/presentation/pages/activity_intro_page.dart';
import 'package:yuppi_app/features/vision_analysis/domain/entities/analyzed_record.dart';
import 'package:yuppi_app/features/vision_analysis/domain/usecases/get_excerciseGood_Subtype_usecase.dart';
import 'package:yuppi_app/features/camera/domian/usecases/get_exerciseById_usecase.dart';

class ColorsLevelScreen extends StatefulWidget {
  final String title;
  final String subType;

  const ColorsLevelScreen({
    super.key,
    required this.title,
    required this.subType,
  });

  @override
  _ColorsLevelScreenState createState() => _ColorsLevelScreenState();
}

class _ColorsLevelScreenState extends State<ColorsLevelScreen> {
  // Aquí puedes mantener el estado de la pantalla, como 'count' u otros valores
  late Kid selectedKid;
  late Parent selectedparent;
  late int count = 0;
  late int countTotal = 0;
  List<Exercise> sentExercise = [];

  @override
  void initState() {
    super.initState();
    // Inicializamos selectedKid en initState
    selectedKid = context.read<KidProvider>().selectedKid!;
    log(selectedKid.id);
    selectedparent = context.read<ParentProvider>().parent!;
    _inicializeCountTotal();
    _updateCount();
  }

  _inicializeCountTotal() {
    if (widget.subType != "primary") {
      countTotal = 5;
      return;
    }

    countTotal = 10;
    return;
  }

  Future<void> _getExercisesByKid(List<AnalyzedRecord> list) async {
    List<Exercise> listExercises = [];

    final FunctionListAllExecer = sl<GetExercisebyidUsecase>();
    final listExercise = await FunctionListAllExecer.call();

    for (var record in list) {
      try {
        final exercise = listExercise.firstWhere(
          (e) => e.idExercise == record.exerciseId,
        );
        log(exercise.nameObjectSpa);
        listExercises.add(exercise);
      } catch (e) {
        log("No se encontró ejercicio con id: ${record.exerciseId}");
      }
    }

    sentExercise = listExercises;
  }

  // Función para obtener colorCount
  Future<int> _numberprymary() async {
    if (selectedKid == null) return 0;

    final records = await visionInjection<GetExcercisegoodSubtypeUsecase>()
        .call(selectedKid.id, 'primary');
    await _getExercisesByKid(records);
    context.read<KidProvider>().updatecountcolor(records.length);

    return records.length;
  }

  // Función para obtener figures
  Future<int> _vocales() async {
    if (selectedKid == null) return 0;

    final records = await visionInjection<GetExcercisegoodSubtypeUsecase>()
        .call(selectedKid.id, 'vocales');
    await _getExercisesByKid(records);
    context.read<KidProvider>().updatecountfigure(records.length);

    return records.length;
  }

  Future<int> _InHouse() async {
    if (selectedKid == null) {
      log("ups..");
      return 0;
    }

    final records = await visionInjection<GetExcercisegoodSubtypeUsecase>()
        .call(selectedKid.id, 'inHouse');
    await _getExercisesByKid(records);
    log("inHouse: ${records.length}");

    return records.length;
  }

  Future<int> _OutHouse() async {
    if (selectedKid == null) {
      log("ups..");
      return 0;
    }

    final records = await visionInjection<GetExcercisegoodSubtypeUsecase>()
        .call(selectedKid.id, 'outHouse');
    await _getExercisesByKid(records);
    log("outHouse: ${records.length}");

    return records.length;
  }

  Future<void> _updateCount() async {
    if (selectedKid == null || widget.subType == null) return;

    final records = await visionInjection<GetExcercisegoodSubtypeUsecase>()
        .call(selectedKid.id, widget.subType);

    await _getExercisesByKid(records);

    setState(() {
      log(records.length.toString());
      count = records.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<int>(
          future:
              widget.subType == 'primary'
                  ? _numberprymary()
                  : widget.subType == 'vocales'
                  ? _vocales()
                  : widget.subType ==
                      'inHouse' // Nuevo caso para 'inHouse'
                  ? _InHouse()
                  : widget.subType == 'outHouse'
                  ? _OutHouse() // Llamar a la función _inHouse cuando el subType sea 'inHouse'
                  : Future.value(0),
          builder: (context, snapshot) {
            log(
              "Ejecutando el builder del FutureBuilder",
            ); // Verifica si el builder se ejecuta
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            log(widget.subType);
            log(count.toString());
            return ActivityLevelPage(
              title: widget.title,
              correctCount: count, // Usamos el valor de count
              subType: widget.subType,
              listExercises: sentExercise,
              totalActivities: countTotal,
              onAddPressed: () async {
                // Obtenemos la instancia del caso de uso con GetIt
                final getRandomExerciseBySubTypeUseCase =
                    sl<GetRandomExerciseBySubTypeUseCase>();

                // Llamamos a la función 'call()' del caso de uso
                final exercise = await getRandomExerciseBySubTypeUseCase.call(
                  selectedKid!.id,
                  widget.subType, // Usamos 'color' o 'figure' según corresponda
                );
                log(exercise!.idExercise);

                String txtlabel = '';
                if (widget.subType == 'vocales') {
                  txtlabel =
                      'Identifica esta vocal: ' + exercise!.nameObjectSpa;
                } else if (widget.subType == 'primary') {
                  txtlabel =
                      'Identifica este número: ' + exercise!.nameObjectSpa;
                } else if (widget.subType == 'inHouse' ||
                    widget.subType == 'outHouse') {
                  txtlabel =
                      'Identifica este objeto: ' + exercise!.nameObjectSpa;
                }
                log("${exercise!.nameObjectSpa}");
                log("${exercise!.subType}");
                log(txtlabel);

                if (exercise != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ActivityIntroPage(
                            padre: selectedparent,
                            kid: selectedKid,
                            exercise: exercise,
                            labelPrefix: txtlabel,
                          ),
                    ),
                  );
                } else {
                  debugPrint('No se encontró ejercicio para ${widget.subType}');
                }
              },
              onBackPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
    );
  }
}
