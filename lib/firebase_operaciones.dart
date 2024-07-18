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
import 'package:remove_diacritic/remove_diacritic.dart';

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
        'urlArchivo': downloadURL, //URL de descarga del archivo
      });
    } catch (e) {
      //print('Error al agregar canto: $e');
    }
  }

  //Consultar todos los cantos
  static Future<List<Map<String, dynamic>>> consultarTodosLosCantos() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('cantos').get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['Document ID'] = doc.id; //Agrega el Document ID al mapa de datos
        return data;
      }).toList();
    } catch (e) {
      //print('Error al consultar todos los cantos: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> consultarCantosPorNombre(
      String nombre) async {
    try {
      //Convierte el nombre a minúsculas y elimina los espacios iniciales o finales
      nombre = nombre.trim().toLowerCase();

      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('cantos').get();

      //Filtra los documentos en memoria para encontrar aquellos que coincidan con el nombre modificado
      List<Map<String, dynamic>> resultados = querySnapshot.docs
          .map((doc) => doc.data())
          .where((data) => _compararNombres(data['nombre'], nombre))
          .toList();

      //Mapea cada documento a un mapa de datos que incluye el ID del documento
      return resultados.map((data) {
        QueryDocumentSnapshot<Map<String, dynamic>>? docRef;
        for (var doc in querySnapshot.docs) {
          if (_compararNombres(doc.data()['nombre'], nombre)) {
            docRef = doc;
            break;
          }
        }
        if (docRef != null) {
          data['ID del Documento'] =
              docRef.id; //Agrega el ID del documento al mapa de datos
        }
        return data;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  //Función para comparar dos nombres teniendo en cuenta los acentos y los espacios entre palabras
  static bool _compararNombres(String nombre1, String nombre2) {
    //Normaliza las cadenas de caracteres para ignorar las diferencias de acentos
    final nombreNormalizado1 = _normalizarCadena(nombre1);
    final nombreNormalizado2 = _normalizarCadena(nombre2);
    //Compara las cadenas normalizadas
    return nombreNormalizado1 == nombreNormalizado2;
  }

  //Normalizar una cadena de caracteres y eliminar las diferencias de acentos
  static String _normalizarCadena(String input) {
    return removeDiacritics(input.trim().toLowerCase());
  }

  //Consultar cantos por categoría
  static Future<List<Map<String, dynamic>>> consultarCantosPorCategoria(
      String categoria) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('cantos')
          .where('categoria', isEqualTo: categoria)
          .get();

      //Mapea cada documento a un mapa de datos que incluye el Document ID
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['Document ID'] = doc.id; //Agrega el Document ID al mapa de datos
        return data;
      }).toList();
    } catch (e) {
      //print('Error al consultar cantos por categoria: $e');
      return [];
    }
  }

  //Editar un canto
  static Future<void> editarCanto(String? id,
      {String? nombre, String? categoria}) async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          _firestore.collection('cantos').doc(id);
      final Map<String, dynamic> dataToUpdate = {};
      if (nombre != null) dataToUpdate['nombre'] = nombre;
      if (categoria != null) dataToUpdate['categoria'] = categoria;
      await docRef.update(dataToUpdate);
    } catch (e) {
      //print('Error al editar canto: $e');
    }
  }

  //Eliminar
  static Future<void> eliminarCanto(String? id) async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          _firestore.collection('cantos').doc(id);
      await docRef.delete();
    } catch (e) {
      //print('Error al eliminar canto: $e');
    }
  }
}
