import 'package:uuid/uuid.dart';
import 'package:mmpi_2/modelos/modelos.dart';
import 'package:mmpi_2/services/hive_service.dart';

class RepositorioDeRespuestas {
  static const _uuid = Uuid();



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
    required String inventoryType,
  }) async {
    final res = Respuestas(
      respuesta: respuesta,
      preguntaID: preguntaID,
      usuarioId: usuarioId,
      tipo: inventoryType
    );

    await HiveService.cajaRespuestas.put(res.key, res);


    print('💾 Respuesta guardada: Q${preguntaID} = $respuesta');
    return res;
  }


  /// Obtener respuestas no sincronizadas
  static List<Respuestas> obtenerRespuestasNoSincronizadas() {
    return HiveService.cajaRespuestas.values
        .cast<Respuestas>()
        .where((response) => !response.sincronizado)
        .toList();
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