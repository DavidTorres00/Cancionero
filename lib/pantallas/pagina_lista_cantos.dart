import 'package:flutter/material.dart';

class PagListaCan extends StatelessWidget {
  final String genero;

  const PagListaCan({Key? key, required this.genero}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cantos de $genero'),
      ),
      body: Center(
        child: Text('Aquí irá la lista de canciones de $genero'),
      ),
    );
  }
}
