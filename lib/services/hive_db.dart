import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:studybuddy/model/user.dart';

class UserDataDB {
  Box<User> userBox;
  static String userKey = "userKey";

  UserDataDB({required this.userBox});

  //! usef
  Future<void> saveUserData(User user) async {
    await userBox.put(userKey, user);
  }

  User? readUserData() {
    return userBox.get(userKey);
  }

  Future clearUserData() async {
    await userBox.delete(userKey);
  }

  ValueListenable<Box<User>> listenable() {
    return userBox.listenable();
  }
}
