import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/model/hive_boxes.dart';
import 'package:studybuddy/model/user.dart';
import 'package:studybuddy/provider/time_table_provider.dart';
import 'package:studybuddy/services/hive_db.dart';
import 'package:studybuddy/utils/date_time_utils.dart';
import 'package:studybuddy/utils/days_enum.dart';
import 'package:studybuddy/utils/text_style.dart';
import 'package:studybuddy/widgets/empty_activity.dart';
import 'package:studybuddy/widgets/segmented_butn.dart';
import '../provider/assignment_provider.dart';
import '../provider/segmented_btn_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserDataDB hiveDB = UserDataDB(userBox: Hive.box(HiveBoxes.userBox));
  String selectedOption = "Classes";

  List<Widget> screens = const [];

  bool isToday(DateTime dateTime) {
    return dateTime.day == DateTime.now().day &&
        dateTime.month == DateTime.now().month &&
        dateTime.year == DateTime.now().year;
  }

  @override
  Widget build(BuildContext context) {
    TimeTableProvider timeTableProvider =
        Provider.of<TimeTableProvider>(context);
    AssignmentProvider assignmentProvider =
        Provider.of<AssignmentProvider>(context);

    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: hiveDB.listenable(),
          builder: (context, hiveBox, _) {
            User? user = hiveBox.get('userKey');
            return Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hello,",
                          style: kTextStyle(
                            40,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          user!.userName.split(' ').first,
                          style: kTextStyle(40, isBold: true),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(DateTime.now().formatDateTime,
                        style: kTextStyle(30, color: Colors.grey)),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Today",
                      style: kTextStyle(40, isBold: true),
                    ),
                    const SizedBox(height: 10),
                    const CustomSegmentedButton(),
                    const SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: switch (context
                              .watch<SegmentedButtonController>()
                              .classIsSelected) {
                            true => timeTableProvider.timeTableCreated!
                                ? timeTableProvider.timetableDataList
                                        .where((timetableData) =>
                                            timetableData.days.containsToday())
                                        .isEmpty
                                    ? EmptyActivity(
                                        text: "classes", today: true)
                                    : Card.outlined(
                                        elevation: 3,
                                        child: Column(children: [
                                          ...timeTableProvider.timetableDataList
                                              .where((timetableData) =>
                                                  timetableData.days
                                                      .containsToday())
                                              .map(
                                                (course) => ListTile(
                                                  title: Text(course
                                                      .course.courseTitle),
                                                ),
                                              ),
                                        ]),
                                      )
                                : EmptyActivity(text: "classes"),
                            _ => context
                                    .watch<AssignmentProvider>()
                                    .assignments
                                    .isEmpty
                                ? EmptyActivity(text: "assignments")
                                : context
                                        .watch<AssignmentProvider>()
                                        .assignments
                                        .where((task) => task.assignmentDateTime
                                            .isSameDayAs(DateTime.now()))
                                        .isEmpty
                                    ? Text(
                                        "No tasks today",
                                        style: kTextStyle(25),
                                      )
                                    : Card.outlined(
                                        elevation: 3,
                                        child: Column(
                                          children: [
                                            ...assignmentProvider.assignments
                                                .where((assignment) => isToday(
                                                    assignment
                                                        .assignmentDateTime))
                                                .map(
                                                  (assignment) => ListTile(
                                                    title: Text(
                                                        assignment.description),
                                                  ),
                                                )
                                          ],
                                        ),
                                      )
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
