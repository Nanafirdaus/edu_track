// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetabledata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeTableDataAdapter extends TypeAdapter<TimeTableData> {
  @override
  final int typeId = 1;

  @override
  TimeTableData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeTableData(
      id: fields[0] as String,
      course: fields[1] as Course,
      dateTimeFromTo: (fields[2] as List).cast<DatetimeFromTo>(),
      days: (fields[3] as List).cast<Day>(),
      lecturerName: fields[4] as String,
      venue: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TimeTableData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.course)
      ..writeByte(2)
      ..write(obj.dateTimeFromTo)
      ..writeByte(3)
      ..write(obj.days)
      ..writeByte(4)
      ..write(obj.lecturerName)
      ..writeByte(5)
      ..write(obj.venue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeTableDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
