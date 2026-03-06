// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'infousuario.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InfoUsuarioAdapter extends TypeAdapter<InfoUsuario> {
  @override
  final int typeId = 1;

  @override
  InfoUsuario read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InfoUsuario(
      id: fields[0] as int,
      nombre: fields[1] as String,
      apellido: fields[2] as String,
      rfc: fields[3] as String,
      curp: fields[4] as String,
      correo: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, InfoUsuario obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nombre)
      ..writeByte(2)
      ..write(obj.apellido)
      ..writeByte(3)
      ..write(obj.rfc)
      ..writeByte(4)
      ..write(obj.curp)
      ..writeByte(5)
      ..write(obj.correo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfoUsuarioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
