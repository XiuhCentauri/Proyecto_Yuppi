class GeminiFactModel {
  final String element;
  final String idGR;
  final String SubType;
  final String textC;
  final String textP;
  final DateTime createdAt;

  GeminiFactModel({
    required this.element,
    required this.idGR,
    required this.SubType,
    required this.textC,
    required this.textP,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'idGR': idGR,
      'element': element,
      'SubType': SubType,
      'textC': textC,
      'textP': textP,
      'createdAt': createdAt,
    };
  }
}
