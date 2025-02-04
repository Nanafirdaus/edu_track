import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:studybuddy/model/course.dart';
import 'package:studybuddy/model/hive_boxes.dart';
import 'package:studybuddy/model/user.dart';
import 'package:studybuddy/services/hive_db.dart';

class UserDataProvider extends ChangeNotifier {
  UserDataDB? _userDataDB;
  User? user;

  UserDataProvider() {
    _userDataDB = UserDataDB(userBox: Hive.box(HiveBoxes.userBox));
    user = _userDataDB!.readUserData();
    notifyListeners();
  }

  void refreshUser() {
    _userDataDB!.saveUserData(user!);
    notifyListeners();
  }

  void updateCourses(Course course) {
    user!.userCourses.add(course);
    refreshUser();
  }
}
