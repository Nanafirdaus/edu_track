import 'package:hive/hive.dart';
part 'course_schedule.g.dart';

@HiveType(typeId: 3)
class CourseSchedule {
  @HiveField(0)
  final String courseScheduleId;

  @HiveField(1)
  final DateTime courseDateTime;

  CourseSchedule({
    required this.courseScheduleId,
    required this.courseDateTime,
  });
}
