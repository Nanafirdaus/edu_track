import 'package:hive/hive.dart';
part 'assignment_schedule.g.dart';

@HiveType(typeId: 5)
class AssignmentSchedule {
  @HiveField(0)
  final bool isCompleted;

  @HiveField(1)
  final String courseId;

  @HiveField(2)
  final DateTime assignmentDateTime;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String assignmentId;

  AssignmentSchedule({
    required this.isCompleted,
    required this.courseId,
    required this.assignmentDateTime,
    required this.description,
    required this.assignmentId,
  });
}
