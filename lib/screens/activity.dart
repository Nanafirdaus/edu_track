import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/model/user.dart';
import 'package:studybuddy/provider/assignment_provider.dart';
import 'package:studybuddy/provider/user_data_provider.dart';
import 'package:studybuddy/screens/time_table.dart';
import 'package:studybuddy/utils/date_time_utils.dart';
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
                  text: "Classes",
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
                    child: Column(
                      children: [
                        ...user!.userCourses.map(
                          (course) => ListTile(
                            leading: Text(
                              course.courseTitle,
                              style: kTextStyle(16),
                            ),
                            trailing: Text(
                              course.courseCode,
                              style: kTextStyle(16),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: context.screenHeight * .05,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TimeTableScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Create TimeTable",
                            style: kTextStyle(15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ...context.watch<AssignmentProvider>().assignments.map(
                              (assignment) => ListTile(
                                title: Text(
                                  assignment.description,
                                  style: kTextStyle(20, isBold: true),
                                ),
                                subtitle: Text(
                                  user
                                          .userCourses[
                                              int.parse(assignment.courseId)]
                                          .courseTitle +
                                      " - " +
                                      assignment
                                          .assignmentDateTime.formatDateTime +
                                      " " +
                                      assignment.assignmentDateTime
                                          .format(DateFormat.HOUR_MINUTE),
                                ),
                              ),
                            )
                      ],
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
