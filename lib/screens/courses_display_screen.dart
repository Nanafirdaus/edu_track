import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/provider/time_table_provider.dart';
import 'package:studybuddy/utils/days_enum.dart';
import 'package:studybuddy/utils/text_style.dart';

class CoursesDisplayScreen extends StatelessWidget {
  final Day day;
  const CoursesDisplayScreen({required this.day, super.key});

  @override
  Widget build(BuildContext context) {
    final TimeTableProvider timetableProvider =
        Provider.of<TimeTableProvider>(context);
    final filteredCourses = timetableProvider.timetableDataList
        .where((data) => data.days.contains(day))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          day.name[0].toUpperCase() + day.name.substring(1),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: filteredCourses.isEmpty
          ? const Center(
              child: Text(
                "No courses scheduled for this day",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: filteredCourses.length,
              itemBuilder: (context, index) {
                final course = filteredCourses[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    title: Text(
                      course.course.courseTitle,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      course.course.courseCode,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    leading: const Icon(Icons.book, color: Colors.blueAccent),
                    trailing: PopupMenuButton<Day>(
                      onSelected: (newDay) {
                        timetableProvider.moveCourseToNewDay(
                            course, day, newDay);
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem<Day>(
                          enabled: false,
                          child: Text(
                            "Move to another day",
                            style: kTextStyle(15,
                                isBold: true, color: Colors.black),
                          ),
                        ),
                        ...Day.values
                            .where((d) => d != day)
                            .map((d) => PopupMenuItem(
                                  value: d,
                                  child: Text(d.name[0].toUpperCase() +
                                      d.name.substring(1)),
                                ))
                            ,
                      ],
                      icon: const Icon(Icons.more_vert),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
