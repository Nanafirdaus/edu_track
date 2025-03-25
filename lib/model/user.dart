import 'course.dart';
import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String userName;

  @HiveField(1)
  final String userDepartment;

  @HiveField(2)
  final int userLevel;

  @HiveField(3)
  final List<Course> userCourses;

  User({
    required this.userName,
    required this.userDepartment,
    required this.userLevel,
    required this.userCourses,
  });

  User copyWith({
    String? userName,
    String? userDepartment,
    int? userLevel,
    List<Course>? userCourses,
  }) {
    return User(
      userName: userName ?? this.userName,
      userDepartment: userDepartment ?? this.userDepartment,
      userLevel: userLevel ?? this.userLevel,
      userCourses: userCourses ?? this.userCourses,
    );
  }

  @override
  String toString() {
    return 'User(userName: $userName, userDepartment: $userDepartment, userLevel: $userLevel, userCourses: ${userCourses.map((course) => course.toString()).toList()})';
  }

  
}
