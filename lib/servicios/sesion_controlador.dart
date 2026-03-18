import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mmpi_2/modelos/infousuario.dart';
import 'package:mmpi_2/servicios/controlador_hive.dart';

class SesionControlador {


  String idUsuario = "-1";
  String nombreUsuario = "Invitado";
  String apellidoUsuario = "";
  String rfcUsuario = "";
  String curpUsuario = "";
  String correoUsuario = "";
  List<String> invsCompletados = [];
  Map<String, dynamic> datosUsuario = {};






  static final SesionControlador _sesioncontrolador = SesionControlador._internal();
  SesionControlador._internal();
 
  factory SesionControlador() {
    return _sesioncontrolador;
  }
  String get usuarioId => idUsuario;

  static Future<Map<String, dynamic>> iniciarSesionEnLinea({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      await obtenerDatosDelUsuario();
      ControladorHive.obtenerInfoUsuario(FirebaseAuth.instance.currentUser!.uid).id == "-1" ?  
        ControladorHive.crearUsuario(InfoUsuario(id: FirebaseAuth.instance.currentUser!.uid, nombre: _sesioncontrolador.nombreUsuario, apellido: "", rfc: "", curp: "", correo: _sesioncontrolador.datosUsuario['correo'] ?? ""))
      : print("Usuario '${_sesioncontrolador.nombreUsuario}' ya existe en Hive.");

print('✅ Inicio de sesión exitoso para $email');
      return {"exito": true, "mensaje": "Inicio de sesión exitoso"};
    } on FirebaseAuthException catch (e) {
     // FirebaseAuth.instance.signOut();
      switch (e.code) {
        case 'user-not-found':
          return {"exito": false, "mensaje": "No se encontró un usuario con ese correo."};
        case 'wrong-password':
        case 'invalid-credential':
          return {"exito": false, "mensaje": "Correo o contraseña incorrectos."};
        case 'invalid-email':
          return {"exito": true, "mensaje": "Registrado, pero el correo podria no pertenecer a una cuenta válida."};
        case 'user-disabled':
          return {"exito": false, "mensaje": "Esta cuenta ha sido deshabilitada."};
        case 'too-many-requests':
          return {"exito": false, "mensaje": "Demasiados intentos fallidos. Intenta más tarde."};
        case 'network-request-failed':
          return {"exito": false, "mensaje": "Sin conexión a internet. Verifica tu red."};
        case 'email-already-in-use':
          return {"exito": false, "mensaje": "Ese correo ya está registrado."};
        default:
          return {"exito": false, "mensaje": "Error inesperado: ${e.message}"};
      }
    
    }
  
  }


  static Future<void> obtenerDatosDelUsuario() async {
          await FirebaseFirestore.instance.collection('usuarios').doc(FirebaseAuth.instance.currentUser!.uid).get().then((doc) {
        if (doc.exists) {
          _sesioncontrolador.datosUsuario = doc.data()!;
          _sesioncontrolador.idUsuario = FirebaseAuth.instance.currentUser!.uid ;
          _sesioncontrolador.nombreUsuario = doc.data()!['nombre'] ?? "";
          _sesioncontrolador.invsCompletados = List<String>.from(doc.data()!['invsCompletados'] ?? []);
                  if (ControladorHive.obtenerInfoUsuario(FirebaseAuth.instance.currentUser!.uid).id == "-1") {
          ControladorHive.crearUsuario( 
          InfoUsuario(id: FirebaseAuth.instance.currentUser!.uid, nombre: _sesioncontrolador.nombreUsuario, apellido: _sesioncontrolador.apellidoUsuario, rfc: _sesioncontrolador.rfcUsuario, curp: _sesioncontrolador.curpUsuario, correo: _sesioncontrolador.datosUsuario['correo'] ?? ""));
        }
        } else {print("No se encontraron datos adicionales para el usuario.");}


      });
  sincronizarPendientes();
  }



  static Future<Map<String, dynamic>> registroEnLinea({required String email, required String password, Map<String, dynamic>? datosAdicionales}) async {
try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (datosAdicionales != null) {
      FirebaseFirestore.instance.collection('usuarios').doc(FirebaseAuth.instance.currentUser!.uid).set(datosAdicionales);
    }
    await iniciarSesionEnLinea(email: email, password: password);
    return {"exito": true, "mensaje": "Registro exitoso"};
} catch (e) {
    return { "exito": false, "mensaje": "Error: ${e.toString()}"};
}}

static Future<void> subirCuestionario (Map<String, dynamic> respuestas, String cuestionarioId) async {
  if (FirebaseAuth.instance.currentUser == null) {
    print("No hay usuario autenticado. No se pueden subir las respuestas.");
    return;
  }
  try {
    await FirebaseFirestore.instance.collection('cuestionarios').doc(FirebaseAuth.instance.currentUser!.uid).collection(cuestionarioId).doc('respuestas').set({
      'respuestas': respuestas,
      'timestamp': FieldValue.serverTimestamp(),
    });
    await FirebaseFirestore.instance.collection('usuarios').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'invsCompletados': FieldValue.arrayUnion([cuestionarioId]),
    });
    print("Respuestas del cuestionario subidas exitosamente.");
  } catch (e) {
    print("Error al subir las respuestas del cuestionario: ${e.toString()}");
  }
}

static Future<List<int>?> obtenerRespuestas(String cuestionarioId) async {
  if (FirebaseAuth.instance.currentUser == null) {
    print("No hay usuario autenticado. No se pueden obtener los cuestionarios resueltos.");
    return [];
  }
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('cuestionarios')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(cuestionarioId)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return [];

    final data = snapshot.docs.first.data() as Map<String, dynamic>;
    final respuestas = data['respuestas'];

    if (respuestas is List) {
      return respuestas.map((e) => (e as num).toInt()).toList();
    } else if (respuestas is Map) {
      final sorted = respuestas.entries.toList()
        ..sort((a, b) => int.parse(a.key).compareTo(int.parse(b.key)));
      return sorted.map((e) => (e.value as num).toInt()).toList();
    }
    return [];
  } catch (e) {
    print("Error al obtener el cuestionario resuelto: ${e.toString()}");
    return [];
  }
}

static Future<void> reiniciarInventario(String usuarioId, String tipoInventario) async {
  await ControladorHive.reiniciarInventario(usuarioId, tipoInventario);
  if (FirebaseAuth.instance.currentUser != null) {
    try {
      await FirebaseFirestore.instance
          .collection('cuestionarios')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(tipoInventario.replaceAll('/', ''))
          .doc('respuestas')
          .delete();
      print("🗑️ Inventario '$tipoInventario' eliminado de Firebase.");
    } catch (e) {
      print("Error al eliminar de Firebase: ${e.toString()}");
    }
  }
}

static Future<Map<String, dynamic>> sincronizarInventario(String usuarioId, String tipoInventario) async {
  if (FirebaseAuth.instance.currentUser == null) {
    print("Sin conexión. Respuestas de '$tipoInventario' guardadas localmente para sincronización posterior.");
    return {"exito": false, "mensaje": "Sin conexión. Respuestas guardadas localmente."};
  }
  try {
    final mapa = ControladorHive.obtenerMapaRespuestasPendientes(usuarioId, tipoInventario);
    if (mapa.isEmpty) {
      print("ℹ️ No hay respuestas pendientes de '$tipoInventario'.");
      return {"exito": false, "mensaje": "Sin cambios por guardar."};
    }
    await subirCuestionario(mapa, tipoInventario.replaceAll("/", ""));
    await ControladorHive.marcarInventarioSincronizado(usuarioId, tipoInventario);
    print("✅ Inventario '$tipoInventario' sincronizado (${mapa.length} respuestas).");
    return {"exito": true, "mensaje": "Inventario '$tipoInventario' sincronizado exitosamente."};
  } catch (e) {
    print("Error al sincronizar '$tipoInventario': ${e.toString()}");
    return {"exito": false, "mensaje": "Error al sincronizar '$tipoInventario': ${e.toString()}"};
  }
}

static Future<void> sincronizarPendientes() async {
  if (FirebaseAuth.instance.currentUser == null) return;
  final usuarioId = FirebaseAuth.instance.currentUser!.uid;
  final completados = ControladorHive.obtInventariosRespondidos(usuarioId);
  for (final tipo in completados) {
    await sincronizarInventario(usuarioId, tipo);
  }
}

static Future<void> cerrarSesion() async {
  try {
    await FirebaseAuth.instance.signOut();
    _sesioncontrolador.idUsuario = "-1";
    _sesioncontrolador.nombreUsuario = "Invitado";
    _sesioncontrolador.correoUsuario = "";
    _sesioncontrolador.datosUsuario = {};
    print("Sesión cerrada exitosamente.");
  } catch (e) {
    print("Error al cerrar sesión: ${e.toString()}");
  }
}

} 
