
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mmpi_2/modelos/infousuario.dart';
import 'package:mmpi_2/servicios/controlador_hive.dart';

class SesionControlador {


  String idUsuario = "-1";
  String nombreUsuario = "Invitado";
  String correoUsuario = "";
  
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
          return {"exito": false, "mensaje": "Correo electrónico no válido."};
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
          _sesioncontrolador.idUsuario = FirebaseAuth.instance.currentUser!.uid;
          _sesioncontrolador.nombreUsuario = doc.data()!['nombre'] ?? "";
        } else {print("No se encontraron datos adicionales para el usuario.");}

        if (ControladorHive.obtenerInfoUsuario(FirebaseAuth.instance.currentUser!.uid) == null) {
          ControladorHive.crearUsuario( 
          InfoUsuario(id: FirebaseAuth.instance.currentUser!.uid, nombre: _sesioncontrolador.nombreUsuario, apellido: "", rfc: "", curp: "", correo: _sesioncontrolador.datosUsuario['correo'] ?? ""));
        }

        
      });
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

  

}