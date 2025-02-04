import 'package:hive/hive.dart';

part 'days_enum.g.dart';

@HiveType(typeId: 10)
enum Day {
  @HiveField(0)
  monday,
  @HiveField(1)
  tuesday,
  @HiveField(2)
  wednesday,
  @HiveField(3)
  thursday,
  @HiveField(4)
  friday;
}

extension DateTimeExts on List<Day> {
  bool containsToday() {
    return contains(switch (DateTime.now().day) {
      1 => Day.monday,
      2 => Day.tuesday,
      3 => Day.wednesday,
      4 => Day.thursday,
      5 => Day.friday,
      _ => null
    });
  }
}
