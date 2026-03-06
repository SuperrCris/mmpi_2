import 'package:hive/hive.dart';

part 'respuesta.g.dart';

@HiveType(typeId: 2)
class Respuestas extends HiveObject {
  @HiveField(0)
  int preguntaID;

  @HiveField(1)
  String respuesta;

  @HiveField(2)
  String tipo; 

  @HiveField(3)
  bool sincronizado;

  @HiveField(4)
  String usuarioId;

  Respuestas({
    required this.preguntaID,
    required this.respuesta,
    required this.tipo,
    required this.usuarioId,
    this.sincronizado = false,
  });


  factory Respuestas.desdeJson(Map<String, dynamic> json) {
    return Respuestas(
      preguntaID: json['preguntaID'],
      respuesta: json['respuesta'],
      tipo: json['tipo'],
      usuarioId: json['usuarioId'],
    );
  }

  Map<String, dynamic> aJson() {
    return {
      'preguntaID': preguntaID,
      'respuesta': respuesta,
      'tipo': tipo,
      'usuarioId': usuarioId,
    };
  }
}

