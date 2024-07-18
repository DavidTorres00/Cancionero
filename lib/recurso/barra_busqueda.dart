//**************************************************
//                                                 *
// __filename__   : barra_busqueda.dart            *
// __author__     : JOSE DAVID TORRES GARCIA       *
// __description__: Barra de búsqueda              *
// __version__    : 1.0.0                          *
// __app__        : CANCIONERO RUAH                *
//                                                 *
//**************************************************

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class BarraBusqueda extends StatelessWidget {
  final TextEditingController controladorTexto;
  final FocusNode nodoEnfoqueCampoTexto;
  final Function(String) onSearch; //Función de búsqueda

  const BarraBusqueda({
    super.key,
    required this.controladorTexto,
    required this.nodoEnfoqueCampoTexto,
    required this.onSearch, //Agrega la función de búsqueda
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 27),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white54,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  //Llama a la función de búsqueda con el término de búsqueda actual
                  onSearch(controladorTexto.text);
                },
                child: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 24,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, bottom: 2),
                  child: TextFormField(
                    controller: controladorTexto,
                    focusNode: nodoEnfoqueCampoTexto,
                    onFieldSubmitted: (_) async {
                      //Llama a la función de búsqueda con el término de búsqueda actual
                      onSearch(controladorTexto.text);
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Buscar canto...',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
