import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:studybuddy/model/user.dart';

class UserDataDB {
  static UserDataDB? _instance;
  static String userKey = "userKey";
  Box<User>? userBox;

  UserDataDB._({required this.userBox});

  factory UserDataDB({Box<User>? userBox}) {
    _instance ??= UserDataDB._(userBox: userBox);
    return _instance!;
  }

  //! usef
  Future<void> saveUserData(User user) async {
    await userBox!.put(userKey, user);
    log("success");
  }

  User? readUserData() {
    return userBox!.get(userKey);
  }

  Future clearUserData() async {
    await userBox!.delete(userKey);
  }

  ValueListenable<Box<User>> listenable() {
    return userBox!.listenable();
  }
}
