import 'package:mmpi_2/modelos/modelos.dart';
import 'package:mmpi_2/servicios/servicio_hive.dart';
import 'package:mmpi_2/utilidades/repositoriopreguntas.dart';

class ControladorHive {

static Future<void> crearUsuario(InfoUsuario usuario) async {
    try {
      await HiveService.cajaInfoUsuario.add(usuario);
      print('👤 Usuario "${usuario.nombre}" creado en Hive con ID: ${usuario.id}');
    } catch (e) {
      print('❌ Error al crear usuario en Hive: $e');
    }
  }

//Busqueda del usuario en Hive por ID, si no se encuentra retorna un usuario con id -2 
static InfoUsuario obtenerInfoUsuario(String usuarioId) {
    return HiveService.cajaInfoUsuario.values
        .cast<InfoUsuario>()
        .firstWhere((user) => user.id == usuarioId, orElse: () => InfoUsuario(id: "-1", nombre: 'Invitado', apellido: '', rfc: '', curp: '', correo: ''));
  }

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
      tipo: tipoInventario,
      sincronizado: false,
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
      (user) => user.id == usuarioId,
      orElse: () => InfoUsuario(id: "-2", nombre: 'Invitado', apellido: '', rfc: '', curp: '', correo: ''),
    );

    if (usuario.id != "-2") {
      return usuario.invsCompletados;
    } else {
      return [];
    }
  }

  static void marcarInventarioComoCompletado(String usuarioId, String tipoInventario) {
    final usuario = HiveService.cajaInfoUsuario.values.firstWhere(
      (user) => user.id.toString() == usuarioId,
      orElse: () => InfoUsuario(id: "-1", nombre: 'Invitado', apellido: '', rfc: '', curp: '', correo: ''),
    );


      if (!usuario.invsCompletados.contains(tipoInventario)) {
        usuario.invsCompletados.add(tipoInventario);
        print('✅ Inventario "$tipoInventario" marcado como completado para el usuario ${usuario.nombre}');
      } else {
        print('ℹ️ El inventario "$tipoInventario" ya estaba marcado como completado para el usuario ${usuario.nombre}');
      }
       usuario.save();
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

    for (int i = 0; i < tamanoInventario(tipoInventario); i++) {
      if (!respuestasUsuario.any((respuesta) => respuesta.preguntaID == i)) {
        return i; // Retorna el ID de la primera pregunta sin responder
      }
    }
    return -1; // Todas las preguntas han sido respondidas
  }


  /// Construir mapa de respuestas pendientes de sincronizar para Firebase
  static Map<String, dynamic> obtenerMapaRespuestasPendientes(String usuarioId, String tipoInventario) {
    final pendientes = HiveService.cajaRespuestas.values
        .cast<Respuestas>()
        .where((r) => r.usuarioId == usuarioId && r.tipo == tipoInventario && !r.sincronizado)
        .toList();
    return { for (final r in pendientes) r.preguntaID.toString(): int.tryParse(r.respuesta) ?? -1 };
  }

  /// Marcar todas las respuestas de un inventario como sincronizadas
  static Future<void> marcarInventarioSincronizado(String usuarioId, String tipoInventario) async {
    final caja = HiveService.cajaRespuestas;
    for (final key in caja.keys) {
      final r = caja.get(key);
      if (r != null && r.usuarioId == usuarioId && r.tipo == tipoInventario && !r.sincronizado) {
        r.sincronizado = true;
        await r.save();
      }
    }
  }

  /// Borrar todas las respuestas de un inventario y desmarcarlo como completado
  static Future<void> reiniciarInventario(String usuarioId, String tipoInventario) async {
    final caja = HiveService.cajaRespuestas;
    final keysToDelete = caja.keys
        .where((key) {
          final r = caja.get(key);
          return r != null && r.usuarioId == usuarioId && r.tipo == tipoInventario;
        })
        .toList();
    for (final key in keysToDelete) {
      await caja.delete(key);
    }
    final usuario = HiveService.cajaInfoUsuario.values.firstWhere(
      (user) => user.id == usuarioId,
 );
    if (usuario.id != '-1') {
      print("Borrando inventario '$tipoInventario' para el usuario ${usuario.nombre} con ID ${usuario.id}");
      usuario.invsCompletados.remove(tipoInventario);
      await usuario.save();
    }
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