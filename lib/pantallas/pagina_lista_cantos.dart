//**************************************************
//                                                 *
// __filename__   : pagina_lista_canto.dart        *
// __author__     : JOSE DAVID TORRES GARCIA       *
// __description__: Listo los cantos por categoria *
// __version__    : 1.0.0                          *
// __app__        : CANCIONERO RUAH                *
//                                                 *
//**************************************************

// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import '../modelos/modelos.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PagListaCan extends StatefulWidget {
  final String genero;
  final Database? db;

  const PagListaCan({Key? key, required this.genero, this.db})
      : super(key: key);

  @override
  _PagListaCanState createState() => _PagListaCanState();
}

class _PagListaCanState extends State<PagListaCan> {
  List<Canto> _cantos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCantosPorGenero();
  }

  Future<void> _getCantosPorGenero() async {
    final List<Canto> cantos =
        await BaseDatos.listarCantos(widget.db!, categoria: widget.genero);
    setState(() {
      _cantos = cantos;
      _isLoading = false;
    });
  }

  Future<Uint8List?> leerContenidoCanto(String rutaArchivo) async {
    try {
      //Cargar el contenido del archivo desde los activos de la aplicación
      ByteData data = await rootBundle.load(rutaArchivo);
      return data.buffer.asUint8List();
    } catch (e) {
      //Mostrar un SnackBar con el mensaje de error
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cantos de ${widget.genero}'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _cantos.isEmpty
                ? const Text('No hay cantos en esta categoría')
                : Column(
                    children: [
                      for (var canto in _cantos)
                        ListTile(
                          title: Text(canto.nombre),
                          subtitle: Text(canto.categoria),
                          onTap: () async {
                            final contenido =
                                await leerContenidoCanto(canto.rutaArchivo);
                            if (contenido != null) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SfPdfViewer.memory(contenido),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error al abrir el archivo'),
                                ),
                              );
                            }
                          },
                        ),
                    ],
                  ),
      ),
    );
  }
}
