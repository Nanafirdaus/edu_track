import 'package:hive/hive.dart';

part 'datetime_from_to.g.dart';

@HiveType(typeId: 7)
class DatetimeFromTo {
  @HiveField(0)
  final DateTime? from;
  @HiveField(1)
  final DateTime? to;

  DatetimeFromTo({required this.from, required this.to});

  DatetimeFromTo copyWith({DateTime? from, DateTime? to}) {
    return DatetimeFromTo(
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }
}
