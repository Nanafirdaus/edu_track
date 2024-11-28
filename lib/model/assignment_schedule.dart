import 'package:hive/hive.dart';
part 'assignment_schedule.g.dart';

@HiveType(typeId: 4)
class AssignmentSchedule {
  @HiveField(0)
  final bool isCompleted;

  @HiveField(1)
  final String assignmentId;

  @HiveField(2)
  final DateTime assignmentDateTime;

  AssignmentSchedule({
    required this.isCompleted,
    required this.assignmentId,
    required this.assignmentDateTime,
  });
}
