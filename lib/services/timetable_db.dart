import 'package:hive/hive.dart';
import 'package:studybuddy/model/timetabledata.dart';

class TimetableDB {
  static final TimetableDB _instance = TimetableDB._internal();
  late Box<TimeTableData> timetableBox;

  TimetableDB._internal();

  factory TimetableDB({Box<TimeTableData>? box}) {
    _instance.init(box!);
    return _instance;
  }

  Future<void> init(Box<TimeTableData> box) async {
    timetableBox = box;
  }

  Future<void> addToTimetableData(TimeTableData timeTableData) async {
    await timetableBox.put(timeTableData.id, timeTableData);
  }

  Future<void> deleteTimetableData(String id) async {
    await timetableBox.delete(id);
  }

  Future<void> deleteAllTimetableData() async {
    await timetableBox.clear();
  }

  Future<void> updateTimetableData(TimeTableData timeTableData) async {
    await timetableBox.put(timeTableData.id, timeTableData);
  }
}
