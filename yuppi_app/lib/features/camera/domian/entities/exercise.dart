class Exercise {
  final String idExercise;
  final String imagePath;
  final bool isActive;
  final String nameObjectEng;
  final List<String> nameObjectEngA;

  final String nameObjectSpa;
  final String type;
  final String subType;
  final String detection;

  Exercise({
    required this.idExercise,
    required this.imagePath,
    required this.isActive,
    required this.nameObjectEng,
    required this.nameObjectEngA,
    required this.nameObjectSpa,
    required this.type,
    required this.subType,
    required this.detection,
  });
}
