// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  @override
  String toString() {
    return 'Course(courseTitle: $courseTitle, courseCode: $courseCode, courseId: $courseId)';
  }

  @override
  bool operator ==(covariant Course other) {
    if (identical(this, other)) return true;
  
    return 
      other.courseTitle == courseTitle &&
      other.courseCode == courseCode &&
      other.courseId == courseId;
  }

  @override
  int get hashCode => courseTitle.hashCode ^ courseCode.hashCode ^ courseId.hashCode;
}
