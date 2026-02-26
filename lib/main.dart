import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:mmpi_2/inciso.dart';
import 'package:mmpi_2/registro.dart';
import 'package:mmpi_2/selecinventario.dart';

void main() {
  runApp(const MMPIApp  ());
}


class MMPIApp extends StatelessWidget {
  const MMPIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 0, 202, 27),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ) ,
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
      home: SeleccionInventario(), // _MMPI() //Registro(),
    );
  }
}
class _MMPI extends StatefulWidget {
    
  @override
  State<_MMPI> createState() => _MMPIState();
}

class _MMPIState extends State<_MMPI> {
  final preguntas = [
    "Comprender con facilidad cómo se conectan algunos elementos, por ejemplo, las relaciones entre los órganos del cuerpo humano, las relaciones que se dan entre los elementos de una computadora.",
    "Decorar, con pincel fino, pequeñas figuras humanas (pintar la boca, ojos, cejas, etc.).",
    "Ayudar a un especialista en diseño de juegos electrónicos a realizar juegos entables que sean de entretenimiento numérico.",
    "Darte cuenta cuando un conferencista, al estar presentando su tema, lo expone de manera demasiado elemental.",
    "Dar buenas ideas a un grupo de vendedores (que van casa por casa) acerca de cómo convencer a los clientes para comprar el producto ofrecido.",
    "Aprender las partes y funciones de un velero, así como su operación y armado.",
    "Enseñar a alguien durante un largo período, sin interrumpirle, sin impacto, y aceptar lo como es.",
    "Distribuir las funciones y responsabilidades a los miembros de un grupo o equipo de trabajo, procurando que todos se sientan lo más conformes con esta distribución.",
    "Tomar un curso sobre comunicación no verbal en un pequeño almacén, mediante una computadora sencilla, y aprender fácilmente.",
    "Vencer las diferencias entre la música clásica, la popular y la moderna.",
    "Diseñar el logotipo de una empresa.",
    "Armar rompecabezas complicados (cada cubo de Rubik, por ejemplo).",
    "Hacer un análisis de la estructura financiera de la línea y sin ayuda de reglas.",
    "Reconocer tus errores cuando discutes con otra persona, aunque esto no sea de tu total agrado o tengo puntos contrarios a los tuyos.",
    "Diseñar una revista de pasatiempos, con problemas sencillos, con base en relaciones numéricas o químicas algebraicas.",
    "Explicar fácilmente, al terminar una lectura (sobre cualquier género de novelas), cómo se relacionan los personajes o cómo se desarrolla la trama.",
    "Idear un sistema rápido en cronista deportivo, para que gráficamente pueda organizar datos deportivos tales como: los promedios de bateo, bases robadas, home runs, etc., de una temporada.",
    "Ser presidente de un club social y decidir a cada uno de los miembros de la mesa directiva sus tareas y sin dudar, ser efectivos, de forma precisa.",
    "Aprender las partes y funciones de un planeador, así como su operación y armado.",
    "Inventar un método para el trabajo de publicistas sobre cómo presentar un producto en un comercial de TV o de radio.",
    "Entender las nomenclaturas químicas o el funcionamiento estructural de todos los órganos del cuerpo humano.",
    "Diseñar figuras geométricas en tres dimensiones, variando las posiciones y perspectivas.",
    "Ver técnicas para realizar pinturas en acuarela y óleo.",
    "Aprender el manejo de la herramienta propia para modelar y esculpir barro, trabajar vidrio, porcelana, latón y piel, de manera artesanal.",
    "Darte cuenta fácilmente si el profesor omitió un dato o punto necesario para la resolución de un problema durante el examen de matemáticas y saber con precisión lo que falta.",
    "Idear un sistema para pequeñas tiendas de regalos, en el que puedan llevar un inventario de la existencia de sus productos.",
    "Hacer un buen resumen de cualquier libro o escrito que hayas leído, con toda la información relevante bien organizada.",
    "Tratar por igual a todos sin distinción de clase o condición social.",
    "Operar y dar mantenimiento a un tractor agrícola, incluyendo sus implementos.",
    "Cumplir, a la perfección, una tarea asignada por tus padres, un profesor o jefe de trabajo.",
    "Aprender a leer, interpretar y combinar notas musicales.",
    "Descubrir bellamente el aparador de una tienda o un puesto de una feria o verbena.",
    "Reconocer en una persona que no sea de tu agrado, sus fortalezas, sus virtudes y sus aciertos.",
    "Comentar en un programa televisivo de la universidad, las ventajas y desventajas de las plantillas que aspiran a dirigir la sociedad de alumnos, y argumentar a favor de una de ellas.",
    "Sacar astillas de la piel con pinzas para las cejas (en el primer intento).",
    "Aprender a usar métodos científicos para profundizar en el conocimiento de las relaciones que, por ejemplo, hay entre los seres vivos que integran el ecosistema, los cambios químicos que se dan en la naturaleza, etcétera.",
    "Entender fácilmente el uso de un compás, y poder explicar fácilmente todas sus funciones para ver las cosas desde esa perspectiva (aunque no sea grande como punto de vista si tu compañero).",
    "Entender fácilmente artículos de revistas que versan sobre investigación en las ciencias naturales, como química, biología, geofísica, etcétera.",
    "Dar información muy completa de cualquier tema que te adhieran revisar (medidas de errores en fichas, metas que se proponen, pasos, puntos omitidos, etc.).",
    "Instalar, operar y darle mantenimiento a una computadora casera con sólo consultar el manual o instructivo de operaciones.",
    "Identificar errores ortográficos, en la organización de las párrafos y errores de redacción en cualquier escrito, aún cuando sea ilegible.",
    "Darle buenas sugerencias a un banco pequeño acerca de cómo organizar los departamentos de atención al público con el fin de que sus clientes no hagan largas colas de espera.",
    "Darte cuenta cuando un profesor comete errores al estar explicando al grupo la solución (procedimiento) de un problema de matemáticas.",
    "Soldar los transistores de un radio sin derramar soldadura, ni tocar con el soldador partes cercanas al transistor.",
    "Sugerir a alguien que va a construir su casa la forma en que debería o la distribución de la misma, aprovechando al máximo todos los espacios.",
    "Aprender las técnicas en el departamento de almacén comercial (libros, música, ferretería, etc.) y manejar tal vez períodos las ventas y consumo por los clientes que lo visitan.",
    "Aprender a ejecutar, con dominio, uno o varios instrumentos musicales.",
    "Recordar, detalladamente, las indicaciones dadas por alguien para llegar a una dirección desconocida.",
    "Aprender a diferenciar lo bello de la pintura de los grandes clásicos, en relación con otras pinturas.",
    "Dar a una familia consejos prácticos acerca de planear que sí compleméntente cambie ciertas actitudes de ellos.",
    "Comprender todo tipo y tener a tu lado, como evolucionan y se transforman los seres vivos, de acuerdo con las teorías evolucionistas de Darwin, o explicar en qué consisten las especies protegidas o seleccionamiento de tiempos químicos como lluvia.",
    "Fungir como tercero en un conflicto (sin tomar partido por las personas involucradas) y conciliar a las partes en pugna aunque una de ellas te simpatice mucho.",
    "Supervisar y corregir la redacción de un discurso que alguien competente tuvo vaya a dirigir a una asamblea.",
    "Aprender el sistema de clasificación que se utiliza para los archivos de la Nación.",
    "Dibujar a lápiz el rostro de las personas, siguiendo ciertas técnicas.",
    "Enseñar algunos tipos en grupos muy pequeñas, sin que lo intentes más de tres veces.",
    "Aplicar conocimientos matemáticos y principios de la ciencia para el diseño de puentes que no haya infringido cuando esa aplicación implique la expansión del grupo de alguien muy avanzado.",
    "Inventar algo útil para los aerospacios y artículos de la revista ¡Mecánica Popular!",
    "Recordar, durante una segunda visita, el lugar de una colonia intrincada, en donde vive alguien conocido.",
    "Aprender a complementar los distintos instrumentos musicales en la ejecución de una pieza.",
    "Aprender técnicas para construir maquetas y objetos de cualquier tipo a escala. (Por ejemplo, un avión, un ayuda de campo con material).",
    "Entender fácilmente la explicación de un armero sobre cómo funciona cierto tipo de armamento militar, ya sea fusiles, ametralladoras o artillería en miniatura.",
    "Prever e identificar las consecuencias para ti y para los demás (de manera detallada y precisa) de las decisiones que tomes.",
    "Colocar sin errores, con pinzas pequeñas, los engranes de un reloj.",
    "Explicar los factores por el material a un grupo de compañeros menos aventajados, de manera más sencilla que el profesor.",
    "Aprender y manejar el sistema de clasificación y localización de piezas en una refaccionaria de automóviles.",
    "Explicar de forma clara y lógica a un grupo de personas, con las mismas palabras y con ejemplos ilustrativos, el manejo de algún aparato técnico que tú ya domines.",
    "Comprender con facilidad cómo una persona cercana a ti ve desde su interior el mundo. Comprender también los sentimientos que tiene y sus expectativas.",
    "Aplicar las leyes y teorías de la química o de la biología cuando resolvemos un problema de matemáticas.",
    "Generar argumentos, ante un auditorio, a favor de tu punto de vista o de algún proyecto.",
    "Aprender a hacer arreglos musicales.",
    "Resolver problemas de matemáticas y seleccionar las fórmulas y procedimientos necesarios de manera precisa y fácil.",
    "Apretar, con un pequeño desarmador, los tornillos de los anteojos.",
    "Dar una conferencia sobre un tema de computación tuya tonga éxito en una campaña política o en cualquier actividad.",
    "Aprender con facilidad a afinar automóviles o a dar mantenimiento y reparación a aparatos caseros como: podadoras de pasto, calentadores de gas, estufas, etcétera.",
    "Dar ideas al párroco o ministro de tu iglesia acerca de cómo mejorar sus sermones o sus actividades espirituales.",
    "Obtener fácilmente conclusiones a una síntesis de algún trabajo que hayas encargado el profesor de biología o de química sobre cualquier tema.",
    "Darte cuenta de los deseos, preocupaciones o sentimientos de alguien, solo por ver sus gestos y movimientos.",
    "Estudiar e interpretar las instrucciones y las preguntas de un examen.",
    "Diseñarle a una pequeña ferretería un sistema para localizar rápidamente los productos que el cliente pide.",
    "Combinar materiales de todo tipo (yeso, madera, pinturas) para hacer objetos de ornato, como floreros, ceniceros, pisapapeles, etcétera.",
    "Armar aparatos de radio, televisión, amplificadores, grabadoras, etcétera.",
    "Aprender con facilidad a escribir y arreglar canciones y composiciones musicales.",
    "Distinguir errores en las perspectivas de los dibujos.",
    "Hacerle ver a un grupo que discute cosas que no han considerado o puntos omitidos que pueden influir en sus opiniones sobre lo discutido.",
    "Construir, en un taller de aficionados, artefactos sencillos como un velero, un planeador, etcétera.",
    "Lograr entusiasmar a un grupo de trabajo que se encuentra pesimista en cuanto a las metas de trabajo por lograr.",
    "Enhebrarse rápidamente un collar de perlas.",
    "Darte cuenta de inmediato de cuál es el error de un compañero que no puede resolver correctamente un problema de matemáticas.",
    "Participar con un diseño tuyo, con probabilidades de ganar, en un concurso de la escuela cuyo objetivo o meta sea el de proponer un sistema de clasificación para los expedientes de los estudiantes.",
    "Darte cuenta de inmediato cuando un profesor se aplica un examen con errores de contenido o en la clasificación de las preguntas.",
    "Predecir la forma en que un conocido tuyo va a actuar, lo que va a decir y a pensar en una situación dada.",
    "Comprender la relación entre estructuras y funciones de los órganos del cuerpo humano; establecer cómo se relacionan todos los sistemas, o hacer esto mismo con plantas o animales.",
    "Diseñar la decoración de un hogar o una oficina.",
    "Hacerle a un carpintero, detalladamente (con ángulos, medidas, superficies, etc.), un diseño sobre el tipo de muebles que necesitas hacer.",
    "Entender los principios (cómo funcionan las hipótesis, como relacionaciones, como componentes, instrumentos, cómo operan, etcétera) de todo lo que un químico o algún biólogo famoso logra llegar a sus descubrimientos.",
    "Darte cuenta rápidamente cuando alguien está pasando por un mal momento y necesita de tu ayuda sin que te lo pida.",
    "Escribir sin galón teatral o alguna pequeña obra, relacionando y ordenando correctamente los diálogos de los personajes, las escenas, etcétera.",
    "Mejorar el procedimiento de inscripciones en la escuela, creando uno más rápido, más fácil, práctico y eficiente.",
    "Prestar ayuda al profesor de matemáticas para plantear problemas de repaso referentes a toda la materia.",
    "Pegar piedras preciosas en un collar, viendo a través de una lupa.",
    "Hacer que todos los miembros de un grupo de trabajo que tienes, sin sentirse presionado o perseguido.",
    "Ayudarte fácilmente a que un curso la reparación de productos electrónicos, mecánicos, etc., y que te quede fundamenta.",
    "Aprender a ser un buen orador mediante un curso rápido y sencillo.",
    "Darte cuenta cuando alguien tiene un error en la ejecución de una pieza musical.",
    "Dibujar figuras en detalles complicadas, con instrumentos, etc.) de las.",
    "Ejemplificar fácilmente cómo se pueden observar en la vida cotidiana las leyes y principios de la biología o de la química.",
    "Saber identificar el momento oportuno para dar un consejo, empezar una conversación, o hacer una pregunta a alguien con quien no se puede platicar muy fácilmente.",
    "Dirigir un grupo musical que interprete melodías de moda.",
    "Hacer fácil y rápidamente composición escritas, unas oraciones, párrafos, títulos o subtítulos, según todas las desedan.",
    "Aprender como computar las datos (nóminas, inventarios, egresos, ingresos, etc.), de un pequeño comercio.",
    "Diseñar putos de examen con problemas y ejercicios de matemáticas para la clase.",
    "Interpretar muy bien al sello de la música que más te gusta, tocas.",
    "Armar y desarraigar rapidamente y sin errores un reloj de pulso.",
    "Identificar las limitantes físicas de los miembros de un grupo de trabajo para asignarles responsabilidades en una tarea determinada.",
    "Entender fácilmente la aplicación de un aparato no eléctrico para soltar molino sobre la forma en que se combina la electrónica, la electricidad y la mecánica, en la construcción del armamento de la aviación.",
    "Preparar y dar un discurso a un auditorio acerca de la necesidad de cuidar la Tierra de forma que los futuros generados no se vean en el descuido de deterioro ambiental, o acerca de tomar las medidas necesarias.",
    "Recortar con facilidad el ritmo de las piezas musicales que más te agradan.",
    "Reducir con facilidad los lugares de un estacionamiento de coches en forma tal que quepan más autos en la capa y finales cada espacio.",
    "Decorar objetos cerámicos, de piel, de madera, de barro, etcétera."
  ];
  final incisos = ["Nada hábil", "Poco hábil", "Medianamente hábil", "Muy hábil", "Extremadamente hábil"];


List<int> respuestas = [];
int paginaActual = 0;
  PageController pageController = PageController();
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
   ancho = MediaQuery.of(context).size.width;
    for (var _ in preguntas) {
      respuestas.add(-1);
    }
    return MaterialApp(
    
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 0, 110, 255),
            elevation: 0,
          ),
        ),
      home: Scaffold(
        bottomNavigationBar: 

           
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                 children:[ 
                    ElevatedButton(
                    style:  ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 132, 255),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  onPressed: (){

                    verPaginas();
                  }, 
                  
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.rocket_launch, color: Color.fromARGB(255, 255, 255, 255)),
                    SizedBox(width: 8),
                    Text("Ver mi progreso", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),)
                  ],
                 )
                        ),]
               ),
             ),
         
        appBar: AppBar(title: Row (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            Text("Cuestionario MMPI", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,),),
            Card(
              margin: EdgeInsets.zero,
              child: Icon(Icons.psychology_alt_outlined),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, color: Color.fromARGB(255, 0, 132, 255),),
                  const SizedBox(width: 8),
                  Text("Cristian Fernando", style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 132, 255)),)
                ],
              ),
            ),

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
              Positioned(child: Text(textAlign: TextAlign.center,"Pregunta ${pageController.hasClients ? pageController.page!.toInt() + 1 : 1} de ${preguntas.length}", style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255))), bottom: 10, right: 10, left: 10,)
        
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
        
      
    ),);
  }

  void siguientePagina() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.bounceInOut,
    );
  }

  void verPaginas(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 30,),
            Text("Respuestas"),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 30,
                width: 30,
                padding: const EdgeInsets.all(4.0),
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
          height: MediaQuery.of(context).size.height * 0.9,
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
                      borderRadius: BorderRadius.circular(20),
                      clipBehavior: Clip.hardEdge,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                          childAspectRatio: 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: preguntas.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              pageController.jumpToPage(index);
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: respuestas[index] == -1 ? Colors.grey : const Color.fromARGB(255, 19, 192, 25),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: AutoSizeText(
                                  "${index + 1}", 
                                  maxFontSize: 100,
                                    style: TextStyle(
                                      fontSize: 48,
                                      color: const Color.fromARGB(255, 255, 255, 255), 
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
                  SizedBox(height: 15),
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
    });
   siguientePagina();
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
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height:  150,
      width: double.infinity,
      decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ color,color],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),

        child: SizedBox(
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AutoSizeText(
                    texto,
                    style: const TextStyle(fontWeight: FontWeight.w900,fontSize: 100, color: Color.fromARGB(255, 255, 255, 255),),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                  ),
                ),
              ),
              SizedBox(height: 20),
             Flexible(
              flex: 1,
               child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 3,
                  runSpacing: 2,
                  children: incisos
                      .map(
                        (inciso) => GestureDetector(
                            onTap: () {
                              cambiarPagina(incisos.indexOf(inciso));
                            },
                            child: Inciso(texto: inciso, valor: incisos.indexOf(inciso), seleccionado: seleccionado == incisos.indexOf(inciso), key: null,),
                          ),
                      )
                      .toList(),
                ),
             ),
            ],
          ),
        ),
      
    ),
  );
}


}