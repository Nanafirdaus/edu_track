import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/model/user.dart';
import 'package:studybuddy/provider/assignment_provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              controller: tabController,
              isScrollable: false,
              tabs: const [
                Tab(
                  text: "Courses",
                ),
                Tab(
                  text: "Tasks",
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
                                          const TimetableCreationScreen(),
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
                  SingleChildScrollView(
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
                                  child: CheckboxListTile(
                                    value: assignment.isCompleted,
                                    onChanged: (val) {
                                      assignmentProvider.toggleCompletedStatus(
                                          assignment.assignmentId, val!);
                                    },
                                    title: Text(
                                      assignment.description,
                                      style: kTextStyle(20, isBold: true),
                                    ),
                                    subtitle: Text(
                                      "${user!.userCourses[int.parse(assignment.courseId)].courseTitle} - ${assignment.assignmentDateTime.formatDateTime} ${assignment.assignmentDateTime.format(
                                        DateFormat.HOUR_MINUTE,
                                      )}",
                                    ),
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
