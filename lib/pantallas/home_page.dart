//**************************************************
//                                                 *
// __filename__   : home_page.dart                 *
// __author__     : JOSE DAVID TORRES GARCIA       *
// __description__: Muestra categorias y redic.    *
// __version__    : 1.0.0                          *
// __app__        : CANCIONERO RUAH                *
//                                                 *
//**************************************************

// ignore_for_file: prefer_const_constructors, library_prefixes, use_build_context_synchronously

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cancionero/pantallas/pantallas.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../firebase_operaciones.dart';
import 'package:cancionero/recurso/barra_busqueda.dart' as BarraBusqueda;
import 'package:http/http.dart' as http;

class PaginaPrincipal extends StatelessWidget {
  PaginaPrincipal({
    Key? key,
    required this.titulo,
    required this.db,
  }) : super(key: key);

  final String titulo;
  final Database? db;

  //Define los controladores
  final TextEditingController _controladorTexto = TextEditingController();
  final FocusNode _nodoEnfoque = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //Imagen que ocupa el 30% superior
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'imagenes/imagen_inicio.png',
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.cover,
            ),
          ),
          // Barra de búsqueda
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: BarraBusqueda.BarraBusqueda(
                  controladorTexto: _controladorTexto,
                  nodoEnfoqueCampoTexto: _nodoEnfoque,
                  onSearch: (terminoBusqueda) {
                    //Se ejecuta la búsqueda y se muestra el resultado
                    return _realizarBusqueda(context, terminoBusqueda);
                  },
                ),
              ),
            ),
          ),
          //Contenedor que ocupa el 70% inferior
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.3,
            child: FutureBuilder<List<Widget>>(
              future: _construirContenido(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                //Si todo está bien, muestra los widgets resultantes
                return SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: snapshot
                              .data!, //Usa los widgets que devuelve el futuro
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List?> leerContenidoCanto(String? urlArchivo) async {
    try {
      if (urlArchivo != null) {
        final http.Response response = await http.get(Uri.parse(urlArchivo));

        if (response.statusCode == 200) {
          return response.bodyBytes;
        }
      }
      return null;
    } catch (e) {
      //print('Error al cargar el contenido del archivo: $e');
      return null;
    }
  }

  Future<List<Widget>> _realizarBusqueda(
      BuildContext context, String searchTerm) async {
    try {
      //Realiza la consulta
      final List<Map<String, dynamic>> resultados =
          await FirebaseOperations.consultarCantosPorNombre(searchTerm);

      //Crea una lista de widgets para mostrar los resultados
      List<Widget> resultadosBusqueda = [];

      //Crea un widget interactivo para cada resultado y lo agrega a la lista
      if (resultados.isNotEmpty) {
        for (var resultado in resultados) {
          resultadosBusqueda.add(
            GestureDetector(
              onTap: () async {
                final contenido =
                    await leerContenidoCanto(resultado['urlArchivo']);
                if (contenido != null) {
                  showDialog(
                    context: context,
                    builder: (_) => SfPdfViewer.memory(contenido),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al abrir el archivo'),
                    ),
                  );
                }
              },
              child: Card(
                child: ListTile(
                  title: Text(resultado['nombre']),
                ),
              ),
            ),
          );
        }
      } else {
        resultadosBusqueda
            .add(Text('No se encontraron resultados para: $searchTerm'));
      }

      return resultadosBusqueda;
    } catch (e) {
      //print('Error al realizar la búsqueda: $e');
      return [];
    }
  }

  Future<List<Widget>> _construirContenido(BuildContext context) async {
    List<Widget> widgetsContenido = [];

    //Si no hay término de búsqueda, muestra los botones
    if (_controladorTexto.text.isEmpty) {
      widgetsContenido.addAll(_construirBotones(context));
    } else {
      //Espera a que se complete la búsqueda y agrega los resultados
      List<Widget> resultadosBusqueda =
          await _realizarBusqueda(context, _controladorTexto.text);
      widgetsContenido.addAll(resultadosBusqueda);
    }

    return widgetsContenido;
  }

  List<Widget> _construirBotones(BuildContext context) {
    return [
      _construirBotonTarjeta(
          context, 'Alabanza', 'alabanza', 'imagenes/entrada.jpeg', db),
      _construirBotonTarjeta(
          context, 'Aleluya', 'aleluya', 'imagenes/aleluya.jpeg', db),
      _construirBotonTarjeta(
          context, 'Canto a la Virgen', 'virgen', 'imagenes/maria.jpeg', db),
      _construirBotonTarjeta(context, 'Canto al Espíritu Santo', 'santo',
          'imagenes/santo.jpeg', db),
      _construirBotonTarjeta(
          context, 'Canto de Adoración', 'adoracion', 'imagenes/paz.jpeg', db),
      _construirBotonTarjeta(context, 'Canto de Adviento', 'adviento',
          'imagenes/accionGracias.jpeg', db),
      _construirBotonTarjeta(context, 'Canto de Agradecimiento',
          'agradecimiento', 'imagenes/salida.jpeg', db),
      _construirBotonTarjeta(context, 'Canto de Comunión', 'comunion',
          'imagenes/comunion.jpeg', db),
      _construirBotonTarjeta(
          context, 'Canto de Entrada', 'entrada', 'imagenes/entrada.jpeg', db),
      _construirBotonTarjeta(
          context, 'Canto de Pascua', 'pascua', 'imagenes/ofertorio.jpeg', db),
      _construirBotonTarjeta(context, 'Canto de Reflexión', 'reflexion',
          'imagenes/salmo.jpeg', db),
      _construirBotonTarjeta(context, 'Canto de Salida', 'salida',
          'imagenes/padrenuestro.jpeg', db),
      _construirBotonTarjeta(context, 'Canto Ofertorio', 'ofertorio',
          'imagenes/ofertorio.jpeg', db),
      _construirBotonTarjeta(
          context, 'Canto para Boda', 'boda', 'imagenes/procesion.jpeg', db),
      _construirBotonTarjeta(context, 'Canto para Difunto', 'difuntos',
          'imagenes/aleluya.jpeg', db),
      _construirBotonTarjeta(context, 'Canto para el Bautismo', 'bautismo',
          'imagenes/maria.jpeg', db),
      _construirBotonTarjeta(context, 'Canto para Primera Comunión', 'comunion',
          'imagenes/comunion.jpeg', db),
      _construirBotonTarjeta(
          context, 'Canto para XV años', 'xvanios', 'imagenes/paz.jpeg', db),
      _construirBotonTarjeta(
          context, 'Cantos', 'cantos', 'imagenes/accionGracias.jpeg', db),
      _construirBotonTarjeta(context, 'Cantos para Navidad', 'navidad',
          'imagenes/salida.jpeg', db),
      _construirBotonTarjeta(
          context, 'Cordero de Dios', 'cordero', 'imagenes/comunion.jpeg', db),
      _construirBotonTarjeta(context, 'Cuaresma y Semana Santa', 'cuaresma',
          'imagenes/entrada.jpeg', db),
      _construirBotonTarjeta(
          context, 'Santo', 'santo', 'imagenes/santo.jpeg', db),
      _construirBotonTarjeta(
          context, 'Villancico', 'villancico', 'imagenes/salmo.jpeg', db)
    ];
  }

  Widget _construirBotonTarjeta(BuildContext context, String textoBoton,
      String ruta, String rutaImagen, Database? db) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PagListaCan(genero: ruta, db: db),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 100.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(rutaImagen),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                textoBoton,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              color: Colors.grey[300],
              padding: const EdgeInsets.all(8.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Ver',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
