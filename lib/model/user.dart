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
}
