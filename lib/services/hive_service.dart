import 'package:hive_flutter/hive_flutter.dart';
import 'package:mmpi_2/modelos/modelos.dart';

class HiveService {
  static const String _nombreCajaRespuestas = 'respuestas';
  static const String _nombreCajaInfoUsuario = 'usuario';
  static const String _nombreCajaOpciones = 'opciones';

  static Box<Respuestas>? _cajaRespuestas;
  static Box<InfoUsuario>? _cajaInfoUsuario;
  static Box<dynamic>? _cajaOpciones;

  // Getters para acceder a las cajas
  static Box<Respuestas> get cajaRespuestas => _cajaRespuestas!;
  static Box<InfoUsuario> get cajaInfoUsuario => _cajaInfoUsuario!;

  static Future<void> initialize() async {
    try {
      // Abrir todas las cajas de Hive
      _cajaRespuestas = await Hive.openBox<Respuestas>(_nombreCajaRespuestas);
      _cajaInfoUsuario = await Hive.openBox<InfoUsuario>(_nombreCajaInfoUsuario);
      _cajaOpciones = await Hive.openBox<dynamic>(_nombreCajaOpciones);
      print('✅ Hive inicializado correctamente');
      print('   📚 Preguntas: ${_cajaRespuestas!.length}');
      print('   📝 Respuestas: ${_cajaInfoUsuario!.length}');
      print('   ⚙️ Opciones: ${_cajaOpciones!.length}');
    } catch (e) {
      print('❌ Error al inicializar Hive: $e');
      throw e;
    }
  }

  // Verificar si las respuestas están cargadas
  static bool estanRespuestasCargadas(String inventoryType) {
    return _cajaRespuestas?.values
        .any((respuesta) => respuesta.tipo == inventoryType) ?? false;
  }

  // Obtener estadísticas de almacenamiento
  static Map<String, int> obtEstadisticasAlmacenamiento() {
    return {
      'respuestas': _cajaRespuestas?.length ?? 0,
      'infoUsuario': _cajaInfoUsuario?.length ?? 0,
    };
  }

  // Limpiar todos los datos (útil para desarrollo)
  static Future<void> clearAllData() async {
    await _cajaRespuestas?.clear();
    await _cajaInfoUsuario?.clear();
    print('🗑️ Todos los datos de Hive han sido eliminados');
  }

  // Limpiar solo respuestas y sesiones (mantener preguntas)
  static Future<void> clearUserData() async {
    await _cajaRespuestas?.clear();
    await _cajaInfoUsuario?.clear();
    print('🗑️ Datos de usuario eliminados');
  }

  // Cerrar todas las cajas
  static Future<void> close() async {
    await _cajaRespuestas?.close();
    await _cajaInfoUsuario?.close();
    print('📦 Cajas de Hive cerradas');
  }

  // Obtener configuración
  static T? getSetting<T>(String key, {T? defaultValue}) {
    return _cajaOpciones?.get(key, defaultValue: defaultValue);
  }

  // Guardar configuración
  static Future<void> saveSetting(String key, dynamic value) async {
    await _cajaOpciones?.put(key, value);
  }

  // Verificar si es la primera vez que se ejecuta la app
  static dynamic get isFirstRun {
    return getSetting('primeraEjecucion', defaultValue: true);
  }

  // Marcar que la app ya se ejecutó
  static Future<void> marcarPrimeraEjecucion() async {
    await saveSetting('primeraEjecucion', false);
  }
}