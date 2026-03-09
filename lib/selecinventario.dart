import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mmpi_2/servicios/sesion_controlador.dart';
import 'package:mmpi_2/servicios/respuestas_hive.dart';

class SeleccionInventario extends StatefulWidget {
  @override
  _SeleccionInventarioState createState() => _SeleccionInventarioState();
}

class _SeleccionInventarioState extends State<SeleccionInventario> {
  @override
  void initState() {
    super.initState();
    if (!SesionControlador().estaEnLinea) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Estas iniciando como invitado, lo que significa que:"),
            content: Text(
              "• Tus respuestas solo se guardan en tu computadora \n • No podrás acceder a tus resultados desde otro dispositivo\n • El registro quedará pendiente \n • Respalda tus resultados siempre que puedas",
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Esta bien", style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarioId = SesionControlador().usuarioId;
    Map<String, dynamic> inventarios = {
      "Inventario de autoevaluacion de aptitudes": {
        "imagen": "recursos/cerebro.png",
        "bloqueado": false,
        "colores": [
          Color.fromARGB(255, 0, 177, 153),
          Color.fromARGB(255, 1, 132, 255),
        ],
        "ruta": "/inventario_autoevaluacion_aptitudes",
      },
      "Inventario de interes ocupacional": {
        "imagen": "recursos/tridente.png",
        "bloqueado": RepositorioDeRespuestas.obtenerCantidadRespuestasUsuarioYTipo(usuarioId, "/inventario_autoevaluacion_aptitudes") < 120,
        "colores": [
          Color.fromARGB(255, 255, 132, 0),
          Color.fromARGB(255, 255, 0, 0),
         
        ],
        "ruta": "/inventario_interes_ocupacional",
      },
      "Inventario de preferencias universitarias": {
        "imagen": "recursos/libro.png",
        "bloqueado": RepositorioDeRespuestas.obtenerCantidadRespuestasUsuarioYTipo(usuarioId, "/inventario_interes_ocupacional") < 120,
        "colores": [
          Color.fromARGB(255, 255, 0, 191),
          Color.fromARGB(255, 140, 0, 255),
        ],
        "ruta": "/inventario_preferencias_universitarias",
      },
    };
    return Scaffold(
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(minimumSize: Size(100,100), maximumSize: Size(100, 100), backgroundColor: const Color.fromARGB(255, 248, 33, 212)),
            onPressed: () {
        
            },
            child: Icon(Icons.settings, color: Colors.white, size: 30),
        
          
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: inventarios.keys.map((inventario) {
                return GestureDetector(
                  onTap: () {
                    if (!inventarios[inventario]["bloqueado"]) {
                      Navigator.pushNamed(
                        context,
                        inventarios[inventario]["ruta"],
                        arguments: {"info": <String, dynamic>{...inventarios[inventario]!, "titulo": inventario}},
                      ).then((_) => setState(() {}));
                    }
                  },
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      final escala = 0.9 + (0.1 * value);
                      return Opacity(
                        opacity: value >= 0 && value <= 1 ? value : 1,
                        child: Transform.scale(scale: escala, child: child),
                      );
                    },
                    child: Container(
                      constraints: BoxConstraints(
                        minWidth: 350,
                        minHeight: 400,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: inventarios[inventario]["bloqueado"]
                              ? [Colors.grey, Colors.blueGrey]
                              : inventarios[inventario]["colores"],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(55, 0, 0, 0),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          if (!inventarios[inventario]["bloqueado"])
                            Positioned(
                              top: 250,
                              child: Container(
                                height: 20,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(45),
                                  ),
                                ),
                                child: Center(
                                  child: AutoSizeText(
                                    "${RepositorioDeRespuestas.obtenerCantidadRespuestasUsuarioYTipo(SesionControlador().usuarioId, inventarios[inventario]["ruta"])} / 120",
                                    style: TextStyle(
                                      color:
                                          inventarios[inventario]["colores"][1],
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ),
                          Container(
                            width: 200,
                            padding: const EdgeInsets.all(8.0),
                            child: AutoSizeText(
                              inventario,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                              maxLines: 3,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Positioned(
                            top: 20,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 250,
                                minWidth: 250,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(20),
                              child: inventarios[inventario]["bloqueado"]
                                  ? Icon(
                                      Icons.lock,
                                      size: 150,
                                      color: Colors.grey,
                                    )
                                  : Hero(
                                      tag: inventarios[inventario]["ruta"],
                                    child: Image.asset(
                                        width: 150,
                                        height: 150,
                                        inventarios[inventario]["imagen"] ??
                                            "recursos/cerebro.png",
                                        color:
                                            inventarios[inventario]["bloqueado"]
                                            ? Colors.grey
                                            : inventarios[inventario]["colores"][0],
                                      ),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
