class Scored {
  final String idScored;
  final String idKid;
  final String idParent;
  final int cash;
  final int losses;
  final int wins;

  Scored({required this.idScored , required this.idKid, required this.idParent, required this.cash, required this.losses,  required this.wins});

  factory Scored.fromMap(Map<String, dynamic> map){
    return Scored(
      idScored: map['IdScore'] ?? '',
      idParent:  map['IdParent'] ?? '',
      idKid: map['IdKid'] ?? '',
      cash: map['cash'] ?? 0,
      losses:  map['losses'] ?? 0,
      wins: map['wins'] ?? 0,
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'IdScore' : idScored,
      'IdParent': idParent,
      'IdKid': idKid,
      'cash' : cash,
      'losses': losses,
      'wins': wins
    };
  }
}