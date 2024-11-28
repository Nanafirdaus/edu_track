// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecturer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LecturerAdapter extends TypeAdapter<Lecturer> {
  @override
  final int typeId = 1;

  @override
  Lecturer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lecturer(
      lecturerId: fields[0] as String,
      lecturerContact: fields[2] as int,
      lecturerName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Lecturer obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.lecturerId)
      ..writeByte(1)
      ..write(obj.lecturerName)
      ..writeByte(2)
      ..write(obj.lecturerContact);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LecturerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
