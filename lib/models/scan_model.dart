import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

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
    if (valor.contains('http')) {
      tipus = 'http';
    } else {
      tipus = 'geo';
    }
  }

  LatLng getLatLng() {
    final latLng = this.valor.substring(4).split(',');
    final latitude = double.parse(latLng[0]);
    final longitude = double.parse(latLng[1]);

    return LatLng(latitude, longitude);
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
