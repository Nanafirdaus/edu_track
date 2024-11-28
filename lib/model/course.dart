import 'package:hive/hive.dart';
part 'course.g.dart';

@HiveType(typeId: 2)
class Course {
  @HiveField(0)
  final String courseTitle; 

  @HiveField(1)
  final String courseCode; 

  @HiveField(2)
  final String courseId;

  Course({
    required this.courseTitle,
    required this.courseCode,
    required this.courseId,
  });
}
