//**************************************************
//                                                 *
// __filename__   : home_page.dart                 *
// __author__     : JOSE DAVID TORRES GARCIA       *
// __description__: Muestra categorias y redic.    *
// __version__    : 1.0.0                          *
// __app__        : CANCIONERO RUAH                *
//                                                 *
//**************************************************

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ruah/pantallas/pantallas.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title, required this.db})
      : super(key: key);

  final String title;
  final Database? db;

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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildButtons(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    return [
      _buildCardButton(
          context, 'Alabanza', 'alabanza', 'images/entrada.jpeg', db),
      _buildCardButton(
          context, 'Aleluya', 'aleluya', 'images/aleluya.jpeg', db),
      _buildCardButton(
          context, 'Canto a la Virgen', 'virgen', 'images/maria.jpeg', db),
      _buildCardButton(
          context, 'Canto al Espíritu Santo', 'santo', 'images/santo.jpeg', db),
      _buildCardButton(
          context, 'Canto de Adoración', 'adoracion', 'images/paz.jpeg', db),
      _buildCardButton(context, 'Canto de Adviento', 'adviento',
          'images/accionGracias.jpeg', db),
      _buildCardButton(context, 'Canto de Agradecimiento', 'agradecimiento',
          'images/salida.jpeg', db),
      _buildCardButton(
          context, 'Canto de Comunión', 'comunion', 'images/comunion.jpeg', db),
      _buildCardButton(
          context, 'Canto de Entrada', 'entrada', 'images/entrada.jpeg', db),
      _buildCardButton(
          context, 'Canto de Pascua', 'pascua', 'images/ofertorio.jpeg', db),
      _buildCardButton(
          context, 'Canto de Reflexión', 'reflexion', 'images/salmo.jpeg', db),
      _buildCardButton(
          context, 'Canto de Salida', 'salida', 'images/padrenuestro.jpeg', db),
      _buildCardButton(
          context, 'Canto Ofertorio', 'ofertorio', 'images/ofertorio.jpeg', db),
      _buildCardButton(
          context, 'Canto para Boda', 'boda', 'images/procesion.jpeg', db),
      _buildCardButton(
          context, 'Canto para Difunto', 'difuntos', 'images/aleluya.jpeg', db),
      _buildCardButton(context, 'Canto para el Bautismo', 'bautismo',
          'images/maria.jpeg', db),
      _buildCardButton(context, 'Canto para Primera Comunión', 'comunion',
          'images/comunion.jpeg', db),
      _buildCardButton(
          context, 'Canto para XV años', 'xvanios', 'images/paz.jpeg', db),
      _buildCardButton(
          context, 'Cantos', 'cantos', 'images/accionGracias.jpeg', db),
      _buildCardButton(
          context, 'Cantos para Navidad', 'navidad', 'images/salida.jpeg', db),
      _buildCardButton(
          context, 'Cordero de Dios', 'cordero', 'images/comunion.jpeg', db),
      _buildCardButton(context, 'Cuaresma y Semana Santa', 'cuaresma',
          'images/entrada.jpeg', db),
      _buildCardButton(context, 'Santo', 'santo', 'images/santo.jpeg', db),
      _buildCardButton(
          context, 'Villancico', 'villancico', 'images/salmo.jpeg', db)
    ];
  }

  Widget _buildCardButton(BuildContext context, String buttonText, String route,
      String imagePath, Database? db) {
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
              builder: (context) => PagListaCan(genero: route, db: db),
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
}
