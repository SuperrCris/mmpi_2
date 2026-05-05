import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mmpi_2/servicios/sesion_controlador.dart';
import 'package:mmpi_2/servicios/controlador_hive.dart';
import 'package:mmpi_2/servicios/tema_controlador.dart';
import 'package:mmpi_2/utilidades/repositoriopreguntas.dart';

class SeleccionInventario extends StatefulWidget {
  @override
  _SeleccionInventarioState createState() => _SeleccionInventarioState();
}

class _SeleccionInventarioState extends State<SeleccionInventario> {
  List<String> _inventariosCompletados = [];

  Future<void> _cargarCompletados() async {
    final completados = await SesionControlador.obtenerInventariosCompletados(SesionControlador().usuarioId);
    if (mounted) setState(() => _inventariosCompletados = completados);
  }

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
    }    _cargarCompletados();  }

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
      backgroundColor: const Color.fromARGB(255, 58, 123, 183),
      body: Builder(builder: (context) {

        final modoOscuro = Theme.of(context).brightness == Brightness.dark;
        return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: modoOscuro
                ? [
                    const Color(0xFF0D1421),
                    const Color(0xFF0A1F2E),
                  ]
                : [
                    const Color.fromARGB(255, 58, 123, 183),
                    const Color.fromARGB(255, 0, 177, 153),
                  ],
          ),
        ),
        child: Container(
            alignment: Alignment.center,
             margin: const EdgeInsets.all(50.0),
            decoration: BoxDecoration(
              color: modoOscuro ? const Color(0xFF1A2540) : const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(45),
             
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(modoOscuro ? 0.5 : 0.2),
                  spreadRadius: 5,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.only(top: 30.0, left: 50.0, right: 50.0, bottom: 30.0),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "¡Hola, ${SesionControlador().nombreUsuario}!",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: modoOscuro
                                  ? const Color.fromARGB(255, 100, 180, 255)
                                  : const Color.fromARGB(255, 58, 123, 183),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          PopupMenuButton(
                            surfaceTintColor: Colors.blue,
                            shadowColor: Colors.blue,
                            shape: ShapeBorder.lerp(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              0.5,
                            ),
                            tooltip: "Más opciones",
                            icon: Icon(Icons.more_horiz),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                
                                value: "modo_oscuro",
                                child: ValueListenableBuilder<ThemeMode>(
                                  valueListenable: TemaControlador.modoTema,
                                  builder: (context, mode, _) => Row(children: [
                                    Icon(mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
                                    SizedBox(width: 8),
                                    Text(mode == ThemeMode.dark ? "Modo claro" : "Modo oscuro", style: TextStyle(color: modoOscuro ? Colors.white : Colors.black)),
                                  ]),
                                ),
                              ),
                              PopupMenuItem(
                                child: Row(children: [Icon(Icons.logout), SizedBox(width: 8), Text("Cerrar sesión", style: TextStyle(color: modoOscuro ? Colors.white : Colors.black))]),
                                value: "cerrar_sesion",
                              ),
                            ],
                            onSelected: (value) {
                              if (value == "cerrar_sesion") {
                                SesionControlador.cerrarSesion();
                                Navigator.pushReplacementNamed(context, "/inicio_sesion");
                              } else if (value == "modo_oscuro") {
                                TemaControlador.alternarTema();
                              }
                            },
                          ),
        
                          GestureDetector(
                            onTap: () => ControladorHive.obtenerTodasLasRespuestas( SesionControlador().usuarioId),
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "Selecciona un inventario para comenzar o continuar con tu evaluación.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: const Color.fromARGB(255, 58, 123, 183),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
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
                      ).then((_) => _cargarCompletados());
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
                                final completado = _inventariosCompletados.contains(ruta);
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
                                      _inventariosCompletados.contains(inventarios[inventario]["ruta"])
                                          ? "Completado ✓"
                                          : "${ControladorHive.obtenerCantidadRespuestasUsuarioYTipo(SesionControlador().usuarioId, inventarios[inventario]["ruta"])} / ${tamanoInventario(inventarios[inventario]["ruta"])}",
                                      style: TextStyle(
                                        color: _inventariosCompletados.contains(inventarios[inventario]["ruta"])
                                            ? const Color.fromARGB(255, 19, 192, 25)
                                            : inventarios[inventario]["colores"][1],
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
                                  final completado = _inventariosCompletados.contains(ruta);
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
                                          _cargarCompletados();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(resultado['mensaje'])));
                                        break;
                                      case "reiniciar":
                                         final confirmacion = await showDialog<bool>(
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
                                        if (confirmacion == true) {
                                          await SesionControlador.reiniciarInventario(uid, ruta);
                                          _cargarCompletados();
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
                  SizedBox(height: 30),
                  Wrap(
                    children: [
                      Builder(builder: (context) {
                        final todasLasRutas = inventarios.values
                            .map((v) => v["ruta"] as String)
                            .toList();
                        final todosCompletados = todasLasRutas
                            .every((ruta) => _inventariosCompletados.contains(ruta));
                        return GestureDetector(
                          onTap: todosCompletados
                              ? () {
                                  // TODO: navegar a resultados
                                }
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Debes completar todos los inventarios para ver tus resultados.',
                                      ),
                                    ),
                                  );
                                },
                          child: AnimatedOpacity(
                            opacity: todosCompletados ? 1.0 : 0.45,
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: todosCompletados
                                      ? [
                                          const Color.fromARGB(255, 10, 197, 10),
                                          const Color.fromARGB(255, 0, 189, 94),
                                        ]
                                      : [
                                          Colors.grey.shade500,
                                          Colors.grey.shade600,
                                        ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: (todosCompletados
                                            ? const Color.fromARGB(255, 10, 197, 10)
                                            : Colors.grey)
                                        .withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(45),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    todosCompletados ? Icons.bar_chart : Icons.lock,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                  AutoSizeText(
                                    "Ver mis resultados",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ]
                ),
                SizedBox(height: 20),
                ],
              ),
            ),
          ),
      );
      }),
      );
    
 
  }
}



