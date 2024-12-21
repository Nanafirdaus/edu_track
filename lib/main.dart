import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/bot_nav_bar.dart';
import 'package:studybuddy/model/hive_boxes.dart';
import 'package:studybuddy/model/assignment_schedule.dart';
import 'package:studybuddy/model/course.dart';
import 'package:studybuddy/model/course_schedule.dart';
import 'package:studybuddy/model/lecturer.dart';
import 'package:studybuddy/model/user.dart';
import 'package:studybuddy/provider/segmented_btn_provider.dart';
import 'package:studybuddy/provider/user_data_provider.dart';
import 'package:studybuddy/screens/home.dart';
import 'package:studybuddy/screens/on_boarding.dart';
import 'package:studybuddy/services/onboarding_pref.dart';
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
  await Hive.openBox<User>(HiveBoxes.userBox);
  await Hive.openBox<Course>(HiveBoxes.courseBox);
  await Hive.openBox<Lecturer>(HiveBoxes.lecturerBox);
  await Hive.openBox<CourseSchedule>(HiveBoxes.courseScheduleBox);
  await Hive.openBox<AssignmentSchedule>(HiveBoxes.assignmentScheduleBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SegmentedButtonController(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserDataProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: OnboardingPref.isFirstTime()!
            ? const OnBoardingScreen()
            : const AppBottomNavBar(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff92E3A9)),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            modalBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            modalElevation: 0,
          ),
        ),
      ),
    );
  }
}
