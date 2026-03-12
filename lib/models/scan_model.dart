import 'dart:convert';

// Clase que definirá el modelo de cada Scan.
class ScanModel {
  int? id;
  String? tipus;
  String valor;

  ScanModel({
    this.id,
    this.tipus,
    required this.valor,
  }) {
    // Determina el valor del Scan y determina de que tipo es.
    if (this.valor.contains('http')) {
      this.tipus = 'http';
    } else {
      this.tipus = 'geo';
    }
  }

  factory ScanModel.fromJson(String str) => ScanModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ScanModel.fromMap(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        tipus: json["tipus"],
        valor: json["valor"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "tipus": tipus,
        "valor": valor,
      };
}
