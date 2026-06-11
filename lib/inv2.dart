import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mmpi_2/servicios/controlador_hive.dart';
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
  List<int> respuestas = [];
  List<String> interesesFavoritos = [];

  @override
  void initState() {
      super.initState();
      intereses = todoslosintereses();
      respuestas = ControladorHive.obtRespuestasPorTipo("/inventario_preferencias_universitarias")
          .map((r) => r.preguntaID)
          .toList();
      final lista = List<int>.filled(60, -1);
      for (final r in ControladorHive.obtRespuestasPorTipo("/inventario_preferencias_universitarias")) {
        if (r.preguntaID >= 0 && r.preguntaID < 60) {
          lista[r.preguntaID] = int.tryParse(r.respuesta) ?? -1;
        }
      }
      final puntajes = calcularPuntajesIntereses(lista);
      int puntajealto = 0;
      if (puntajes.isNotEmpty) {
        for (final puntaje in puntajes.entries) {
          if (puntaje.value >= puntajealto) {
            puntajealto = puntaje.value;
          }
        }
        interesesFavoritos = puntajes.entries
            .where((puntaje) => puntaje.value == puntajealto)
            .map((puntaje) => puntaje.key)
            .toList();
      }
  }

  @override
  Widget build(BuildContext context) {

    double ancho = MediaQuery.of(context).size.width;
    double alto = MediaQuery.of(context).size.height;
    final esMobile = ancho < 600;

    return Scaffold(
      body: Stack(
        children: [
        Container(
          alignment: Alignment.center,
decoration: const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
                    const Color.fromARGB(255, 58, 123, 183),
                    const Color.fromARGB(255, 0, 177, 153),
    ],
  ),
),
          width: double.infinity,
          height: double.infinity,

            
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                              Flexible(
                                flex: 1,
                                child: AutoSizeText(
                                                  'Elige un interes',
                                                  style: TextStyle(
                                                    fontSize: esMobile ? 16.0 : 60.0,
                                                    color: const Color.fromARGB(255, 255, 255, 255),
                                                    fontWeight: FontWeight.bold,
                                                  ),),
                              ),
                  Flexible(
                    flex: 3,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                     
                        padding: const EdgeInsets.all(4.0),
                    
                                  
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(100, 219, 219, 219),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                            
                        child: SingleChildScrollView(
                          child: 
                          determinarTipoPantalla(ancho, alto) == tipoPantalla.paisaje
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var inte in intereses.entries)
                                BotonInteres(interesKey: inte.key, interesData: inte.value, infoinventario: infoinventario, interesesFavoritos: interesesFavoritos),
                            ],
                          )
                          : Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 4.0,
                            runSpacing: 4.0,
                            children: [
                              for (var inte in intereses.entries)
                                BotonInteres(interesKey: inte.key, interesData: inte.value, infoinventario: infoinventario, interesesFavoritos: interesesFavoritos),
                            ],
                          ),
                        ),
                    ),
                  )
                ]
                      ),
            
                  
                
                ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color.fromARGB(80, 0, 0, 0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.maybePop(context),
                ),
              ),
            ),
          ),
        ],
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
  });

  final String interesKey;
  final Map<String, dynamic> interesData;
  final Map<String, Map<String, Object>> infoinventario;
  final List<String> interesesFavoritos;

  @override
  State<BotonInteres> createState() => _BotonInteresState();
}

class _BotonInteresState extends State<BotonInteres> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _borderWidth;
  bool _isHovered = false;

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
    final ancho = MediaQuery.of(context).size.width;
    final alto = MediaQuery.of(context).size.height;
    final esMobile = ancho < 600;
    final tamanoBoton = calcularTamanoBoton(ancho, alto);
    final esFavorito = widget.interesesFavoritos.contains(widget.interesKey);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/${widget.interesKey}", arguments: {"info": <String, dynamic>{...widget.infoinventario["Inventario de interes"]!,"titulo": widget.interesData["nombre"], "key": widget.interesKey, "rangocalificacion": widget.interesData["rangocalificacion"]}});
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: AnimatedBuilder(
        animation: _borderWidth,
        builder: (context, child) {
          return Container(
            width: tamanoBoton,
            height: tamanoBoton,
            child: Stack(
              fit: StackFit.expand,
              children: [

                Container(
                  key: ValueKey(widget.interesKey),
                  decoration: BoxDecoration(
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
                  child: child,
                ),

                IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: esFavorito
                            ? const Color.fromARGB(255, 255, 200, 0)
                            : const Color.fromARGB(100, 175, 175, 175),
                        width: esFavorito ? _borderWidth.value : 1,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(child: Icon(widget.interesData["icono"] as IconData, size: tamanoBoton * 0.9, color: const Color.fromARGB(40, 255, 255, 255),)),
                    ),
              ],
            ),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

                      Container(
                        alignment: Alignment.center,
                        height: tamanoBoton * 0.3,
                         margin: EdgeInsets.only(bottom: esMobile ? 4.0 : 8.0),
                        child: Text(
                          
                          textAlign: TextAlign.center,
                          widget.interesKey,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                            fontSize: tamanoBoton * 0.15,
                          ),
                          
                        ),
                      ),
                    

                     Container(
                        width: double.infinity,
                        height: tamanoBoton * 0.1,
                        color: const Color.fromARGB(100, 255, 255, 255),
                        child: AutoSizeText(
                          textAlign: TextAlign.center,
                          minFontSize: 6,
                          maxLines: 1,
                          widget.interesData["nombre"] as String,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      
                    ),

                     Container(
                        height: tamanoBoton * 0.4,
                        child: AutoSizeText(
                          maxLines: 3,
                          minFontSize: 2,
                          widget.interesData["descripcion"] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.normal,
                          ),
                        
                      ),
                    ) 
                  ],
          )
                        
                      
                 
        )
      ),
        ),
        ),
      ),
    );
  }
}

double calcularTamanoBoton(double ancho, double alto) {
  tipoPantalla tipo = determinarTipoPantalla(ancho, alto);

  if (tipo == tipoPantalla.portada) { 
    return ancho * 0.30;
  } else if (tipo == tipoPantalla.semicuadrado) {
    return alto * 0.20;
  } else {
    return ancho * 0.12;
  }
} 

enum tipoPantalla{
  portada,
  semicuadrado,
  paisaje
}

tipoPantalla determinarTipoPantalla(double ancho, double alto) {
  double diferencia = 100; // Umbral para considerar la pantalla como "casi cuadrada"
  if (ancho < alto && (ancho - alto).abs() < diferencia) {
    return tipoPantalla.portada;
  } else if (ancho > alto && (ancho - alto).abs() >= diferencia) {
    return tipoPantalla.paisaje;
  } else if ((ancho - alto).abs() < diferencia) {
    return tipoPantalla.semicuadrado;
  } else {
    return tipoPantalla.semicuadrado;
  }
}