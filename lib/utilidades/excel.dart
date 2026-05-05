import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;


class ExcelUtil {

static Future<void> crearReporteConPlantilla(Map<String, dynamic> info) async {
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

  Sheet sheetObject = excel['Aptitudes'];

  //Nombre completo
  sheetObject.cell(CellIndex.indexByString("B3")).value = TextCellValue(info["nombre"]);
  sheetObject.cell(CellIndex.indexByString("B3")).cellStyle = estiloCelda;

  //Grupo
  sheetObject.cell(CellIndex.indexByString("B4")).value = TextCellValue(info["grupo"]);
  sheetObject.cell(CellIndex.indexByString("B4")).cellStyle = estiloCelda;

  //Edad
  sheetObject.cell(CellIndex.indexByString("D4")).value = IntCellValue(info["edad"]);
  sheetObject.cell(CellIndex.indexByString("D4")).cellStyle = estiloCelda;

  //Sexo
  sheetObject.cell(CellIndex.indexByString("F4")).value = TextCellValue(info["sexo"]);
  sheetObject.cell(CellIndex.indexByString("D4")).cellStyle = estiloCelda;

  //Escolaridad
  sheetObject.cell(CellIndex.indexByString("B5")).value = TextCellValue(info["escolaridad"]);
  sheetObject.cell(CellIndex.indexByString("D4")).cellStyle = estiloCelda;

  //Fecha
  sheetObject.cell(CellIndex.indexByString("E5")).value = TextCellValue(info["fecha"]);
  sheetObject.cell(CellIndex.indexByString("D4")).cellStyle = estiloCelda;


    const int columnainicial = 1;
    const int filaInicial = 8;
    const int respuestasPorFila = 12;

    int saltoColumna = 0;
    int saltoFila = 0;
    
    
  for (int pregunta = 0; pregunta < info["respuestas"].length; pregunta++) {
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: columnainicial + saltoColumna, rowIndex: filaInicial + saltoFila)).value = IntCellValue(pregunta + 1);
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: columnainicial + saltoColumna + 1, rowIndex: filaInicial + saltoFila)).value = IntCellValue(info["respuestas"][pregunta]);
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: columnainicial + saltoColumna, rowIndex: filaInicial + saltoFila)).cellStyle = estiloCelda;
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: columnainicial + saltoColumna + 1, rowIndex: filaInicial + saltoFila)).cellStyle = estiloCelda;
    saltoColumna += 2;
    if (saltoColumna >= respuestasPorFila * 2) {
      saltoColumna = 0;
      saltoFila++;
    }
    
  }


  // Guardar el nuevo archivo
  excel.save(fileName: 'Reporte_Modificado.xlsx');
}
}