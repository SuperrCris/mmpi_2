// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'respuesta.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RespuestasAdapter extends TypeAdapter<Respuestas> {
  @override
  final int typeId = 2;

  @override
  Respuestas read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Respuestas(
      preguntaID: fields[0] as int,
      respuesta: fields[1] as String,
      tipo: fields[2] as String,
      usuarioId: fields[4] as String,
      sincronizado: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Respuestas obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.preguntaID)
      ..writeByte(1)
      ..write(obj.respuesta)
      ..writeByte(2)
      ..write(obj.tipo)
      ..writeByte(3)
      ..write(obj.sincronizado)
      ..writeByte(4)
      ..write(obj.usuarioId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RespuestasAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
