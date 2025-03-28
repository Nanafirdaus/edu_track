// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'days_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayAdapter extends TypeAdapter<Day> {
  @override
  final int typeId = 10;

  @override
  Day read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Day.monday;
      case 1:
        return Day.tuesday;
      case 2:
        return Day.wednesday;
      case 3:
        return Day.thursday;
      case 4:
        return Day.friday;
      default:
        return Day.monday;
    }
  }

  @override
  void write(BinaryWriter writer, Day obj) {
    switch (obj) {
      case Day.monday:
        writer.writeByte(0);
        break;
      case Day.tuesday:
        writer.writeByte(1);
        break;
      case Day.wednesday:
        writer.writeByte(2);
        break;
      case Day.thursday:
        writer.writeByte(3);
        break;
      case Day.friday:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
