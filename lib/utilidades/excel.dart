import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:mmpi_2/servicios/controlador_hive.dart';


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

static Future<void> crearReporteConPlantilla(Map<String, dynamic> info) async {
  final respuestasPorInventario = await _obtenerRespuestasInventarios();

  ByteData data = await rootBundle.load('recursos/plantilla.xlsx');
  var excel = Excel.decodeBytes(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

     CellStyle estiloCelda = CellStyle(
      horizontalAlign: HorizontalAlign.Center,
      bottomBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: ExcelColor.black),
      leftBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: ExcelColor.black),
      rightBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: ExcelColor.black),
      topBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: ExcelColor.black),
    );

  print("plantilla obtenida");
    for (final entry in respuestasPorInventario.entries) {
      final inventario = entry.key;
      final respuestasInventario = entry.value;
      final configuracionPestana = _diccionarioPestanas[inventario];

      if (configuracionPestana == null) {
        print("Inventario no reconocido: $inventario");
        continue;
      }

      final hojaderesultados = excel[configuracionPestana["nombre"].toString()];
      final int numeroColumnas = configuracionPestana["numeroColumnas"] as int;
      final Map<int, int> respuestasMapeadas = {
        for (int indice = 0; indice < respuestasInventario.length; indice++)
          indice + 1: respuestasInventario[indice],
      };
  

  //Nombre completo
  hojaderesultados.cell(CellIndex.indexByString("B3")).value = TextCellValue(info["nombre"]);
  hojaderesultados.cell(CellIndex.indexByString("B3")).cellStyle = estiloCelda;

  //Grupo
  hojaderesultados.cell(CellIndex.indexByString("B4")).value = TextCellValue(info["grupo"]);
  hojaderesultados.cell(CellIndex.indexByString("B4")).cellStyle = estiloCelda;

  //Edad
  hojaderesultados.cell(CellIndex.indexByString("D4")).value = IntCellValue(info["edad"]);
  hojaderesultados.cell(CellIndex.indexByString("D4")).cellStyle = estiloCelda;

  //Sexo
  hojaderesultados.cell(CellIndex.indexByString("F4")).value = TextCellValue(info["sexo"]);
  hojaderesultados.cell(CellIndex.indexByString("F4")).cellStyle = estiloCelda;

  //Escolaridad
  hojaderesultados.cell(CellIndex.indexByString("B5")).value = TextCellValue(info["escolaridad"]);
  hojaderesultados.cell(CellIndex.indexByString("B5")).cellStyle = estiloCelda;

  //Fecha
  hojaderesultados.cell(CellIndex.indexByString("E5")).value = TextCellValue(info["fecha"]);
  hojaderesultados.cell(CellIndex.indexByString("E5")).cellStyle = estiloCelda;


    const int columnainicial = 1;
    const int filaInicial = 8;
    final int respuestasPorFila = numeroColumnas;

    int saltoColumna = 0;
    int saltoFila = 0;
    

  for (int pregunta = 0; pregunta < respuestasMapeadas.length; pregunta++) {
    hojaderesultados.cell(CellIndex.indexByColumnRow(columnIndex: columnainicial + saltoColumna, rowIndex: filaInicial + saltoFila)).value = IntCellValue(respuestasMapeadas.entries.elementAt(pregunta).key);
    hojaderesultados.cell(CellIndex.indexByColumnRow(columnIndex: columnainicial + saltoColumna + 1, rowIndex: filaInicial + saltoFila)).value = IntCellValue(respuestasMapeadas.entries.elementAt(pregunta).value);
    hojaderesultados.cell(CellIndex.indexByColumnRow(columnIndex: columnainicial + saltoColumna, rowIndex: filaInicial + saltoFila)).cellStyle = estiloCelda;
    hojaderesultados.cell(CellIndex.indexByColumnRow(columnIndex: columnainicial + saltoColumna + 1, rowIndex: filaInicial + saltoFila)).cellStyle = estiloCelda;
    saltoColumna += 2;
    if (saltoColumna >= respuestasPorFila * 2) {
      saltoColumna = 0;
      saltoFila++;
    }
    
    }

  // Guardar el nuevo archivo

}
  excel.save(fileName: 'Reporte_Modificado.xlsx');
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

  respuestas.sort((a, b) => a.preguntaID.compareTo(b.preguntaID));
  return respuestas
      .map((respuesta) => int.tryParse(respuesta.respuesta) ?? -1)
      .where((valor) => valor >= 0)
      .toList();
}
}