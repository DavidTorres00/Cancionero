//**************************************************
//                                                 *
// __filename__   : canto_modelo.dart              *
// __author__     : JOSE DAVID TORRES GARCIA       *
// __description__: Modelo de los cantos           *
// __version__    : 1.0.0                          *
// __app__        : CANCIONERO RUAH                *
//                                                 *
//**************************************************

class Canto {
  final int? id;
  final String nombre;
  final String categoria;
  final String rutaArchivo;

  Canto(
      {this.id,
      required this.nombre,
      required this.categoria,
      required this.rutaArchivo});

  //Método para convertir un objeto Canto en un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'categoria': categoria,
      'rutaArchivo': rutaArchivo,
    };
  }
}
