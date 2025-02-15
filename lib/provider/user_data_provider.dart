import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:studybuddy/model/course.dart';
import 'package:studybuddy/model/hive_boxes.dart';
import 'package:studybuddy/model/user.dart';
import 'package:studybuddy/services/hive_db.dart';

class UserDataProvider extends ChangeNotifier {
  final UserDataDB _userDataDB =
      UserDataDB(userBox: Hive.box(HiveBoxes.userBox));
  User? user;

  UserDataProvider() {
    user = _userDataDB.readUserData();
  }

  void refreshUser() async {
    await _userDataDB.saveUserData(user!);
    user = _userDataDB.readUserData();
    notifyListeners();
  }

  void updateCourses(List<Course> courses) {
    user = user!.copyWith(
        userCourses: courses);
    saveUser(user!);
  }

  void saveUser(User user) async {
    await _userDataDB.saveUserData(user);
    notifyListeners();
  }

  void updateDept(String dept) {
    user = user!.copyWith(userDepartment: dept);
    saveUser(user!);
  }

  void updateLevel(int level) {
    user = user!.copyWith(userLevel: level);
    saveUser(user!);
  }

  void updateName(String name) {
    user = user!.copyWith(userName: name);
    log(user!.userName + " after .copyWith()");
    saveUser(user!);
  }
}
