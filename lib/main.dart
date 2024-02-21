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
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'firebase_operaciones.dart';
import 'firebase_options.dart';
import 'modelos/modelos.dart';
import 'pantallas/pantallas.dart';

void main() async {
  //Asegurar la inicialización de los enlaces de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  //Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, //Utilizar las opciones predeterminadas
  );

  //Abrir la base de datos
  final db = await BaseDatos.initDatabase();

  //Cargar los cantos a la base de datos
  //await cargarCantos(db);

  print('Base de datos inicializada correctamente');

  runApp(MyApp(db: db));
}

//LOCAL
// Future<void> cargarCantosAgradecimiento(Database? db) async {
//   try {
//     String assetsPath = 'cantosDoc/Agradecimiento';
//     final manifestContent = await rootBundle.loadString('AssetManifest.json');
//     final Map<String, dynamic> manifestMap = json.decode(manifestContent);
//     final fileList =
//         manifestMap.keys.where((key) => key.startsWith(assetsPath)).toList();

//     //Iterar sobre los archivos y agregarlos a la base de datos
//     for (var file in fileList) {
//       var nombreArchivo = path.basenameWithoutExtension(file);
//       var categoria = 'agradecimiento';
//       var rutaArchivo = file;
//       var canto = Canto(
//         nombre: nombreArchivo,
//         categoria: categoria,
//         rutaArchivo: rutaArchivo,
//       );

//       await BaseDatos.insertarCanto(db!, canto);
//     }
//   } catch (e) {
//     print('Error al cargar los cantos: $e');
//   }
// }

//FIREBASE
Future<void> cargarCantos(Database? db) async {
  try {
    String assetsPath = 'cantosDoc/Villancico';
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final fileList =
        manifestMap.keys.where((key) => key.startsWith(assetsPath)).toList();

    //Iterar sobre los archivos y agregarlos a Firestore
    for (var file in fileList) {
      var nombreArchivo = path.basenameWithoutExtension(file);
      var categoria = 'villancico';
      var rutaArchivo = file;
      var canto = Canto(
        nombre: nombreArchivo,
        categoria: categoria,
        rutaArchivo: rutaArchivo,
      );

      await FirebaseOperations.agregarCanto(
        nombre: canto.nombre,
        categoria: canto.categoria,
        rutaArchivo: canto.rutaArchivo,
      );
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
