import 'package:hive/hive.dart';
import 'package:studybuddy/model/course.dart';
import 'package:studybuddy/model/datetime_from_to.dart';
import 'package:studybuddy/utils/days_enum.dart';

part 'timetabledata.g.dart';

@HiveType(typeId: 1)
class TimeTableData {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final Course course;
  @HiveField(2)
  final List<DatetimeFromTo> dateTimeFromTo;
  @HiveField(3)
  final List<Day> days;
  @HiveField(4)
  final String lecturerName;
  @HiveField(5)
  final String venue;

  TimeTableData({
    required this.id,
    required this.course,
    required this.dateTimeFromTo,
    required this.days,
    required this.lecturerName,
    required this.venue,
  });

  TimeTableData copyWith({
    Course? course,
    List<DatetimeFromTo>? dateTimeFromTo,
    List<Day>? days,
    String? lecturerName,
    String? venue,
  }) {
    return TimeTableData(
      id: id,
      course: course ?? this.course,
      dateTimeFromTo: dateTimeFromTo ?? this.dateTimeFromTo,
      days: days ?? this.days,
      lecturerName: lecturerName ?? this.lecturerName,
      venue: venue ?? this.venue,
    );
  }

  @override
  String toString() {
    return '''TimeTableData(
      id: $id, 
      course: $course, 
      dateTimeFromTo: ${dateTimeFromTo.map((dt) => dt.toString()).toList()}, 
      days: ${days.map((day) => day.name).toList()}, 
      lecturerName: $lecturerName, 
      venue: $venue
    )''';
  }
}
