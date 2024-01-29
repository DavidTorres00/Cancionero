//**************************************************
//                                                 *
// __filename__   : base_datos.dart                *
// __author__     : JOSE DAVID TORRES GARCIA       *
// __description__: Modelo base de datos SQLite    *
// __version__    : 1.0.0                          *
// __app__        : CANCIONERO RUAH                *
//                                                 *
//**************************************************

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BaseDatos {
  static Database? _database;

  static Future<Database?> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database;
  }

  static Future<Database?> initDatabase() async {
    String path = join(await getDatabasesPath(), 'cantos_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
             CREATE TABLE cantos (
               id INTEGER PRIMARY KEY,
               nombre TEXT,
               categoria TEXT,
               rutaArchivo TEXT
             )
           ''');
      },
    );
  }
}
