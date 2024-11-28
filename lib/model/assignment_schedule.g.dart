// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment_schedule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssignmentScheduleAdapter extends TypeAdapter<AssignmentSchedule> {
  @override
  final int typeId = 4;

  @override
  AssignmentSchedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssignmentSchedule(
      isCompleted: fields[0] as bool,
      assignmentId: fields[1] as String,
      assignmentDateTime: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AssignmentSchedule obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.isCompleted)
      ..writeByte(1)
      ..write(obj.assignmentId)
      ..writeByte(2)
      ..write(obj.assignmentDateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssignmentScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
