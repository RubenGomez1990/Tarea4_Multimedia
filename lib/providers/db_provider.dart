// Clase tipo Singleton para utilizar siempre la misma BBDD
import 'dart:io';

import 'package:path_provider/path_provider.dart';
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
}
