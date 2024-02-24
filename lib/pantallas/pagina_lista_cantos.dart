//**************************************************
//                                                 *
// __filename__   : pagina_lista_canto.dart        *
// __author__     : JOSE DAVID TORRES GARCIA       *
// __description__: Listo los cantos por categoria *
// __version__    : 1.0.0                          *
// __app__        : CANCIONERO RUAH                *
//                                                 *
//**************************************************

// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;
import '../firebase_operaciones.dart';
import '../modelos/modelos.dart';

class PagListaCan extends StatefulWidget {
  final String genero;
  final Database? db;

  const PagListaCan({Key? key, required this.genero, required this.db})
      : super(key: key);

  @override
  _PagListaCanState createState() => _PagListaCanState();
}

class _PagListaCanState extends State<PagListaCan> {
  late Future<List<Canto>> _cantosFuture;

  @override
  void initState() {
    super.initState();
    _cantosFuture =
        FirebaseOperations.consultarCantosPorCategoria(widget.genero)
            .then((cantos) => cantos
                .map(
                  (canto) => Canto(
                    id: canto['Document ID'] ?? '',
                    nombre: canto['nombre'] ?? '',
                    categoria: canto['categoria'] ?? '',
                    rutaArchivo: canto['rutaArchivo'] ?? '',
                    urlArchivo: canto['urlArchivo'],
                  ),
                )
                .toList());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cantos de ${widget.genero}'),
      ),
      body: FutureBuilder<List<Canto>>(
        future: _cantosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los cantos'));
          } else if (snapshot.data!.isEmpty) {
            return Center(child: Text('No hay cantos en esta categoría'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final canto = snapshot.data![index];
                return ListTile(
                  title: Text(canto.nombre),
                  // subtitle: Text(canto.categoria),
                  onTap: () async {
                    final contenido =
                        await leerContenidoCanto(canto.urlArchivo);
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
                  onLongPress: () => _mostrarMenuEmergente(context, canto),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _mostrarMenuEmergente(BuildContext context, Canto canto) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        overlay.localToGlobal(overlay.paintBounds.topLeft, ancestor: overlay),
        overlay.localToGlobal(overlay.paintBounds.bottomRight,
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          child: Text('Editar'),
          onTap: () => _editarCanto(context, canto),
        ),
        PopupMenuItem(
          child: Text('Eliminar'),
          onTap: () => _eliminarCanto(
            context,
            canto,
          ),
        ),
      ],
    );
  }

  void _actualizarCantos() {
    setState(() {
      _cantosFuture =
          FirebaseOperations.consultarCantosPorCategoria(widget.genero).then(
        (cantos) => cantos
            .map(
              (canto) => Canto(
                id: canto['Document ID'] ?? '',
                nombre: canto['nombre'] ?? '',
                categoria: canto['categoria'] ?? '',
                rutaArchivo: canto['rutaArchivo'] ?? '',
                urlArchivo: canto['urlArchivo'],
              ),
            )
            .toList(),
      );
    });
  }

  void _editarCanto(BuildContext context, Canto canto) async {
    String? nuevoNombre = canto.nombre;
    String? nuevaCategoria = canto.categoria;

    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Editar Canto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Nombre'),
              controller: TextEditingController(text: canto.nombre),
              onChanged: (value) => nuevoNombre = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Categoría'),
              controller: TextEditingController(text: canto.categoria),
              onChanged: (value) => nuevaCategoria = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await FirebaseOperations.editarCanto(canto.id,
                    nombre: nuevoNombre, categoria: nuevaCategoria);
                Navigator.pop(context);
                _actualizarCantos();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al editar el canto'),
                  ),
                );
              }
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _eliminarCanto(BuildContext context, Canto canto) async {
    try {
      await FirebaseOperations.eliminarCanto(canto.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Canto eliminado'),
        ),
      );
      _actualizarCantos();
    } catch (e) {
      //print('Error al eliminar el canto: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el canto'),
        ),
      );
    }
  }
}
