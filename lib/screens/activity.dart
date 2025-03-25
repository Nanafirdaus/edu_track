import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/model/course.dart';
import 'package:studybuddy/model/hive_boxes.dart';
import 'package:studybuddy/model/timetabledata.dart';
import 'package:studybuddy/model/user.dart';
import 'package:studybuddy/provider/assignment_provider.dart';
import 'package:studybuddy/provider/tab_provider.dart';
import 'package:studybuddy/provider/time_table_provider.dart';
import 'package:studybuddy/provider/user_data_provider.dart';
import 'package:studybuddy/screens/courses_display_screen.dart';
import 'package:studybuddy/screens/timetable_creation.dart';
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

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
    );
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

    return ValueListenableBuilder(
        valueListenable:
            Hive.box<TimeTableData>(HiveBoxes.timetableBox).listenable(),
        builder: (context, timetable, _) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: [
                if (timetable.isNotEmpty) ...{
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "Delete Timetable",
                                style: kTextStyle(20, isBold: true),
                              ),
                              content: Text(
                                "Are you sure you want to delete the timetable?",
                                style: kTextStyle(16),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<TimeTableProvider>()
                                        .deleteTimetable();
                                    Navigator.of(context).pop();
                                    setState(() {});
                                  },
                                  child: Text(
                                    "Yes",
                                    style: kTextStyle(16, color: Colors.red),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Handle "No" action
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "No",
                                    style: kTextStyle(16),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text("Delete timetable"),
                    ),
                  )
                }
              ],
            ),
            body: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    onTap: (index) {
                      context.read<TabProvider>().changeTab(index == 0);
                      log(context.read<TabProvider>().isClassTab.toString());
                    },
                    labelStyle: kTextStyle(14),
                    controller: tabController,
                    isScrollable: false,
                    tabs: [
                      Tab(
                          text:
                              "Courses(${context.watch<UserDataProvider>().user!.userCourses.length})"),
                      Tab(
                          text:
                              "Tasks(${context.watch<AssignmentProvider>().assignments.length})"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        // Courses Tab
                        SingleChildScrollView(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (timetable.isNotEmpty) ...{
                                    ...Day.values.map((e) => Card(
                                          elevation: 3,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 10),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: ListTile(
                                            tileColor: Colors.greenAccent
                                                .withOpacity(0.05),
                                            title: Text(
                                                e.name[0].toUpperCase() +
                                                    e.name.substring(1)),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return CoursesDisplayScreen(
                                                      day: e,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ))
                                  } else ...{
                                    ...context
                                        .read<UserDataProvider>()
                                        .user!
                                        .userCourses
                                        .map(
                                          (e) => Card(
                                            child: ListTile(
                                              tileColor: Colors.greenAccent
                                                  .withOpacity(0.05),
                                              title: Text(
                                                e.courseTitle,
                                                style: kTextStyle(16),
                                              ),
                                              subtitle: Text(
                                                e.courseCode,
                                                style: kTextStyle(16),
                                              ),
                                            ),
                                          ),
                                        ),
                                    FilledButton(
                                      style: FilledButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      onPressed: () {
                                        log(context
                                            .read<TimeTableProvider>()
                                            .timeTableCreated
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
                                                    .toList(),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Create timetable",
                                        style:
                                            kTextStyle(18, color: Colors.white),
                                      ),
                                    ),
                                  },
                                  SizedBox(height: 10),
                                  if (timetable.isNotEmpty &&
                                      context
                                          .read<UserDataProvider>()
                                          .user!
                                          .userCourses
                                          .map((e) => e.courseId)
                                          .toSet()
                                          .difference(timetable.values
                                              .map((e) => e.course.courseId)
                                              .toSet())
                                          .isNotEmpty) ...{
                                    const SizedBox(height: 20),
                                    Text(
                                      "New courses",
                                      style: kTextStyle(20, isBold: true),
                                    ),
                                    ...context
                                        .read<UserDataProvider>()
                                        .user!
                                        .userCourses
                                        .map((e) => e.courseId)
                                        .toSet()
                                        .difference(timetable.values
                                            .map((e) => e.course.courseId)
                                            .toSet())
                                        .map((id) {
                                      return Card(
                                        elevation: 3,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 10),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: ListTile(
                                          tileColor: Colors.greenAccent
                                              .withOpacity(0.05),
                                          title: Text(
                                            context
                                                .watch<UserDataProvider>()
                                                .user!
                                                .userCourses
                                                .firstWhere((course) =>
                                                    course.courseId == id)
                                                .courseTitle,
                                            style: kTextStyle(16),
                                          ),
                                          subtitle: Text(
                                            context
                                                .watch<UserDataProvider>()
                                                .user!
                                                .userCourses
                                                .firstWhere((course) =>
                                                    course.courseId == id)
                                                .courseCode,
                                            style: kTextStyle(16),
                                          ),
                                        ),
                                      );
                                    }),
                                    FilledButton(
                                      onPressed: () async {
                                        final newCourses = context
                                            .read<UserDataProvider>()
                                            .user!
                                            .userCourses
                                            .map((e) => e.courseId)
                                            .toSet()
                                            .difference(timetable.values
                                                .map((e) => e.course.courseId)
                                                .toSet());
                                        log(timetable.values
                                            .map((e) => e.days)
                                            .toString());
                                        log(context
                                            .read<UserDataProvider>()
                                            .user!
                                            .userCourses
                                            .map((e) => e.courseId)
                                            .toSet()
                                            .difference(timetable.values
                                                .map((e) => e.course.courseId)
                                                .toSet())
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
                                                    .where((course) =>
                                                        newCourses.contains(
                                                            course.courseId))
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
                              )),
                        ),

                        // Assignments Tab
                        ListView(
                          children: context
                              .watch<AssignmentProvider>()
                              .assignments
                              .map(
                            (assignment) {
                              return Card(
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        child: CheckboxListTile(
                                          tileColor: Colors.greenAccent
                                              .withOpacity(0.05),
                                          value: assignment.isCompleted,
                                          onChanged: (val) {
                                            assignmentProvider
                                                .toggleCompletedStatus(
                                                    assignment.assignmentId,
                                                    val!);
                                          },
                                          title: Text(
                                            assignment.description,
                                            style: kTextStyle(18, isBold: true),
                                          ),
                                          subtitle: Text(
                                            "${user!.userCourses.firstWhere((course) => course.courseId == assignment.courseId).courseTitle} - ${assignment.assignmentDateTime.formatDateTime} ${assignment.assignmentDateTime.format(
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
                                                width:
                                                    context.screenWidth * .70,
                                                child: Text(
                                                  "Do you want to delete this assignment",
                                                  style: kTextStyle(18),
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    context
                                                        .read<
                                                            AssignmentProvider>()
                                                        .deleteAssignment(
                                                            assignment
                                                                .assignmentId);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Yes",
                                                      style: kTextStyle(16)),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("No",
                                                      style: kTextStyle(16)),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Iconsax.trash,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
