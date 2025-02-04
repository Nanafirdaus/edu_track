import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:studybuddy/model/assignment_schedule.dart';
import 'package:studybuddy/model/hive_boxes.dart';
import 'package:studybuddy/services/assignment.dart';

class AssignmentProvider extends ChangeNotifier {
  AssignmentDB? assignmentDB;
  List<AssignmentSchedule> assignments = [];

  AssignmentProvider() {
    assignmentDB =
        AssignmentDB(assignmentBox: Hive.box(HiveBoxes.assignmentScheduleBox));
    assignments = assignmentDB!.assignmentBox.values.toList();
    notifyListeners();
  }

  void addAssignment(AssignmentSchedule assignment) async {
    await assignmentDB!.addAssignment(assignment.assignmentId, assignment);
    assignments = assignmentDB!.assignmentBox.values.toList();
    notifyListeners();
  }

  void toggleCompletedStatus(String id, bool val) async {
    AssignmentSchedule assignment =
        assignments.firstWhere((assignment) => assignment.assignmentId == id);
    final newAssignment =
        assignment.copyWith(isCompleted: val);
    await assignmentDB!.updateAsignment(id, newAssignment);
      assignments = assignmentDB!.assignmentBox.values.toList();
    notifyListeners();
  }
}
