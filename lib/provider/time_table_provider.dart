import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:studybuddy/provider/model/course.dart';
import 'package:studybuddy/provider/model/datetime_from_to.dart';
import 'package:studybuddy/provider/model/hive_boxes.dart';
import 'package:studybuddy/provider/model/timetabledata.dart';
import 'package:studybuddy/services/hive_db.dart';
import 'package:studybuddy/services/notifications_service.dart';
import 'package:studybuddy/services/timetable_db.dart';
import 'package:studybuddy/utils/days_enum.dart';
import 'package:uuid/uuid.dart';

abstract class BaseTimetimeProvider extends ChangeNotifier {
  TimetableDB? _timetableDB;
  UserDataDB? _userDataDB;
  bool? timeTableCreated;
  List<TimeTableData> timetableDataList = [];
  void initializeProvider(List<Course> courses);
  void addTimetableData(TimeTableData data);
  void updateTimetableData(int index, TimeTableData data);
  void updateDays(Day day, int index);
  void createTimetable(BuildContext context);
}

class TempTimeTableProvider extends BaseTimetimeProvider {
  @override
  TimetableDB? _timetableDB;
  @override
  UserDataDB? _userDataDB;
  @override
  List<TimeTableData> timetableDataList = [];

  @override
  void initializeProvider(List<Course> courses) {
    _timetableDB = TimetableDB(timetableBox: Hive.box(HiveBoxes.timetableBox));

    timetableDataList = List.generate(courses.length, (index) {
      return TimeTableData(
        id: const Uuid().v4(),
        course: courses[index],
        dateTimeFromTo: [],
        days: [],
        lecturerName: '',
        venue: '',
      );
    });
    notifyListeners();
  }

  @override
  void addTimetableData(TimeTableData data) {
    timetableDataList.add(data);
    notifyListeners();
  }

  @override
  void updateTimetableData(int index, TimeTableData data) {
    timetableDataList[index] = data;
    notifyListeners();
  }

  @override
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

  @override
  void createTimetable(BuildContext context) async {
    try {
      await Future.wait(
        timetableDataList.map(
            (timeTableData) => _timetableDB!.addToTimetableData(timeTableData)),
      );
      Navigator.pop(context);
    } catch (e) {
      log(e.toString());
    }
  }
}

class TimeTableProvider extends BaseTimetimeProvider {
  @override
  TimetableDB? _timetableDB;
  @override
  UserDataDB? _userDataDB;
  @override
  bool? timeTableCreated;
  @override
  List<TimeTableData> timetableDataList = [];

  TimeTableProvider() {
    _timetableDB = TimetableDB(timetableBox: Hive.box(HiveBoxes.timetableBox));
    _userDataDB = UserDataDB(userBox: Hive.box(HiveBoxes.userBox));
    timeTableCreated = _timetableDB!.timetableBox.isNotEmpty;
    timetableDataList = timeTableCreated!
        ? _timetableDB!.timetableBox.values.toList()
        : List.generate(_userDataDB!.userBox!.values.first.userCourses.length,
            (index) {
            return TimeTableData(
              id: const Uuid().v4(),
              course: _userDataDB!.userBox!.values.first.userCourses[index],
              dateTimeFromTo: [],
              days: [],
              lecturerName: '',
              venue: '',
            );
          });
    //: _timetableDB!.timetableBox.values.toList();
    notifyListeners();
  }

  void invalidateProvider() {
    _timetableDB = TimetableDB(timetableBox: Hive.box(HiveBoxes.timetableBox));
    timetableDataList = timeTableCreated!
        ? _timetableDB!.timetableBox.values.toList()
        : List.generate(_userDataDB!.userBox!.values.first.userCourses.length,
            (index) {
            return TimeTableData(
              id: const Uuid().v4(),
              course: _userDataDB!.userBox!.values.first.userCourses[index],
              dateTimeFromTo: [],
              days: [],
              lecturerName: '',
              venue: '',
            );
          });
  }

  @override
  void addTimetableData(TimeTableData data) {
    timetableDataList.add(data);
    notifyListeners();
  }

  void moveCourseToNewDay(TimeTableData course, Day oldDay, Day newDay) async {
    final courseIndex = timetableDataList.indexWhere((c) => c.id == course.id);
    if (courseIndex != -1) {
      final updatedCourse = timetableDataList[courseIndex];

      // Remove from old day and add to new day
      List<Day> updatedDays = List.from(updatedCourse.days);
      updatedDays.remove(oldDay);
      updatedDays.add(newDay);

      timetableDataList[courseIndex] =
          updatedCourse.copyWith(days: updatedDays);
      await _timetableDB!.updateTimetableData(timetableDataList[courseIndex]);
      notifyListeners();
    }
  }

  @override
  void updateTimetableData(int index, TimeTableData data) {
    timetableDataList[index] = data;
    notifyListeners();
  }

  void deleteTimetableData(String timetableId) {
    timetableDataList.removeWhere((data) => data.id == timetableId);
    notifyListeners();
  }

  @override
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

  @override
  void createTimetable(BuildContext context, {bool isEdit = false}) async {
    try {
      await Future.wait(
        timetableDataList.map(
            (timeTableData) => _timetableDB!.addToTimetableData(timeTableData)),
      );

      timetableDataList = _timetableDB!.timetableBox.values.toList();
      timeTableCreated = true;
      await NotificationService.scheduleTimetableNotifications(
          timetableDataList);
      notifyListeners();

     if (context.mounted){
       Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Timetable created successfully")),
      );
     }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error creating timetable")),
      );
      log(e.toString());
    }
  }

  @override
  initializeProvider(List<Course> courses) {
    // TODO: implement initializeProvider
    throw UnimplementedError();
  }
}
