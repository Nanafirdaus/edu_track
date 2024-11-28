import 'package:flutter/material.dart';
import 'package:studybuddy/boxes.dart';
import 'package:studybuddy/model/assignment_schedule.dart';
import 'package:studybuddy/model/course.dart';
import 'package:studybuddy/model/course_schedule.dart';
import 'package:studybuddy/model/lecturer.dart';
import 'package:studybuddy/model/user.dart';
import 'package:studybuddy/screens/on_boarding.dart';
import 'package:studybuddy/screens/user_data.dart';
import 'package:studybuddy/utils/onboarding_pref.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OnboardingPref.init();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CourseAdapter());
  Hive.registerAdapter(LecturerAdapter());
  Hive.registerAdapter(CourseScheduleAdapter());
  Hive.registerAdapter(AssignmentScheduleAdapter());
  boxUsers = await Hive.openBox<User>('userBox');
  boxCourses = await Hive.openBox<Course>('courseBox');
  boxLecturers = await Hive.openBox<Lecturer>('lecturerBox');
  boxCourseSchedules = await Hive.openBox<CourseSchedule>('courseScheduleBox');
  boxAssignmentSchedules =
      await Hive.openBox<AssignmentSchedule>('assignmentScheduleBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingPref.isFirstTime()!
          ? const OnBoardingScreen()
          : const UserDataScreen(),
    );
  }
}
