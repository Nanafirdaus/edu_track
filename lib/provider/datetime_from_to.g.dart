// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../model/datetime_from_to.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DatetimeFromToAdapter extends TypeAdapter<DatetimeFromTo> {
  @override
  final int typeId = 7;

  @override
  DatetimeFromTo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DatetimeFromTo(
      from: fields[0] as DateTime?,
      to: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DatetimeFromTo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.from)
      ..writeByte(1)
      ..write(obj.to);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatetimeFromToAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
