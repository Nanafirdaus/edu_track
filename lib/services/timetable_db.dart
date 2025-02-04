import 'package:hive/hive.dart';
import 'package:studybuddy/model/timetabledata.dart';

class TimetableDB {
  Box<TimeTableData> timetableBox;

  TimetableDB({required this.timetableBox});

  Future<void> addToTimetableData(TimeTableData timeTableData) async {
    await timetableBox.put(timeTableData.id, timeTableData);
  }

  Future<void> deleteTimetableData(String id) async {
    await timetableBox.delete(id);
  }

  Future<void> updateTimeTableData(TimeTableData timeTableData) async {
    await timetableBox.put(timeTableData.id, timeTableData);
  }
}
