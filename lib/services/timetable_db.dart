import 'package:hive/hive.dart';
import 'package:studybuddy/provider/model/timetabledata.dart';

class TimetableDB {
  Box<TimeTableData> timetableBox;

  TimetableDB({required this.timetableBox});

  /// Add a new timetable entry
  Future<void> addToTimetableData(TimeTableData timeTableData) async {
    await timetableBox.put(timeTableData.id, timeTableData);
  }

  /// Delete a specific timetable entry by ID
  Future<void> deleteTimetableData(String id) async {
    await timetableBox.delete(id);
  }

  /// Delete all timetables
  Future<void> deleteAllTimetableData() async {
    await timetableBox.clear();
  }

  /// Update an existing timetable entry
  Future<void> updateTimetableData(TimeTableData timeTableData) async {
    await timetableBox.put(timeTableData.id, timeTableData);
  }
}
