
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mmpi_2/firebase_options.dart';
import 'package:mmpi_2/inv2.dart';
import 'package:mmpi_2/servicios/tema_controlador.dart';
import 'package:mmpi_2/utilidades/excel.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mmpi_2/inciso.dart';
import 'package:mmpi_2/iniciosesion.dart';
import 'package:mmpi_2/modelos/modelos.dart';
import 'package:mmpi_2/servicios/servicios.dart';
import 'package:mmpi_2/servicios/sesion_controlador.dart';
import 'package:mmpi_2/selecinventario.dart';
import 'package:mmpi_2/utilidades/repositoriopreguntas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try
  {print("iniciando Firebase..."); 
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);}catch (e) {
    print("Error al inicializar Firebase: $e");
  }

  try {
    print('🚀 Iniciando aplicación Vocacional...');
    
    // Inicializar Hive
    await Hive.initFlutter();
    print('📦 Hive inicializado');
    
    // Registrar adaptadores de Hive
    Hive.registerAdapter(InfoUsuarioAdapter());
    Hive.registerAdapter(RespuestasAdapter());
    print('🔧 Adaptadores Hive registrados');
    
    // Inicializar el servicio de Hive
    await HiveService.initialize();
    
    print('✅ Aplicación inicializada correctamente');
  } catch (e) {
    print('❌ Error al inicializar la aplicación: $e');
  }

  if (FirebaseAuth.instance.currentUser != null) {
    await SesionControlador.obtenerDatosDelUsuario();
  }

  runApp(const MMPIApp());
}


class MMPIApp extends StatelessWidget {
  const MMPIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: TemaControlador.modoTema,
      builder: (context, themeMode, _) {
        return MaterialApp(
          themeMode: themeMode,
          routes: {
        "/inventario_autoevaluacion_aptitudes": (context) => _MMPI(),
        "/inventario_interes_ocupacional": (context) => _MMPI(),
        "/inventario_preferencias_universitarias": (context) => _MMPI(),
        "/inventario_preferencias_universitarias2": (context) => inventario2(tipoInventario: "Preferencias universitarias 2", tipo: "preferencias_universitarias2"),
        "/FM": (context) => _MMPI(),
        "/A": (context) => _MMPI(),
        "/S": (context) => _MMPI(),
        "/H": (context) => _MMPI(),
        "/Q": (context) => _MMPI(),
        "/B": (context) => _MMPI(),
        "/inicio_sesion": (context) => InicioSesion(),
        "/seleccion_inventario": (context) => SeleccionInventario(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        dialogTheme: DialogThemeData(
          
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: const Color.fromARGB(255, 0, 132, 255), 
            fontSize: 20, 
            fontWeight: FontWeight.bold
          ),
          contentTextStyle: TextStyle(
            color: const Color.fromARGB(255, 0, 132, 255), 
            fontSize: 16
          ),
          
          ),
         elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 0, 202, 27),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ) ,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color:  Color.fromARGB(255, 0, 132, 255), fontSize: 16),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          focusColor: Colors.white,
           
          floatingLabelAlignment: FloatingLabelAlignment.center,
          floatingLabelStyle: TextStyle(
            color: const Color.fromARGB(255, 0, 86, 126), 
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color.fromARGB(255, 0, 86, 126), width: 2),
            borderRadius: BorderRadius.circular(90),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: const Color.fromARGB(255, 0, 140, 255), width: 2),
            borderRadius: BorderRadius.circular(90),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        dialogTheme: DialogThemeData(
          backgroundColor: const Color(0xFF1E2740),
          titleTextStyle: TextStyle(
            color: const Color.fromARGB(255, 100, 180, 255),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: TextStyle(
            color: const Color.fromARGB(255, 150, 200, 255),
            fontSize: 16,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 0, 202, 27),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color.fromARGB(255, 100, 180, 255), fontSize: 16),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E2740),
          focusColor: const Color(0xFF1E2740),
          floatingLabelAlignment: FloatingLabelAlignment.center,
          floatingLabelStyle: const TextStyle(
            color: Color.fromARGB(255, 100, 180, 255),
            fontWeight: FontWeight.bold,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color.fromARGB(255, 100, 180, 255), width: 2),
            borderRadius: BorderRadius.circular(90),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color.fromARGB(255, 0, 140, 255), width: 2),
            borderRadius: BorderRadius.circular(90),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        primaryColor: const Color.fromARGB(255, 58, 123, 183),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF12192B),
          elevation: 0,
        ),
        scaffoldBackgroundColor: const Color(0xFF0D1421),
        cardColor: const Color(0xFF1E2740),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 58, 123, 183),
          secondary: Color.fromARGB(255, 0, 177, 153),
          surface: Color(0xFF1E2740),
        ),
      ),
      home: InicioSesion(),
        );
      },
    );
  }
}
class _MMPI extends StatefulWidget {
    

  _MMPI({Key? key}) : super(key: key);

  

  @override
  State<_MMPI> createState() => _MMPIState();
}

class _MMPIState extends State<_MMPI> {
late List<String> incisos;
late bool incisosenumerados;

PageController pageController = PageController();
int paginaActual = 1;
List<String> preguntas = [];
List<int> respuestas = [];
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      final nuevaPagina = pageController.hasClients ? pageController.page!.round() + 1 : 1;
      if (nuevaPagina != paginaActual) {
        setState(() {
          paginaActual = nuevaPagina;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      preguntas = Repositoriopreguntas(ModalRoute.of(context)?.settings.name ?? '' );
      respuestas = List<int>.filled(preguntas.length, -1);
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final info = args["info"] as Map<String, dynamic>;
      incisos = info["rangocalificacion"] == 0
          ? ["Nada hábil", "Poco hábil", "Medianamente hábil", "Muy hábil", "Extremadamente hábil"]
          : [for (int i = 1; i <= info["rangocalificacion"]; i++) "$i"];
      incisosenumerados = info["rangocalificacion"] != 0;
      _cargarRespuestasGuardadas();
    }
  }

  void cuestionarioCompleto() {
     if (!respuestas.contains(-1)){
    final id = SesionControlador().usuarioId;
    final tipoInventario = ModalRoute.of(context)?.settings.name ?? '';


    if (!ControladorHive.obtInventariosRespondidos(id)
    .contains(tipoInventario)) {
    ControladorHive.marcarInventarioComoCompletado(id, tipoInventario);
   showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: const Text("Cuestionario Completo")),
        content:Text("¡Has completado el cuestionario!", textAlign: TextAlign.center,),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Seguir respondiendo"),
          ),
           TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Seleccionar otro inventario"),
          ),
          TextButton(
            onPressed: () => {
              SesionControlador.sincronizarInventario(SesionControlador().idUsuario, tipoInventario),
              Navigator.pop(context)},
            child: const Text("☁️ Guardar y salir"),
          ),
        ],
      ),
    );

    }
  } else {print("Faltan por responder");}
  }

  void _responderTodoAutomaticamente() {
    for (int preguntaIndex = 0; preguntaIndex < preguntas.length; preguntaIndex++) {
    alSeleccionar(preguntaIndex, Random().nextInt(4));

  }
     cuestionarioCompleto();}

  void _cargarRespuestasGuardadas() {
    _cargarRespuestasAsync();
  }

  Future<void> _cargarRespuestasAsync() async {
    final tipo = ModalRoute.of(context)?.settings.name ?? '';
    final uid = SesionControlador().usuarioId;
    if (tipo.isEmpty) return;

    var guardadas = HiveService.cajaRespuestas.values
        .cast<Respuestas>()
        .where((r) => r.tipo == tipo && r.usuarioId == uid)
        .toList();

    final localCount = guardadas.length;
    final cloudCount = await SesionControlador.obtenerCantidadRespuestasFirebase(tipo);
    print('🔄 Local: $localCount respuestas | Nube: $cloudCount respuestas para $tipo');

    if (cloudCount > localCount) {
      print('⬇️ La nube tiene más respuestas ($cloudCount > $localCount), descargando...');
      final descargado = await SesionControlador.descargarRespuestasDeFirebase(uid, tipo);
      if (descargado) {
        guardadas = HiveService.cajaRespuestas.values
            .cast<Respuestas>()
            .where((r) => r.tipo == tipo && r.usuarioId == uid)
            .toList();
      }
    } else if (localCount == 0) {
      // Sin datos ni locales ni en nube
      print('ℹ️ Sin respuestas previas para $tipo');
    } else {
      print('✅ Local está actualizado ($localCount >= $cloudCount)');
    }

    setState(() {
      for (final r in guardadas) {
        if (r.preguntaID >= 0 && r.preguntaID < respuestas.length) {
          respuestas[r.preguntaID] = int.tryParse(r.respuesta) ?? -1;
        }
      }
    });

    final saltarA = respuestas.indexWhere((r) => r == -1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.jumpToPage(saltarA == -1 ? 0 : saltarA);
      setState(() {
              actualizarNumPagina();
      });

    });
  }

 void actualizarNumPagina(){
      paginaActual = pageController.hasClients ? pageController.page!.toInt() + 1 : 1;
 }

 double ancho = 0;
 
  List<Color> colores = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
  ];
  @override
  Widget build(BuildContext context) {
    
  final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  final info = args["info"] as Map<String, dynamic>;
   final preguntas = Repositoriopreguntas(ModalRoute.of(context)?.settings.name ?? '' );
  String imagen = info["imagen"] as String;
  print("args[info]: $info");

  List<Color> coloresBarra = info["colores"] as List<Color>;
   ancho = MediaQuery.of(context).size.width;
    return Scaffold(
        bottomNavigationBar: 
             Padding(
               padding: const EdgeInsets.all(1),
               child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                 children:[ 
                    ElevatedButton(
                    style:  ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 132, 255),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  onPressed: (){
                    verPaginas();
                  }, 
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.rocket_launch, color: Color.fromARGB(255, 255, 255, 255)),
                    SizedBox(width: 8),
                    Text("Ver mi progreso", style: TextStyle(fontSize: 10, color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),)
                  ],
                 )
                        ),
                   /**   ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 19, 192, 25),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                     onPressed: () async {
                        await ExcelUtil.crearReporteConPlantilla();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.download, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Exportar CSV', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),*/
                  ]
               ),
             ),
         
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: coloresBarra[1],
          title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            ElevatedButton(
                          style: ElevatedButton.styleFrom(
                      backgroundColor:  Colors.white,
                      shape: RoundedRectangleBorder (borderRadius: BorderRadius.circular(20)),
                      textStyle:  const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
              onPressed: (){
              Navigator.pop(context);
            }, child: 
            const Icon(Icons.arrow_back, color: Colors.blue,)
            ),
            Row(spacing: 3,children: [
                      Hero(
              tag: ModalRoute.of(context)!.settings.name ?? '',
              child:  Image.asset(imagen, width: 30, height: 30, color: Colors.white,), 
            ),
              ancho > 800 ? Text(info["titulo"], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,),) : SizedBox()]),
    
            SizedBox(width: 30)

          ],
        
        ),),
        body: Stack(
            children: [
       PageView.builder(
                controller: pageController,
                itemCount: preguntas.length,
                itemBuilder: (context, index) {
                  return _pagina(
                    preguntas[index],
                    colores[index % colores.length  ],
                    incisos,
                    (seleccionado) => alSeleccionar(index, seleccionado),
                    respuestas[index],
                  );
                },
              ),
              Positioned(child: Text(textAlign: TextAlign.center,"Pregunta ${paginaActual} de ${preguntas.length}", style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255))), bottom: 10, right: 10, left: 10,)
        
               /*   ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: preguntas.length,
            itemBuilder: (context, index) {
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 132, 255),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(child: Text("${index + 1}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                  ),
                  Flexible(
                    child: _pagina(
                            preguntas[index],
                            const Color.fromARGB(255, 0, 152, 223),
                            incisos,
                            (seleccionado) => alSeleccionar(index, seleccionado),
                            respuestas[index],
                          ),
                  ),
                ],
              ),
            );
           })**/
            ],
            ),
        
      
    );
  }

  void siguientePagina() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.bounceInOut,
    );
  cuestionarioCompleto();
  }

  void verPaginas(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        titlePadding: const EdgeInsets.only(left: 12.0,right: 12.0, top: 3.0, bottom: 1.0),
        contentPadding: const EdgeInsets.all(3.0),
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 30),
            Text("Respuestas"),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 30,
                width: 30,
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16,),
              ),
            )
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 1,
          child: FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 100)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 0, 132, 255),
                  ),
                );
              }
              
              return Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      clipBehavior: Clip.hardEdge,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 5 : 10,
                          childAspectRatio: 1,
                          mainAxisSpacing: 3,
                          crossAxisSpacing: 3,
                        ),
                        itemCount: preguntas.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              pageController.jumpToPage(index);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: respuestas[index] == -1 ? Colors.grey : const Color.fromARGB(255, 19, 192, 25),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: AutoSizeText(
                                  "${index + 1}", 
                                  maxFontSize: 100,
                                    style: TextStyle(
                                      fontSize: 48,
                                      color: TemaControlador.esModoOscuro ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        )
                                      ]
                                    ),
                                  ),
                                ),
                              ),
                            
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    "Has respondido ${respuestas.where((r) => r != -1).length} de ${preguntas.length} preguntas", 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: const Color.fromARGB(255, 0, 132, 255)
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      )
    );
  }

  void alSeleccionar(int preguntaIndex, int incisoIndex) {

    setState(() {
      respuestas[preguntaIndex] = incisoIndex;
    }
    
    );
        siguientePagina();

    final tipo = ModalRoute.of(context)?.settings.name ?? '';
    final uid = SesionControlador().usuarioId;
    if (tipo.isNotEmpty) {
      ControladorHive.guardarRespuesta(
        usuarioId: uid,
        preguntaID: preguntaIndex,
        respuesta: incisoIndex.toString(),
        tipoInventario: tipo,
      );
    } else {
      print('⚠️ No se pudo guardar la respuesta: tipo de inventario no disponible');
    }
  }

  
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }


Widget _pagina(
  String texto,
  Color color,
  List<String> incisos,
  void Function(int) cambiarPagina,
  int seleccionado,
) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  final isLandscapeMobile = screenHeight < 500 && screenWidth > screenHeight;
  final isPortraitMobile = screenWidth < 600;

  final int cols = ((incisos.length + 1) / 2).ceil().clamp(1, 10);
  final firstRow = incisos.sublist(0, cols);
  final secondRow = incisos.length > cols ? incisos.sublist(cols) : <String>[];

  Widget buildLandscapeButton(String inciso) {
    final idx = incisos.indexOf(inciso);
    return Expanded(
      child: GestureDetector(
        onTap: () => cambiarPagina(idx),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Inciso(texto: inciso, valor: idx, seleccionado: seleccionado == idx, key: null, esNumero: incisosenumerados),
        ),
      ),
    );
  }

  Widget botonesLandscapeGrid = Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Expanded(
        child: Row(
          children: firstRow.map(buildLandscapeButton).toList(),
        ),
      ),
      if (secondRow.isNotEmpty)
        Expanded(
          child: Row(
            children: [
              ...secondRow.map(buildLandscapeButton).toList(),
              ...List.generate(cols - secondRow.length, (_) => Expanded(child: SizedBox())),
            ],
          ),
        ),
    ],
  );

  Widget botonesWrap = Wrap(
    alignment: WrapAlignment.center,
    spacing: 10,
    runSpacing: 5,
    children: incisos.map((inciso) => GestureDetector(
      onTap: () => cambiarPagina(incisos.indexOf(inciso)),
      child: Inciso(texto: inciso, valor: incisos.indexOf(inciso), seleccionado: seleccionado == incisos.indexOf(inciso), key: null, esNumero: incisosenumerados),
    )).toList(),
  );

  Widget botonesContainer = Container(
    margin: EdgeInsets.symmetric(
      horizontal: isLandscapeMobile ? 8 : 20,
      vertical: isLandscapeMobile ? 8 : 20,
    ),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: const LinearGradient(
        colors: [Colors.black12, Colors.black26],
        end: Alignment.topCenter,
        begin: Alignment.bottomCenter,
      ),
    ),
    child: isLandscapeMobile
        ? botonesLandscapeGrid
        : botonesWrap,
  );

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: isLandscapeMobile
          // Landscape mobile: pregunta a la izquierda, botones a la derecha
          ? Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: AutoSizeText(
                        texto,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 100, color: Colors.white),
                        textAlign: TextAlign.center,
                        maxLines: 5,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: botonesContainer,
                ),
              ],
            )
          // Portrait: columna normal
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AutoSizeText(
                        texto,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 100, color: Color.fromARGB(255, 255, 255, 255)),
                        textAlign: TextAlign.center,
                        maxLines: 4,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Flexible(
                  flex: isPortraitMobile ? 2 : 1,
                  child: botonesContainer,
                ),
              ],
            ),
    ),
  );
}
}