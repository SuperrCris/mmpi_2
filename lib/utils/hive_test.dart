import 'package:mmpi_2/modelos/modelos.dart';
import 'package:mmpi_2/services/hive_service.dart';

/// Utilidad para probar que Hive funciona correctamente
class HiveTest {
  
  /// Probar guardado y lectura de respuestas
  static Future<void> probarRespuestas() async {
    try {
      print('🧪 Probando guardado de respuestas...');
      
      // Crear respuesta de prueba
      final respuesta = Respuestas(
        preguntaID: 1,
        respuesta: "Verdadero",
        tipo: "mmpi2",
        usuarioId: "usuario_test",
        sincronizado: false,
      );
      
      // Guardar en Hive
      final box = HiveService.cajaRespuestas;
      await box.add(respuesta);
      print('✅ Respuesta guardada: ${respuesta.respuesta}');
      
      // Leer de Hive
      final respuestasGuardadas = box.values.toList();
      print('📖 Respuestas en Hive: ${respuestasGuardadas.length}');
      
      if (respuestasGuardadas.isNotEmpty) {
        final primera = respuestasGuardadas.first;
        print('   📝 Primera respuesta: P${primera.preguntaID} = ${primera.respuesta}');
        print('   👤 Usuario: ${primera.usuarioId}');
        print('   🔄 Sincronizado: ${primera.sincronizado}');
      }
      
    } catch (e) {
      print('❌ Error en prueba de respuestas: $e');
    }
  }
  
  /// Probar guardado y lectura de usuario
  static Future<void> probarUsuario() async {
    try {
      print('🧪 Probando guardado de usuario...');
      
      // Crear usuario de prueba
      final usuario = InfoUsuario(
        id: 1,
        nombre: "Juan",
        apellido: "Pérez",
        rfc: "PEJX800101XXX",
        curp: "PEJX800101HDFXXX01",
        correo: "juan@test.com",
      );
      
      // Guardar en Hive
      final box = HiveService.cajaInfoUsuario;
      await box.put("usuario_1", usuario);
      print('✅ Usuario guardado: ${usuario.nombre} ${usuario.apellido}');
      
      // Leer de Hive
      final usuarioGuardado = box.get("usuario_1");
      if (usuarioGuardado != null) {
        print('📖 Usuario leído: ${usuarioGuardado.nombre} ${usuarioGuardado.apellido}');
        print('   📧 Correo: ${usuarioGuardado.correo}');
      }
      
    } catch (e) {
      print('❌ Error en prueba de usuario: $e');
    }
  }
  
  /// Ejecutar todas las pruebas
  static Future<void> ejecutarTodasLasPruebas() async {
    print('🚀 Iniciando pruebas de Hive...');
    
    await probarRespuestas();
    print('');
    await probarUsuario();
    
    print('');
    print('📊 Estadísticas de Hive:');
    print('   📝 Respuestas: ${HiveService.cajaRespuestas.length}');
    print('   👤 Usuarios: ${HiveService.cajaInfoUsuario.length}');
    
    print('✅ Pruebas completadas');
  }
  
  /// Limpiar datos de prueba
  static Future<void> limpiarDatosPrueba() async {
    print('🧹 Limpiando datos de prueba...');
    
    await HiveService.cajaRespuestas.clear();
    await HiveService.cajaInfoUsuario.clear();
    
    print('✅ Datos limpiados');
  }
  
  /// Ejemplo de cómo guardar una respuesta MMPI real
  static Future<void> ejemploRespuestaMMPI({
    required String usuarioId,
    required int numeroPregunta,
    required bool respuestaVerdaderoFalso,
  }) async {
    
    final respuesta = Respuestas(
      preguntaID: numeroPregunta,
      respuesta: respuestaVerdaderoFalso ? "Verdadero" : "Falso",
      tipo: "mmpi2",
      usuarioId: usuarioId,
      sincronizado: false, // Se marcará como true cuando se envíe al servidor
    );
    
    // Guardar en Hive
    await HiveService.cajaRespuestas.add(respuesta);
    
    print('💾 Respuesta MMPI guardada: P$numeroPregunta = ${respuesta.respuesta}');
  }
}