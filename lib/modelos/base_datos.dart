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
import 'canto_modelo.dart';

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

  static Future<void> insertarCanto(Database db, Canto canto) async {
    await db.insert(
      'cantos',
      canto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Canto>> listarCantos(Database db,
      {String? categoria}) async {
    List<Map<String, dynamic>> maps;
    if (categoria != null) {
      maps = await db
          .query('cantos', where: 'categoria = ?', whereArgs: [categoria]);
    } else {
      maps = await db.query('cantos');
    }

    return List.generate(maps.length, (i) {
      return Canto(
        id: maps[i]['id'],
        nombre: maps[i]['nombre'],
        categoria: maps[i]['categoria'],
        rutaArchivo: maps[i]['rutaArchivo'],
      );
    });
  }

  static Future<void> actualizarCanto(Database db, Canto canto) async {
    await db.update(
      'cantos',
      canto.toMap(),
      where: 'id = ?',
      whereArgs: [canto.id],
    );
  }

  static Future<void> eliminarCanto(Database db, id) async {
    await db.delete(
      'cantos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
