import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:studybuddy/model/course.dart';
import 'package:studybuddy/model/datetime_from_to.dart';
import 'package:studybuddy/model/hive_boxes.dart';
import 'package:studybuddy/model/timetabledata.dart';
import 'package:studybuddy/services/hive_db.dart';
import 'package:studybuddy/services/timetable_db.dart';
import 'package:studybuddy/utils/days_enum.dart';
import 'package:uuid/uuid.dart';

class TimeTableProvider extends ChangeNotifier {
  TimetableDB? _timetableDB;
  UserDataDB? _userDataDB;
  bool? timeTableCreated;
  List<TimeTableData> timetableDataList = [];

  TimeTableProvider() {
    _timetableDB = TimetableDB(timetableBox: Hive.box(HiveBoxes.timetableBox));
    _userDataDB = UserDataDB(userBox: Hive.box(HiveBoxes.userBox));
    timeTableCreated = _timetableDB!.timetableBox.isNotEmpty;
    timetableDataList = timeTableCreated! ? _timetableDB!.timetableBox.values.toList() :  List.generate(
        _userDataDB!.userBox.values.first.userCourses.length, (index) {
      return TimeTableData(
        id: const Uuid().v4(),
        course: _userDataDB!.userBox.values.first.userCourses[index],
        dateTimeFromTo: [],
        days: [],
        lecturerName: '',
        venue: '',
      );
    });
    //: _timetableDB!.timetableBox.values.toList();
    notifyListeners();
  }

  void addTimetableData(TimeTableData data) {
    timetableDataList.add(data);
    notifyListeners();
  }

  void updateTimetableData(int index, TimeTableData data) {
    timetableDataList[index] = data;
    notifyListeners();
  }

  void updateDays(Day day, int index) {
    log(Day.values.indexOf(day).toString());
    if (!timetableDataList[index].days.contains(day)) {
      timetableDataList[index] = timetableDataList[index].copyWith(days: [
        ...timetableDataList[index].days,
        day
      ], dateTimeFromTo: [
        ...timetableDataList[index].dateTimeFromTo,
        DatetimeFromTo(
          from: null,
          to: null,
        )
      ]);
    } else {
      var dateTimeTos = timetableDataList[index].dateTimeFromTo;
      var days = timetableDataList[index].days;
      dateTimeTos.remove(dateTimeTos[days.indexOf(day)]);
      days.remove(day);
      log(days.toString());
      timetableDataList[index] = timetableDataList[index].copyWith(
        days: days,
        dateTimeFromTo: dateTimeTos,
      );
    }
    log(timetableDataList[index].dateTimeFromTo.toString());
    notifyListeners();
  }

  void createTimetable(BuildContext context) async {
    try {
      await Future.wait(
        timetableDataList.map(
            (timeTableData) => _timetableDB!.addToTimetableData(timeTableData)),
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Timetable created successfully")),
      );
      timetableDataList = _timetableDB!.timetableBox.values.toList();
      notifyListeners();
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error creating timetable")),
      );
    }
  }
}
