import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/model/course.dart';
import 'package:studybuddy/model/hive_boxes.dart';
import 'package:studybuddy/model/user.dart';
import 'package:studybuddy/provider/assignment_provider.dart';
import 'package:studybuddy/provider/time_table_provider.dart';
import 'package:studybuddy/provider/user_data_provider.dart';
import 'package:studybuddy/screens/courses_display_screen.dart';
import 'package:studybuddy/screens/timetable_creation.dart';
import 'package:studybuddy/services/timetable_db.dart';
import 'package:studybuddy/utils/date_time_utils.dart';
import 'package:studybuddy/utils/days_enum.dart';
import 'package:studybuddy/utils/extension.dart';
import 'package:studybuddy/utils/text_style.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<Course> coursesInTimetable = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      coursesInTimetable = context
          .read<TimeTableProvider>()
          .timetableDataList
          .map((data) => data.course)
          .toList();
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserDataProvider? userDataProvider = Provider.of<UserDataProvider>(context);
    AssignmentProvider assignmentProvider =
        Provider.of<AssignmentProvider>(context);
    TimeTableProvider timeTableProvider =
        Provider.of<TimeTableProvider>(context);
    User? user = userDataProvider.user;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelStyle: kTextStyle(14),
              controller: tabController,
              isScrollable: false,
              tabs: const [
                Tab(
                  text: "Courses",
                ),
                Tab(
                  text: "Assignments",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (timeTableProvider.timeTableCreated!) ...{
                            Column(
                              children: <Widget>[
                                ...Day.values.map(
                                  (day) => Card(
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CoursesDisplayScreen(day: day),
                                          ),
                                        );
                                      },
                                      title: Text(day.name),
                                    ),
                                  ),
                                ),
                                if (context
                                    .read<UserDataProvider>()
                                    .user!
                                    .userCourses
                                    .toSet()
                                    .difference(coursesInTimetable.toSet())
                                    .isNotEmpty) ...{
                                  const SizedBox(height: 20),
                                  Text(
                                    "New courses",
                                    style: kTextStyle(20, isBold: true),
                                  ),
                                  if (coursesInTimetable.isNotEmpty)
                                    ...context
                                        .watch<UserDataProvider>()
                                        .user!
                                        .userCourses
                                        .toSet()
                                        .difference(coursesInTimetable.toSet())
                                        .map((course) {
                                      return Card(
                                        elevation: 0.5,
                                        child: ListTile(
                                          splashColor: Colors.greenAccent,
                                          title: Text(
                                            course.courseTitle,
                                            style: kTextStyle(16),
                                          ),
                                          subtitle: Text(
                                            course.courseCode,
                                            style: kTextStyle(16),
                                          ),
                                        ),
                                      );
                                    }),
                                  FilledButton(
                                    onPressed: () async {
                                      log(context
                                          .read<UserDataProvider>()
                                          .user!
                                          .userCourses
                                          .toSet()
                                          .difference(
                                              coursesInTimetable.toSet())
                                          .toList()
                                          .toString());
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return TimetableCreationScreen(
                                              courses: context
                                                  .read<UserDataProvider>()
                                                  .user!
                                                  .userCourses
                                                  .toSet()
                                                  .difference(coursesInTimetable
                                                      .toSet())
                                                  .toList(),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Update timetable",
                                      style:
                                          kTextStyle(18, color: Colors.white),
                                    ),
                                  )
                                }
                              ],
                            )
                          } else ...{
                            ...user!.userCourses.map(
                              (course) => Card(
                                elevation: 0.5,
                                child: ListTile(
                                  splashColor: Colors.greenAccent,
                                  title: Text(
                                    course.courseTitle,
                                    style: kTextStyle(16),
                                  ),
                                  subtitle: Text(
                                    course.courseCode,
                                    style: kTextStyle(16),
                                  ),
                                ),
                              ),
                            ),
                          },
                          SizedBox(
                            height: context.screenHeight * .05,
                          ),
                          if (!timeTableProvider.timeTableCreated!)
                            SizedBox(
                              width: context.screenWidth * .70,
                              height: 50,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TimetableCreationScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Create TimeTable",
                                  style: kTextStyle(18),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  context.watch<AssignmentProvider>().assignments.isEmpty
                      ? Center(
                          child: Image.asset(
                            "assets/images/addnote.png",
                            height: 400,
                          ),
                        )
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ...context
                                    .watch<AssignmentProvider>()
                                    .assignments
                                    .map(
                                      (assignment) => Card(
                                        elevation: 0.5,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                child: CheckboxListTile(
                                                  value: assignment.isCompleted,
                                                  onChanged: (val) {
                                                    assignmentProvider
                                                        .toggleCompletedStatus(
                                                            assignment
                                                                .assignmentId,
                                                            val!);
                                                  },
                                                  title: Text(
                                                    assignment.description,
                                                    style: kTextStyle(20,
                                                        isBold: true),
                                                  ),
                                                  subtitle: Text(
                                                    "${user!.userCourses[int.parse(assignment.courseId)].courseTitle} - ${assignment.assignmentDateTime.formatDateTime} ${assignment.assignmentDateTime.format(
                                                      DateFormat.HOUR_MINUTE,
                                                    )}",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        "Delete assignment",
                                                        style: kTextStyle(20,
                                                            isBold: true),
                                                      ),
                                                      content: SizedBox(
                                                          width: context
                                                                  .screenWidth *
                                                              .70,
                                                          child: Text(
                                                            "Do you want to delete this assignment",
                                                            style:
                                                                kTextStyle(18),
                                                          )),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            context
                                                                .read<
                                                                    AssignmentProvider>()
                                                                .deleteAssignment(
                                                                    assignment
                                                                        .assignmentId);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            "Yes",
                                                            style:
                                                                kTextStyle(16),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            "No",
                                                            style:
                                                                kTextStyle(16),
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
