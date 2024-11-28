// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_schedule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CourseScheduleAdapter extends TypeAdapter<CourseSchedule> {
  @override
  final int typeId = 3;

  @override
  CourseSchedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CourseSchedule(
      courseScheduleId: fields[0] as String,
      courseDateTime: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CourseSchedule obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.courseScheduleId)
      ..writeByte(1)
      ..write(obj.courseDateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
