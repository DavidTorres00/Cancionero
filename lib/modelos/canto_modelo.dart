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
  final String? id;
  late String nombre;
  late String categoria;
  final String rutaArchivo;
  final String? urlArchivo;

  Canto({
    this.id,
    required this.nombre,
    required this.categoria,
    required this.rutaArchivo,
    this.urlArchivo,
  });

  //Método para convertir un objeto Canto en un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'categoria': categoria,
      'rutaArchivo': rutaArchivo,
      'urlArchivo': urlArchivo
    };
  }
}
