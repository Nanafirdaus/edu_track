import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/model/hive_boxes.dart';
import 'package:studybuddy/model/timetabledata.dart';
import 'package:studybuddy/model/user.dart';
import 'package:studybuddy/provider/time_table_provider.dart';
import 'package:studybuddy/provider/user_data_provider.dart';
import 'package:studybuddy/services/hive_db.dart';
import 'package:studybuddy/utils/date_time_utils.dart';
import 'package:studybuddy/utils/days_enum.dart';
import 'package:studybuddy/utils/text_style.dart';
import 'package:studybuddy/widgets/empty_activity.dart';
import 'package:studybuddy/widgets/empty_activity2.dart';
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

  bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final timeTableProvider = Provider.of<TimeTableProvider>(context);
    final assignmentProvider = Provider.of<AssignmentProvider>(context);
    final isClassSelected =
        context.watch<SegmentedButtonController>().classIsSelected;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: hiveDB.listenable(),
        builder: (context, hiveBox, _) {
          User? user = hiveBox.get('userKey');
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Hello,", style: kTextStyle(40)),
                    const SizedBox(width: 5),
                    Text(user?.userName.split(' ').first ?? "",
                        style: kTextStyle(40, isBold: true)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(DateTime.now().formatDateTime,
                    style: kTextStyle(30, color: Colors.grey)),
                const SizedBox(height: 40),
                Text("Today", style: kTextStyle(40, isBold: true)),
                const SizedBox(height: 10),
                const CustomSegmentedButton(), // Segmented button
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isClassSelected
                      ? _buildTodayClasses(timeTableProvider)
                      : _buildTodayAssignments(assignmentProvider),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTodayClasses(TimeTableProvider timeTableProvider) {
    final todayClasses = _getTodayClasses(timeTableProvider);

    if (todayClasses.isNotEmpty) {
      return Column(
        children: [
          for (final timetable in todayClasses)
            _buildElevatedTile(
              title: timetable.course.courseTitle,
              subtitle:
                  "Lecturer: ${timetable.lecturerName} \nVenue: ${timetable.venue}",
              trailingText: timetable.dateTimeFromTo.first.from!.formatDateTime,
              color: Colors.greenAccent.withOpacity(0.1),
            )
        ],
      );
    } else if(context.watch<TimeTableProvider>().timeTableCreated!){
      return EmptyActivity(text: "class");
    } else {
      return EmptyActivity(text: "Timetable");
    } 
  
  }

  /// **Extracts today's classes from the timetable data**
  List<TimeTableData> _getTodayClasses(TimeTableProvider timeTableProvider) {
    final todayWeekday = DateTime.now().weekday;
    return timeTableProvider.timetableDataList
        .where((timetable) => timetable.days
            .any((day) => Day.values.indexOf(day) == todayWeekday))
        .toList();
  }

  Widget _buildTodayAssignments(AssignmentProvider assignmentProvider) {
    final todayAssignments = assignmentProvider.assignments
        .where((assign) => assign.assignmentDateTime.day == DateTime.now().day)
        .toList();

    if (todayAssignments.isNotEmpty) {
      return Column(
        children: [
          for (final assignment in todayAssignments)
            _buildElevatedTile(
              title: assignment.description,
              subtitle: context
                  .watch<UserDataProvider>()
                  .user!
                  .userCourses
                  .firstWhere(
                      (course) => course.courseId == assignment.courseId)
                  .courseTitle,
              trailingText: assignment.assignmentDateTime.formatDateTime,
              color: Colors.greenAccent.withOpacity(0.1),
            ),
        ],
      );
    } else {
      return EmptyActivity2(text: "Tasks");
    }
  }

  Widget _buildElevatedTile({
    required String title,
    required String subtitle,
    required String trailingText,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        tileColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(title, style: kTextStyle(18, isBold: true)),
        subtitle:
            Text(subtitle, style: kTextStyle(16, color: Colors.grey[800])),
        trailing: trailingText.isNotEmpty
            ? Text(trailingText, style: kTextStyle(16, isBold: true))
            : null,
      ),
    );
  }
}
