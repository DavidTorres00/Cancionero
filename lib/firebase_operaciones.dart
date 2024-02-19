//**************************************************
//                                                 *
// __filename__   : firebase_operaciones.dart      *
// __author__     : JOSE DAVID TORRES GARCIA       *
// __description__: Interactua con firebase cloud  *
// __version__    : 1.0.0                          *
// __app__        : CANCIONERO RUAH                *
//                                                 *
//**************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class FirebaseOperations {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> agregarCanto(
      {required String nombre,
      required String categoria,
      required String rutaArchivo}) async {
    try {
      // Leer contenido del archivo
      final ByteData data = await rootBundle.load(rutaArchivo);
      final Uint8List bytes = data.buffer.asUint8List();

      // Agregar canto a Firestore
      await _firestore.collection('cantos').add({
        'nombre': nombre,
        'categoria': categoria,
        'rutaArchivo': rutaArchivo,
        'bytes': bytes, // Incluir bytes en el documento
      });
    } catch (e) {
      print('Error al agregar canto: $e');
    }
  }

  // static Future<List<Map<String, dynamic>>> listarCantos(
  //     {String? categoria}) async {
  //   try {
  //     QuerySnapshot querySnapshot;
  //     if (categoria != null) {
  //       querySnapshot = await _firestore
  //           .collection('cantos')
  //           .where('categoria', isEqualTo: categoria)
  //           .get();
  //     } else {
  //       querySnapshot = await _firestore.collection('cantos').get();
  //     }
  //     return querySnapshot.docs.map((doc) => doc.data()).toList();
  //   } catch (e) {
  //     print('Error al listar cantos: $e');
  //     return [];
  //   }
  // }

  // Otros métodos para actualizar, eliminar, etc.
}
