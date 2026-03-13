import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:qr_scan/providers/db_provider.dart';

// Esta clase hace de intermediaria entre la base de datos y los widgets
// Al extender ChangeNotifier hay que notificar de los cambios en la interfaz
class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = []; // Lista que almacena los scan que son ScanModel
  String tipusSeleccionat =
      'http'; // Guarda el tipo de escaneo. Es el por defecto.

  //Añade un nuevo scan en la BBDD
  Future<ScanModel> scanNuevo(String valor) async {
    final scanNuevo =
        ScanModel(valor: valor); // Instanciamos el modelo con su valor
    final id = await DBProvider.db.insertScan(scanNuevo); // Lo insertamos
    scanNuevo.id = id; // Le asignamos a nuestro objeto la ID generada

    // Solo se añadirá a la pestaña abierta si el tipo del escaneo y el tipo seleccionado coinciden.
    if (scanNuevo.tipus == tipusSeleccionat) {
      scans.add(scanNuevo);
      notifyListeners();
    }
    return scanNuevo; // devolvemos el scan para su uso
  }

  // Cargamos todos los scans de la BBDD
  Future<void> carregaScans() async {
    final scans = await DBProvider.db.getAllScans();
    this.scans = [
      ...scans
    ]; // Actuliza la lista actual y por una lista completa. [...] = Spread que crea una lista nueva completa.
    notifyListeners();
  }

  // Carga los scans por tipo
  Future<void> carregaScansPerTipus(String tipus) async {
    final scansTipus = await DBProvider.db.getScanByTipus(tipus);
    scans = [
      ...scansTipus
    ]; // Actualiza la lista actual por la lista con filtrados.
    tipusSeleccionat =
        tipus; // Importante: actualizamos el tipo seleccionado para que muestre la lista correcta.
    notifyListeners();
  }

  // Borra todos los scans.
  Future<void> esborraTots() async {
    await DBProvider.db.deleteAllScans();
    scans = []; //Vacia la lista
    notifyListeners();
  }

  // Borra un registro específico
  Future<void> esborraPerId(int id) async {
    await DBProvider.db.deleteById(id);
    scans.removeWhere((scan) =>
        scan.id ==
        id); // Utilizamos removeWhere (como si fuera la funcion WHERE, para borrar el scan cuya scan.id es igual a la id por parámetro)
    notifyListeners();
  }
}
