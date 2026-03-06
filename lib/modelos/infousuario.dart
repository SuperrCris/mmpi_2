import 'package:hive/hive.dart';

part 'infousuario.g.dart';

@HiveType(typeId: 1)
class InfoUsuario extends HiveObject {
  @HiveField(0)
  int id; 

  @HiveField(1)
  String nombre;

  @HiveField(2)
  String apellido;

  @HiveField(3)
  String rfc;

  @HiveField(4)
  String curp;

  @HiveField(5)
  String correo;

  InfoUsuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.rfc,
    required this.curp,
    required this.correo,
  });

  factory InfoUsuario.desdeJson(Map<String, dynamic> json) {
    return InfoUsuario(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      rfc: json['rfc'],
      curp: json['curp'],
      correo: json['correo'],
    );
  }

  Map<String, dynamic> aJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'rfc': rfc,
      'curp': curp,
      'correo': correo,
    };
  }
}

