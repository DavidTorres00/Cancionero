//**************************************************
//                                                 *
// __filename__   : main.dart                      *
// __author__     : JOSE DAVID TORRES GARCIA       *
// __description__: Archivo main, inicia la app    *
// __version__    : 1.0.0                          *
// __app__        : CANCIONERO RUAH                *
//                                                 *
//**************************************************

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'modelos/modelos.dart';
import 'pantallas/pantallas.dart';

void main() async {
  //Asegurar la inicialización de los enlaces de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  //Abrir la base de datos
  final db = await BaseDatos.initDatabase();

  //Cargar los cantos de agradecimiento a la base de datos
  //await cargarCantosAgradecimiento(db);

  print('Base de datos inicializada correctamente');

  runApp(MyApp(db: db));
}

Future<void> cargarCantosAgradecimiento(Database? db) async {
  try {
    String assetsPath = 'cantosDoc/Agradecimiento';
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final fileList =
        manifestMap.keys.where((key) => key.startsWith(assetsPath)).toList();

    //Iterar sobre los archivos y agregarlos a la base de datos
    for (var file in fileList) {
      var nombreArchivo = path.basenameWithoutExtension(file);
      var categoria = 'agradecimiento';
      var rutaArchivo = file;
      var canto = Canto(
        nombre: nombreArchivo,
        categoria: categoria,
        rutaArchivo: rutaArchivo,
      );

      await BaseDatos.insertarCanto(db!, canto);
    }
  } catch (e) {
    print('Error al cargar los cantos: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.db}) : super(key: key);

  final Database? db;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RUAH CANCIONERO',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepPurple.shade900),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Cancionero RUAH', db: db),
    );
  }
}
