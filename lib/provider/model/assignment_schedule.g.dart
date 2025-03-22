// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment_schedule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssignmentScheduleAdapter extends TypeAdapter<AssignmentSchedule> {
  @override
  final int typeId = 5;

  @override
  AssignmentSchedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssignmentSchedule(
      isCompleted: fields[0] as bool,
      courseId: fields[1] as String,
      assignmentDateTime: fields[2] as DateTime,
      description: fields[3] as String,
      assignmentId: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AssignmentSchedule obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.isCompleted)
      ..writeByte(1)
      ..write(obj.courseId)
      ..writeByte(2)
      ..write(obj.assignmentDateTime)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.assignmentId);
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
