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

  factory ScanModel.fromRawJson(String str) =>
      ScanModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        tipus: json["tipus"],
        valor: json["valor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipus": tipus,
        "valor": valor,
      };
}
