import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:mmpi_2/servicios/controlador_hive.dart';
import 'package:mmpi_2/utilidades/repositoriopreguntas.dart';


class ExcelUtil {

static final Map<String, Map<String, dynamic>> _diccionarioPestanas = {
  "/inventario_autoevaluacion_aptitudes": {"nombre": "Aptitudes", "numeroColumnas": 12},
  "/inventario_interes_ocupacional": {"nombre": "Intereses Ocup", "numeroColumnas": 13},
  "/inventario_preferencias_universitarias": {"nombre": "IPU 1a parte", "numeroColumnas": 6},
  "/FM": {"nombre": "Fm", "numeroColumnas": 8},
  "/B": {"nombre": "B", "numeroColumnas": 7},
  "/Q": {"nombre": "Q", "numeroColumnas": 7},
  "/A": {"nombre": "A", "numeroColumnas": 9},
  "/S": {"nombre": "S", "numeroColumnas": 6},
  "/H": {"nombre": "H", "numeroColumnas": 10},
};

static Future<Map<String, dynamic>> _obtenerInfoUsuario() async {
  final usuario = FirebaseAuth.instance.currentUser;
  final hoy = DateTime.now();
  final fechaHoy = '${hoy.day.toString().padLeft(2, '0')}/${hoy.month.toString().padLeft(2, '0')}/${hoy.year}';

  if (usuario == null) {
    return {'nombre': 'Invitado', 'edad': null, 'sexo': '', 'fecha': fechaHoy};
  }

  try {
    final doc = await FirebaseFirestore.instance.collection('usuarios').doc(usuario.uid).get();
    if (!doc.exists || doc.data() == null) {
      return {'nombre': 'Invitado', 'edad': null, 'sexo': '', 'fecha': fechaHoy};
    }
    final data = doc.data()!;
    final nombre = '${data['nombre'] ?? ''} ${data['apellido'] ?? ''}'.trim();
    final edadRaw = data['edad'];
    final int? edad = edadRaw is int ? edadRaw : int.tryParse(edadRaw?.toString() ?? '');
    return {
      'nombre': nombre.isEmpty ? 'Invitado' : nombre,
      'edad': edad,
      'sexo': data['sexo']?.toString() ?? '',
      'fecha': fechaHoy,
    };
  } catch (e) {
    print('Error al obtener info de usuario: $e');
    return {'nombre': 'Invitado', 'edad': null, 'sexo': '', 'fecha': fechaHoy};
  }
}

static Future<void> crearReporteConPlantilla() async {
  final info = await _obtenerInfoUsuario();
  final respuestasPorInventario = await _obtenerRespuestasInventarios();

  ByteData data = await rootBundle.load('recursos/plantilla.xlsx');
  var excel = Excel.decodeBytes(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

  print("plantilla obtenida");
  for (final entry in respuestasPorInventario.entries) {
    final inventario = entry.key;
    final respuestasInventario = entry.value;
    print("Obteniendo solo las llaves para el inventario: $inventario");
    final List<int> llavesRespuestas = obtenerSoloLlaves(inventario);

    final configuracionPestana = _diccionarioPestanas[inventario];
    print("$inventario  .llaves respuestas: $llavesRespuestas");
    if (configuracionPestana == null) {
      print("Inventario no reconocido: $inventario");
      continue;
    }

    final hojaderesultados = excel[configuracionPestana["nombre"].toString()];
    final int numeroColumnas = configuracionPestana["numeroColumnas"] as int;
    final Map<int, int> respuestasMapeadas = {
      for (int indice = 0; indice < respuestasInventario.length; indice++)
        (llavesRespuestas.length > indice ? llavesRespuestas[indice] : indice + 1):
            respuestasInventario[indice] + 1,
    };

    //Nombre completo
    _escribirCelda(hojaderesultados, CellIndex.indexByString("B3"), TextCellValue(info["nombre"]));

    //Grupo
   // _escribirCelda(hojaderesultados, CellIndex.indexByString("B4"), TextCellValue(info["grupo"]));

    //Edad
    final edadInfo = info["edad"];
    if (edadInfo is int) {
      _escribirCelda(hojaderesultados, CellIndex.indexByString("D4"), IntCellValue(edadInfo));
    } else {
      _escribirCelda(hojaderesultados, CellIndex.indexByString("D4"), TextCellValue(''));
    }

    //Sexo
    _escribirCelda(hojaderesultados, CellIndex.indexByString("F4"), TextCellValue(info["sexo"] ?? ''));

    //Escolaridad
    //_escribirCelda(hojaderesultados, CellIndex.indexByString("B5"), TextCellValue(info["escolaridad"]));

    //Fecha
    _escribirCelda(hojaderesultados, CellIndex.indexByString("E5"), TextCellValue(info["fecha"]));

    const int columnainicial = 1;
    const int filaInicial = 8;
    final int respuestasPorFila = numeroColumnas;

    int saltoColumna = 0;
    int saltoFila = 0;

    for (int pregunta = 0; pregunta < respuestasMapeadas.length; pregunta++) {
      _escribirCelda(hojaderesultados,
          CellIndex.indexByColumnRow(columnIndex: columnainicial + saltoColumna, rowIndex: filaInicial + saltoFila),
          IntCellValue(respuestasMapeadas.entries.elementAt(pregunta).key));
      _escribirCelda(hojaderesultados,
          CellIndex.indexByColumnRow(columnIndex: columnainicial + saltoColumna + 1, rowIndex: filaInicial + saltoFila),
          IntCellValue(respuestasMapeadas.entries.elementAt(pregunta).value));
      saltoColumna += 2;
      if (saltoColumna >= respuestasPorFila * 2) {
        saltoColumna = 0;
        saltoFila++;
      }
    }
  }

  excel.save(fileName: 'Mi_Reporte_${info["nombre"]}_${DateTime.now().millisecondsSinceEpoch}.xlsx');
}

static void _escribirCelda(Sheet hoja, CellIndex indice, CellValue valor) {
  final celda = hoja.cell(indice);
  final estiloExistente = celda.cellStyle;
  celda.value = valor;
  final estilo = estiloExistente ?? CellStyle();
  estilo.horizontalAlignment = HorizontalAlign.Center;
  celda.cellStyle = estilo;
}

static Future<Map<String, List<int>>> _obtenerRespuestasInventarios() async {
  final respuestas = <String, List<int>>{};

  for (final inventario in _diccionarioPestanas.keys) {
    final desdeFirebase = await _obtenerRespuestasDesdeFirebase(inventario);
    if (desdeFirebase.isNotEmpty) {
      respuestas[inventario] = desdeFirebase;
      continue;
    }

    final desdeHive = _obtenerRespuestasDesdeHive(inventario);
    if (desdeHive.isNotEmpty) {
      respuestas[inventario] = desdeHive;
    }
  }

  return respuestas;
}

static Future<List<int>> _obtenerRespuestasDesdeFirebase(String tipoInventario) async {
  final usuario = FirebaseAuth.instance.currentUser;
  if (usuario == null) {
    return [];
  }

  try {
    final doc = await FirebaseFirestore.instance
        .collection('cuestionarios')
        .doc(usuario.uid)
        .collection(tipoInventario.replaceAll('/', ''))
        .doc('respuestas')
        .get();

    if (!doc.exists) {
      return [];
    }

    final data = doc.data();
    if (data == null) {
      return [];
    }

    final respuestas = data['respuestas'];
    if (respuestas is List) {
      return respuestas.map((e) => (e as num).toInt()).toList();
    }

    if (respuestas is Map) {
      final entries = respuestas.entries.toList()
        ..sort((a, b) => int.parse(a.key.toString()).compareTo(int.parse(b.key.toString())));
      return entries.map((e) => (e.value as num).toInt()).toList();
    }

    return [];
  } catch (e) {
    print("Error al obtener '$tipoInventario' desde Firebase: $e");
    return [];
  }
}

static List<int> _obtenerRespuestasDesdeHive(String tipoInventario) {
  final usuarioId = FirebaseAuth.instance.currentUser?.uid;
  final respuestas = usuarioId == null
      ? ControladorHive.obtRespuestasPorTipo(tipoInventario)
      : ControladorHive.obtenerRespuestasUsuario(usuarioId)
          .where((respuesta) => respuesta.tipo == tipoInventario)
          .toList();

  final llaves = obtenerSoloLlaves(tipoInventario);
  final mapaRespuestas = {
    for (final r in respuestas) r.preguntaID: int.tryParse(r.respuesta) ?? -1,
  };

  return llaves
      .map((key) => mapaRespuestas[key] ?? -1)
      .where((valor) => valor >= 0)
      .toList();
}
}
