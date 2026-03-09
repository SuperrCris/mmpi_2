import 'package:mmpi_2/modelos/modelos.dart';
import 'package:mmpi_2/servicios/servicio_hive.dart';

class RepositorioDeRespuestas {



  /// Obtener una respuesta específica por ID
  static Respuestas? obtRespuesta(int id) {
    return HiveService.cajaRespuestas.get(id);
  }

  /// Obtener respuestas por categoría
  static List<Respuestas> obtRespuestasPorTipo(String tipo) {
    return HiveService.cajaRespuestas.values
        .where((respuesta) => respuesta.tipo == tipo)
        .toList();
  }



  /// Contar preguntas de un inventario
  static int conteo(String tipo) {
    return obtRespuestasPorTipo(tipo).length;
  }



  // === RESPUESTAS ===

  /// Guardar respuesta del usuario
  static Future<Respuestas> guardarRespuesta({
    required String usuarioId,
    required int preguntaID,
    required String respuesta,
    required String tipoInventario,
  }) async {
    final res = Respuestas(
      respuesta: respuesta,
      preguntaID: preguntaID,
      usuarioId: usuarioId,
      tipo: tipoInventario
    );

    final key = '${usuarioId}_${tipoInventario}_$preguntaID';
    await HiveService.cajaRespuestas.put(key, res);


    print('💾 Respuesta guardada: [${tipoInventario}] Pregunta${preguntaID} = $respuesta');
    return res;
  }


  /// Obtener respuestas no sincronizadas
  static List<Respuestas> obtenerRespuestasNoSincronizadas() {
    return HiveService.cajaRespuestas.values
        .cast<Respuestas>()
        .where((response) => !response.sincronizado)
        .toList();
  }

  static List<String> obtInventariosRespondidos(String usuarioId) {
    final usuario = HiveService.cajaInfoUsuario.values.firstWhere(
      (user) => user.id.toString() == usuarioId,
      orElse: () => InfoUsuario(id: -2, nombre: 'Invitado', apellido: '', rfc: '', curp: '', correo: ''),
    );

    if (usuario.id != -2) {
      return usuario.invsCompletados;
    } else {
      return [];
    }
  }

  static void marcarInventarioComoCompletado(String usuarioId, String tipoInventario) {
    final usuario = HiveService.cajaInfoUsuario.values.firstWhere(
      (user) => user.id.toString() == usuarioId,
      orElse: () => InfoUsuario(id: -1, nombre: 'Invitado', apellido: '', rfc: '', curp: '', correo: ''),
    );


      if (!usuario.invsCompletados.contains(tipoInventario)) {
        usuario.invsCompletados.add(tipoInventario);
        usuario.save();
        print('✅ Inventario "$tipoInventario" marcado como completado para el usuario ${usuario.nombre}');
      } else {
        print('ℹ️ El inventario "$tipoInventario" ya estaba marcado como completado para el usuario ${usuario.nombre}');
      }
    } 
    
  

  static Future<void> marcarRespuestasComoSincronizadas(List<int> responseIds) async {
    for (final id in responseIds) {
      final response = HiveService.cajaRespuestas.get(id);
      if (response != null) {
        response.sincronizado = true;
        await HiveService.cajaRespuestas.put(id, response);
      }
    }
  }


  /// Marcar respuesta como sincronizada
  static Future<void> marcarComoSincronizada(int respuestaId) async {
    final response = HiveService.cajaRespuestas.get(respuestaId);
    if (response != null) {
      response.sincronizado = true;
      await HiveService.cajaRespuestas.put(respuestaId, response);
    }
  }

  // === UTILIDADES ===

  /// Verificar si una pregunta ya fue respondida
  static bool estaRespondida(String usuarioId, int questionId) {
    return HiveService.cajaRespuestas.values
        .cast<Respuestas>()
        .any((response) => 
            response.usuarioId == usuarioId && 
            response.preguntaID == questionId);
  }

  static List<Respuestas> obtenerRespuestasUsuario(String usuarioId) {
    return HiveService.cajaRespuestas.values
        .cast<Respuestas>()
        .where((response) => response.usuarioId == usuarioId)
        .toList();
  }

  static int obtenerCantidadRespuestasUsuarioYTipo(String usuarioId, String tipoInventario) {
    return HiveService.cajaRespuestas.values
        .cast<Respuestas>()
        .where((respuesta) => respuesta.usuarioId == usuarioId && respuesta.tipo == tipoInventario)
        .toList().length;
  }

  static int obtenerPrimeraPreguntaSinResponder(String usuarioId, String tipoInventario) {
    final respuestasUsuario = HiveService.cajaRespuestas.values
        .cast<Respuestas>()
        .where((respuesta) => respuesta.usuarioId == usuarioId && respuesta.tipo == tipoInventario)
        .toList();

    for (int i = 0; i < 120; i++) {
      if (!respuestasUsuario.any((respuesta) => respuesta.preguntaID == i)) {
        return i; // Retorna el ID de la primera pregunta sin responder
      }
    }
    return -1; // Todas las preguntas han sido respondidas
  }





  /// Limpiar datos de desarrollo
  static Future<void> clearAllData() async {
    await HiveService.clearAllData();
  }

  /// Obtener estadísticas generales
  static Map<String, dynamic> getStats() {
    final almacenamiento = HiveService.obtEstadisticasAlmacenamiento();
    final respuestasNoSincronizadas = obtenerRespuestasNoSincronizadas().length;
    
    return {
      ...almacenamiento,
      'respuestasNoSincronizadas': respuestasNoSincronizadas,
      'esPrimeraEjecucion': HiveService.isFirstRun,
    };
  }
}

// Extensión para firstOrNull (si no está disponible en tu versión de Dart)
extension IterableExtension<T> on Iterable<T> {
  T? get firstOrNull {
    return isEmpty ? null : first;
  }
}