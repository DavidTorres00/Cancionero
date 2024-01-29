//**************************************************
//                                                 *
// __filename__   : main.dart                      *
// __author__     : JOSE DAVID TORRES GARCIA       *
// __description__: Archivo main, inicia la app    *
// __version__    : 1.0.0                          *
// __app__        : CANCIONERO RUAH                *
//                                                 *
//**************************************************

import 'package:flutter/material.dart';
import 'package:ruah/pantallas/pagina_lista_cantos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      home: const MyHomePage(title: 'Cancionero RUAH'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Primera columna de botones (izquierda)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildCardButton(
                      context, 'Alabanza', 'alabanza', 'images/entrada.jpeg'),
                  _buildCardButton(
                      context, 'Aleluya', 'aleluya', 'images/aleluya.jpeg'),
                  _buildCardButton(context, 'Canto a la Virgen', 'virgen',
                      'images/maria.jpeg'),
                  _buildCardButton(context, 'Canto al Espíritu Santo', 'santo',
                      'images/santo.jpeg'),
                  _buildCardButton(context, 'Canto de Adoración', 'adoracion',
                      'images/paz.jpeg'),
                  _buildCardButton(context, 'Canto de Adviento', 'adviento',
                      'images/accionGracias.jpeg'),
                  _buildCardButton(context, 'Canto de Agradecimiento',
                      'agradecimiento', 'images/salida.jpeg'),
                  _buildCardButton(context, 'Canto de Comunión', 'comunion',
                      'images/comunion.jpeg'),
                  _buildCardButton(context, 'Canto de Entrada', 'entrada',
                      'images/entrada.jpeg'),
                  _buildCardButton(context, 'Canto de Pascua', 'pascua',
                      'images/ofertorio.jpeg'),
                  _buildCardButton(context, 'Canto de Reflexión', 'reflexion',
                      'images/salmo.jpeg'),
                  _buildCardButton(context, 'Canto de Salida', 'salida',
                      'images/padrenuestro.jpeg'),
                ],
              ),
            ),
            //Segunda columna de botones (derecha)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildCardButton(context, 'Canto Ofertorio', 'ofertorio',
                      'images/ofertorio.jpeg'),
                  _buildCardButton(context, 'Canto para Boda', 'boda',
                      'images/procesion.jpeg'),
                  _buildCardButton(context, 'Canto para Difunto', 'difuntos',
                      'images/aleluya.jpeg'),
                  _buildCardButton(context, 'Canto para el Bautismo',
                      'bautismo', 'images/maria.jpeg'),
                  _buildCardButton(context, 'Canto para Primera Comunión',
                      'comunion', 'images/comunion.jpeg'),
                  _buildCardButton(context, 'Canto para XV años', 'xvanios',
                      'images/paz.jpeg'),
                  _buildCardButton(
                      context, 'Cantos', 'cantos', 'images/accionGracias.jpeg'),
                  _buildCardButton(context, 'Cantos para Navidad', 'navidad',
                      'images/salida.jpeg'),
                  _buildCardButton(context, 'Cordero de Dios', 'cordero',
                      'images/comunion.jpeg'),
                  _buildCardButton(context, 'Cuaresma y Semana Santa',
                      'cuaresma', 'images/entrada.jpeg'),
                  _buildCardButton(
                      context, 'Santo', 'santo', 'images/santo.jpeg'),
                  _buildCardButton(
                      context, 'Villancico', 'villancico', 'images/salmo.jpeg')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardButton(
      BuildContext context, String buttonText, String route, String imagePath) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          _navegarListaC(context, route);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 100.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                buttonText,
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

  void _navegarListaC(BuildContext context, String genero) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PagListaCan(genero: genero)),
    );
  }
}
