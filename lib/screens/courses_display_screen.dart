import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/provider/time_table_provider.dart';
import 'package:studybuddy/utils/days_enum.dart';

class CoursesDisplayScreen extends StatelessWidget {
  final Day day;
  const CoursesDisplayScreen({required this.day, super.key});

  @override
  Widget build(BuildContext context) {
    TimeTableProvider timetableProvider =
        Provider.of<TimeTableProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(day.name[0].toUpperCase() + day.name.substring(1)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          ...timetableProvider.timetableDataList
              .where((data) => data.days.contains(day))
              .map(
                (course) => ListTile(
                  title: Text(course.course.courseTitle),
                  subtitle: Text(course.course.courseCode),
                ),
              )
        ],
      )),
    );
  }
}
