class Kid {
  final String id;
  final String fullName;
  final int age;
  final String icon;
  final String idParent;
  final String gender;
  final String issueKid;
  final bool hasLearningIssues;
  const Kid({
    required this.id,
    required this.fullName,
    required this.idParent,
    required this.age,
    required this.gender,
    required this.icon,
    required this.issueKid,
    required this.hasLearningIssues,
  });

  Kid copyWith({
    String? fullName,
    int? age,
    String? gender,
    bool? hasLearningIssues,
    String? icon,
    String? issueKid,
  }) {
    return Kid(
      id: id, // No cambia
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      hasLearningIssues: hasLearningIssues ?? this.hasLearningIssues,
      idParent: idParent, // No cambia
      icon: icon ?? this.icon,
      issueKid: issueKid ?? this.issueKid,
    );
  }
}
