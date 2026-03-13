// Clase tipo Singleton para utilizar siempre la misma BBDD
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  static Database? _database; // Variable que almacena la conexión
  static final DBProvider db = DBProvider
      ._(); // Instancia de DBProvider privada almacenada en db para siempre llamar a la misma

  DBProvider._(); // Constructor privado

  // Getter asíncrono para interactuar con la BBDD
  Future<Database> get database async {
    _database ??= // Usamos ??= si _database es null (variable a la izquierda), espera a initDB y asigna resultado de la derecha. Si no, ignora el initDB()
        await initDB(); // Si está inicializada la devuelve si no, espera a que se inicialice.
    return _database!;
  }

  //initDB será el método que crea las tablas e inicializa los datos de la BBDD
  Future<Database> initDB() async {
    // Obtener el path
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'Scans.db');

    // Creación de la BBDD. La primera vez la creará y las siguientes obtendrá la instancia creada según la version.
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE Scans(
          id INTEGER PRIMARY KEY,
          tipus TEXT,
          valor TEXT
        )
      ''');
    });
  }

  // Devuelve un Future<int> que será la ID del registro que se ha insertado
  Future<int> inserRawScan(ScanModel scanNuevo) async {
    // Se obtienen las propiedades del objeto
    final id = scanNuevo.id;
    final tipus = scanNuevo.tipus;
    final valor = scanNuevo.valor;

    // Esperamos que la DB esté lista
    final db = await database;

    // Sentencia SQL
    final res = await db.rawInsert('''
      INSERT INTO Scans(id, tipus, valor)
        VALUES ($id, $tipus, $valor)
      ''');
    return res; // Devuelve el ID del último registro insertado
  }

  // Hace lo mismo pero utilizando la librería sqflite y no en crudo.
  Future<int> insertScan(ScanModel scanNuevo) async {
    final db = await database;
    //Pide el nombre de la tabla scan y un mapa
    final res = await db.insert('Scans', scanNuevo.toMap());
    return res;
  }

  // Recupera la lista de scans. El future tiene que recibir la lista futura.
  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    final res = await db.query('Scans');
    return res.isNotEmpty
        ? res.map((e) => ScanModel.fromMap(e)).toList()
        : []; // Si res no está vacío, mapeamos cada fila a una lista, si no la devuelve vacía
  }

  // Devuelve un Scan por su ID
  Future<ScanModel?> getScanById(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [
      id
    ]); // Where (condición), whereArgs (el argumento que utiliza para la condición)

    if (res.isNotEmpty) {
      return ScanModel.fromMap(res
          .first); // devuelve el primer elemento de la lista que tenga el argumento id
    } else {
      return null;
    }
  }

  // Devuelve una lista de Scans por tipus.
  Future<List<ScanModel>> getScanByTipus(String tipus) async {
    // Importante indicar que es una lista futura.
    final db = await database;
    final res = await db.query('Scans', where: 'tipus = ?', whereArgs: [tipus]);

    return res.isNotEmpty
        ? res.map((e) => ScanModel.fromMap(e)).toList()
        : []; // Hacemos la condición así porque tiene que mapearlo a una lista.
  }

  // Actualiza un Scan recibiendo por parámetro un scan nuevo.
  Future<int> updateScan(ScanModel scanNuevo) async {
    final db = await database;
    final res = db.update('Scans', scanNuevo.toMap(),
        where: 'id = ?', whereArgs: [scanNuevo.id]);

    return res;
  }

  // Borra un scan por su id. Como solo es una operación de borrado devolverá el resultado final de filas borradas.
  Future<int> deleteById(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  // Borra todos los scans
  Future<int> deleteAllScans() async {
    final db = await database;
    final res = db.rawDelete('''
    DELETE FROM Scans
  ''');
    return res;
  }
}
