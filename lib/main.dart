//**************************************************
//                                                 *
// __filename__   : main.dart                      *
// __author__     : JOSE DAVID TORRES GARCIA       *
// __description__: Archivo main, inicia la app    *
// __version__    : 1.0.0                          *
// __app__        : CANCIONERO RUAH                *
//                                                 *
//**************************************************

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
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

  print('Base de datos inicializada correctamente');

  runApp(MyApp(db: db));
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
