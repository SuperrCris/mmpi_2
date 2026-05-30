import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mmpi_2/servicios/sesion_controlador.dart';
import 'package:mmpi_2/utilidades/repositoriopreguntas.dart';

class inventario2 extends StatefulWidget {
  final String tipoInventario;
  final String tipo;

  const inventario2({Key? key, required this.tipoInventario, required this.tipo}) : super(key: key);

  @override
  _inventario2State createState() => _inventario2State();
}

class _inventario2State extends State<inventario2> {
  late Map<String, Map<String, dynamic>> intereses;
    final infoinventario =   {    "Inventario de interes": {
        "imagen": "recursos/tridente.png",
        "colores": [
          Color.fromARGB(255, 255, 132, 0),
          Color.fromARGB(255, 255, 0, 0),
        ],
        "ruta": "/inventario_interes_ocupacional",
      }};
  List<String> interesesFavoritos = ["FM","A"];

  @override
  void initState() {
      super.initState();
      intereses = todoslosintereses();
  }

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final alto = MediaQuery.of(context).size.height;
    final esMobile = ancho < 600;
    final esLandscape = ancho > alto;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 58, 123, 183),
              Color.fromARGB(255, 0, 177, 153),
            ],
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: esMobile ? 12.0 : 24.0,
                  horizontal: esMobile ? 8.0 : 16.0,
                ),
                child: AutoSizeText(
                  'Elige un interes',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: esMobile ? 36 : 60,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(
                  vertical: esMobile ? 6.0 : 10.0,
                  horizontal: esMobile ? 4.0 : 16.0,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(100, 219, 219, 219),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    for (var inte in intereses.entries)
                      BotonInteres(
                        interesKey: inte.key,
                        interesData: inte.value,
                        infoinventario: infoinventario,
                        interesesFavoritos: interesesFavoritos,
                        esMobile: esMobile,
                        esLandscape: esLandscape,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BotonInteres extends StatefulWidget {
  const BotonInteres({
    super.key,
    required this.interesKey,
    required this.interesData,
    required this.infoinventario,
    required this.interesesFavoritos,
    required this.esMobile,
    required this.esLandscape,
  });

  final String interesKey;
  final Map<String, dynamic> interesData;
  final Map<String, Map<String, Object>> infoinventario;
  final List<String> interesesFavoritos;
  final bool esMobile;
  final bool esLandscape;

  @override
  State<BotonInteres> createState() => _BotonInteresState();
}

class _BotonInteresState extends State<BotonInteres> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _borderWidth;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _borderWidth = Tween<double>(begin: 1.0, end: 5.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.interesesFavoritos.contains(widget.interesKey)) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final esFavorito = widget.interesesFavoritos.contains(widget.interesKey);
    final double tamanoBoton = widget.esMobile
        ? (widget.esLandscape ? 110 : 130)
        : 200;
    final double tamanoIcono = widget.esMobile ? 22 : 32;
    final double tamanoFuenteClave = widget.esMobile ? 28 : 40;
    final double tamanoFuenteNombre = widget.esMobile ? 9 : 12;
    final double tamanoFuenteDesc = widget.esMobile ? 8 : 12;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/${widget.interesKey}", arguments: {"info": <String, dynamic>{...widget.infoinventario["Inventario de interes"]!,"titulo": widget.interesData["nombre"], "key": widget.interesKey, "rangocalificacion": widget.interesData["rangocalificacion"]}});
      },
      child: AnimatedBuilder(
        animation: _borderWidth,
        builder: (context, child) {
          return Container(
            margin: EdgeInsets.symmetric(
              vertical: widget.esMobile ? 5 : 8,
              horizontal: widget.esMobile ? 5 : 8,
            ),
            constraints: BoxConstraints(
              minHeight: 10,
              maxHeight: tamanoBoton,
              minWidth: 10,
              maxWidth: tamanoBoton,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: esFavorito
                    ? const Color.fromARGB(255, 255, 200, 0)
                    : const Color.fromARGB(100, 175, 175, 175),
                width: esFavorito ? _borderWidth.value : 1,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 43, 177, 255),
                  Color.fromARGB(255, 127, 113, 255),
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            key: ValueKey(widget.interesKey),
            child: child,
          );
        },
        child: Center(
          child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      margin: const EdgeInsets.only(bottom: 4.0),
                      child: Icon(widget.interesData["icono"] as IconData, color: Colors.white, size: tamanoIcono),
                    ),
                    AutoSizeText(
                      textAlign: TextAlign.center,
                      maxFontSize: tamanoFuenteClave,
                      widget.interesKey,
                      style: TextStyle(
                        fontSize: tamanoFuenteClave,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AutoSizeText(
                      textAlign: TextAlign.center,
                      maxFontSize: tamanoFuenteNombre,
                      widget.interesData["nombre"] as String,
                      style: TextStyle(
                        fontSize: tamanoFuenteNombre,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(widget.esMobile ? 4.0 : 8.0),
                      child: AutoSizeText(
                        widget.interesData["descripcion"] as String,
                        textAlign: TextAlign.center,
                        maxLines: widget.esMobile ? 2 : 4,
                        style: TextStyle(
                          fontSize: tamanoFuenteDesc,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.normal,
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