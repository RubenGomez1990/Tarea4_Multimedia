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
    if (_database == null)
      _database =
          await initDB(); // Si está inicializada la devuelve si no, espera a que se inicialice.
    return _database!;
  }

  //initDB será el método que crea las tablas e inicializa los datos de la BBDD
  Future<Database> initDB() async {
    // Obtener el path
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'Scans.db');
    print(path);

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

  // Hace lo mismo pero utilizando la librería sqflite.
  Future<int> insertScan(ScanModel scanNuevo) async {
    final db = await database;
    //Pide el nombre de la tabla scan y un mapa
    final res = await db.insert('Scans', scanNuevo.toMap());
    print(res);
    return res;
  }
}
