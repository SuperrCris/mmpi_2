import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mmpi_2/servicios/sesion_controlador.dart';
import 'package:mmpi_2/servicios/controlador_hive.dart';
import 'package:mmpi_2/utilidades/repositoriopreguntas.dart';

class SeleccionInventario extends StatefulWidget {
  @override
  _SeleccionInventarioState createState() => _SeleccionInventarioState();
}

class _SeleccionInventarioState extends State<SeleccionInventario> {
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Estas iniciando como invitado, lo que significa que:"),
            content: Text(
              "• Tus respuestas solo se guardan en tu computadora \n • No podrás acceder a tus resultados desde otro dispositivo\n",
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
    Map<String, dynamic> inventarios = {
      "Inventario de autoevaluacion de aptitudes": {
        "imagen": "recursos/cerebro.png",
        "colores": [
          Color.fromARGB(255, 0, 177, 153),
          Color.fromARGB(255, 1, 132, 255),
        ],
        "ruta": "/inventario_autoevaluacion_aptitudes",
      },
      "Inventario de interes ocupacional": {
        "imagen": "recursos/tridente.png",
        "colores": [
          Color.fromARGB(255, 255, 132, 0),
          Color.fromARGB(255, 255, 0, 0),
         
        ],
        "ruta": "/inventario_interes_ocupacional",
      },
      "Inventario de preferencias universitarias": {
        "imagen": "recursos/libro.png",
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    print("Usuario '${SesionControlador().nombreUsuario}' ha iniciado sesión con ID: ${SesionControlador().idUsuario}, con inventarios completados: ${SesionControlador().invsCompletados}");
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Text(
                      "¡Hola, ${SesionControlador().nombreUsuario}!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: inventarios.keys.map((inventario) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      inventarios[inventario]["ruta"],
                      arguments: {"info": <String, dynamic>{...inventarios[inventario]!, "titulo": inventario}},
                    ).then((_) => setState(() {

                      print("${ControladorHive.obtenerCantidadRespuestasUsuarioYTipo(SesionControlador().usuarioId, inventarios[inventario]["ruta"])}");
                    }));
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
                          colors: inventarios[inventario]["colores"],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: inventarios[inventario]["colores"][0].withOpacity(0.5),
                            
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
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Builder(builder: (context) {
                              final ruta = inventarios[inventario]["ruta"] as String;
                              final uid = SesionControlador().usuarioId;
                              final completado = ControladorHive.obtenerCantidadRespuestasUsuarioYTipo(uid, ruta) >= tamanoInventario(ruta);
                              if (!completado) return const SizedBox();
                              final pendiente = ControladorHive.obtenerRespuestasNoSincronizadas()
                                  .any((r) => r.usuarioId == uid && r.tipo == ruta);
                              return Icon(
                                pendiente ? Icons.cloud_off : Icons.cloud_done,
                                size: 100,
                                color: Colors.white.withOpacity(0.8),
                              );
                            }),
                          ),
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
                                    "${ControladorHive.obtenerCantidadRespuestasUsuarioYTipo(SesionControlador().usuarioId, inventarios[inventario]["ruta"])} / ${tamanoInventario(inventarios[inventario]["ruta"])}",
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
                              child: Hero(
                                      tag: inventarios[inventario]["ruta"],
                                    child: Image.asset(
                                        width: 150,
                                        height: 150,
                                        inventarios[inventario]["imagen"] ??
                                            "recursos/cerebro.png",
                                        color: inventarios[inventario]["colores"][0],
                                      ),
                                  ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: PopupMenuButton<String>(
                              tooltip: "Opciones",
                              icon: Icon(Icons.more_vert, color: Colors.white),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Colors.black.withOpacity(0.5)),
                                shape: WidgetStateProperty.all(const CircleBorder()),
                              ),
                              itemBuilder: (context) {
                                final ruta = inventarios[inventario]['ruta'] as String;
                                final uid = SesionControlador().usuarioId;
                                final completado = ControladorHive.obtenerCantidadRespuestasUsuarioYTipo(uid, ruta) >= tamanoInventario(ruta);
                                return [
                                completado ?
                                    PopupMenuItem(
                                      value: 'guardar',
                                      child: Row(children: [
                                        Icon(Icons.cloud_upload_outlined),
                                        SizedBox(width: 8),
                                        Text('Guardar en la nube'),
                                      ]),
                                    ) : PopupMenuItem(
                                      value: 'guardarinvalido',
                                      child: Row(children: [
                                        Icon(Icons.cloud_upload_outlined, color: Colors.grey),
                                        SizedBox(width: 8),
                                        Text('Guardar en la nube', style: TextStyle(color: Colors.grey)),
                                      ]),
                                    ),
                                  PopupMenuItem(
                                    value: 'reiniciar',
                                    child: Row(children: [
                                      Icon(Icons.refresh, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Reiniciar', style: TextStyle(color: Colors.red)),
                                    ]),
                                  ),
                                ];
                              },
                              onSelected: (value) async {
                                final ruta = inventarios[inventario]['ruta'] as String;
                                final uid = SesionControlador().usuarioId;
                                switch (value) {
                                  case 'guardarinvalido':
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Podrás guardar en la nube una vez que completes las ${tamanoInventario(ruta)} preguntas de este inventario. Actualmente has completado ${ControladorHive.obtenerCantidadRespuestasUsuarioYTipo(uid, ruta)}.')),
                                    );
                                    break;
                                    case "guardar":
                                        final resultado = await SesionControlador.sincronizarInventario(uid, ruta);
                                        setState(() {});
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(resultado['mensaje'])));
                                      break;
                                    case "reiniciar":
                                       final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text('Reiniciar inventario'),
                                          content: Text('¿Estás seguro? Se borrarán todas las respuestas guardadas de este inventario.'),
                                          actionsAlignment: MainAxisAlignment.center,
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(ctx, false),
                                              child: Text('Cancelar'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => Navigator.pop(ctx, true),
                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                              child: Text('Reiniciar', style: TextStyle(color: Colors.white)),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        await SesionControlador.reiniciarInventario(uid, ruta);
                                        setState(() {});
                                      }
                                      break;
                                }
                             
                               
                  
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


