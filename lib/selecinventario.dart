import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SeleccionInventario extends StatefulWidget {
  @override
  _SeleccionInventarioState createState() => _SeleccionInventarioState();
}

class _SeleccionInventarioState extends State<SeleccionInventario> {
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
      "bloqueado": true,
      "colores": [
        Color.fromARGB(255, 255, 0, 0),
        Color.fromARGB(255, 255, 132, 0),
      ],
      "ruta": "/inventario_interes_ocupacional",
    },
    "Inventario de preferencias universitarias": {
      "imagen": "recursos/libro.png",
      "bloqueado": true,
      "colores": [
        Color.fromARGB(255, 255, 0, 0),
        Color.fromARGB(255, 255, 132, 0),
      ],
      "ruta": "/inventario_preferencias_universitarias",
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        arguments: {"info": inventarios[inventario]},
                      );
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
                                    "0 / 120",
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
                                      tag: "icono",
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
