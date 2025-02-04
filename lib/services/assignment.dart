import 'package:hive_flutter/hive_flutter.dart';
import 'package:studybuddy/model/assignment_schedule.dart';

class AssignmentDB {
  Box<AssignmentSchedule> assignmentBox;
  static String assignmentKey = "assignmentKey";

  AssignmentDB({required this.assignmentBox});

  Future<void> addAssignment(
      String? id, AssignmentSchedule assignmentSchedule) async {
    await assignmentBox.put(id, assignmentSchedule);
  }

  Future<void> deleteAssignment(String? id) async {
    await assignmentBox.delete(id);
  }

  Future<void> updateAsignment(
      String key, AssignmentSchedule assignment) async {
    await assignmentBox.put(key, assignment);
  }
}
