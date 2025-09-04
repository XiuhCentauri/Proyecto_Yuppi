class RewardModel {
  final String idReward;
  final String idParent;
  final String idKid;
  final String nameRewards;
  final String categoryRewards;
  final String imagePath;
  final int countRewards;
  final int maxRewards;
  final int status;

  RewardModel({
    required this.idReward,
    required this.idParent,
    required this.idKid,
    required this.nameRewards,
    required this.categoryRewards,
    required this.imagePath,
    required this.countRewards,
    required this.maxRewards,
    required this.status,
  });

  RewardModel copyWith({
    String? idReward,
    String? nameRewards,
    String? categoryRewards,
    int? countRewards,
    int? maxRewards,
    String? imagePath,
  }) {
    return RewardModel(
      idReward: idReward ?? this.idReward,
      idKid: idKid ?? this.idKid,
      idParent: idParent ?? this.idParent,
      nameRewards: nameRewards ?? this.nameRewards,
      categoryRewards: categoryRewards ?? this.categoryRewards,
      countRewards: countRewards ?? this.countRewards,
      maxRewards: maxRewards ?? this.maxRewards,
      imagePath: imagePath ?? this.imagePath,
      status: status ?? this.status,
    );
  }

  /// Factory para crear desde Firestore
  factory RewardModel.fromMap(Map<String, dynamic> map) {
    return RewardModel(
      idReward: map['IdReward'] ?? '',
      idParent: map['IdParent'] ?? '',
      idKid: map['IdKid'] ?? '',
      nameRewards: map['NameRewards'] ?? '',
      categoryRewards: map['CategoryRewards'] ?? '',
      imagePath: map['ImagePath'] ?? '',
      countRewards: map['CountRewards'] ?? 0,
      maxRewards: map['maxRewards'] ?? 0,
      status: map['Status'] ?? 0,
    );
  }

  /// Convertir a formato para Firestore
  Map<String, dynamic> toMap() {
    return {
      'IdReward': idReward,
      'IdParent': idParent,
      'IdKid': idKid,
      'NameRewards': nameRewards,
      'CategoryRewards': categoryRewards,
      'ImagePath': imagePath,
      'CountRewards': countRewards,
      'maxRewards': maxRewards,
      'Status': status,
    };
  }
}
