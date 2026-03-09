
import 'package:mmpi_2/servicios/respuestas_hive.dart';
import 'package:mmpi_2/servicios/servicio_hive.dart';

class ServicioDeInicializacionDatos {
  
  /// Inicializar todas las respuestas por defecto
  static Future<void> iniciarDatosPorDefecto() async {
    try {
      print('🚀 Iniciando carga de datos por defecto...');

      // Verificar si es la primera vez que se ejecuta la app
      if (HiveService.isFirstRun) {
        await HiveService.marcarPrimeraEjecucion();
        print('✅ Primera ejecución: datos inicializados');
      } else {
        print('ℹ️ App ya inicializada anteriormente');
        
        // Verificar si las preguntas MMPI están disponibles
        if (!HiveService.estanRespuestasCargadas('vocacional')) {
          print('⚠️ Preguntas MMPI no encontradas, recargando...');
        }
      }

      _imprimirResumenDeDatos();
      
    } catch (e) {
      print('❌ Error al inicializar datos: $e');
      throw e;
    }
  }



  /// Forzar recarga de datos (útil para desarrollo)
  static Future<void> forceReloadData() async {
    print('🔄 Forzando recarga de datos...');
    
    // Limpiar solo datos de preguntas manteniendo sesiones y respuestas
    final questionsBox = HiveService.cajaRespuestas;
    await questionsBox.clear();


    print('✅ Datos recargados exitosamente');
    _imprimirResumenDeDatos();
  }

  /// Mostrar resumen de datos cargados
  static void _imprimirResumenDeDatos() {
    final stats = RepositorioDeRespuestas.getStats();
    print('📊 RESUMEN DE DATOS:');
    print('   📝 Respuestas: ${stats['respuestas']} (${stats['respuestasNoSincronizadas']} sin sincronizar)');

  }


  /// Limpiar todos los datos (útil para testing)
  static Future<void> clearAllData() async {
    await RepositorioDeRespuestas.clearAllData();
    await HiveService.saveSetting('isFirstRun', true);
    print('🗑️ Todos los datos eliminados. La app requerirá inicialización.');
  }

}