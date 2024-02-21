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
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseOperations {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  //Subir el canto-archivo
  static Future<void> agregarCanto(
      {required String nombre,
      required String categoria,
      required String rutaArchivo}) async {
    try {
      //Leer contenido del archivo
      final ByteData data = await rootBundle.load(rutaArchivo);
      final Uint8List bytes = data.buffer.asUint8List();

      //Subir el archivo a Firebase Storage
      var ref = _storage.ref().child(rutaArchivo);
      var uploadTask = ref.putData(bytes);

      //Esperar a que la subida se complete y obtener la URL de descarga
      var downloadURL = await (await uploadTask).ref.getDownloadURL();

      //Agregar canto a Firestore
      await _firestore.collection('cantos').add({
        'nombre': nombre,
        'categoria': categoria,
        'rutaArchivo': rutaArchivo,
        'urlArchivo': downloadURL, // URL de descarga del archivo
      });
    } catch (e) {
      print('Error al agregar canto: $e');
    }
  }

  //Consultar todos los cantos
  static Future<List<Map<String, dynamic>>> consultarTodosLosCantos() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('cantos').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error al consultar todos los cantos: $e');
      return [];
    }
  }

  //Consultar cantos por categoría
  static Future<List<Map<String, dynamic>>> consultarCantosPorCategoria(
      String categoria) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('cantos')
          .where('categoria', isEqualTo: categoria)
          .get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error al consultar cantos por categoria: $e');
      return [];
    }
  }

  //Editar un canto
  static Future<void> editarCanto(String id,
      {String? nombre, String? categoria}) async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          _firestore.collection('cantos').doc(id);
      final Map<String, dynamic> dataToUpdate = {};
      if (nombre != null) dataToUpdate['nombre'] = nombre;
      if (categoria != null) dataToUpdate['categoria'] = categoria;
      await docRef.update(dataToUpdate);
    } catch (e) {
      print('Error al editar canto: $e');
    }
  }
}
