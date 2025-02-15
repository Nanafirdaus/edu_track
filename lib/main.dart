import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/bot_nav_bar.dart';
import 'package:studybuddy/model/datetime_from_to.dart';
import 'package:studybuddy/model/hive_boxes.dart';
import 'package:studybuddy/model/assignment_schedule.dart';
import 'package:studybuddy/model/course.dart';
import 'package:studybuddy/model/course_schedule.dart';
import 'package:studybuddy/model/timetabledata.dart';
import 'package:studybuddy/model/user.dart';
import 'package:studybuddy/provider/assignment_provider.dart';
import 'package:studybuddy/provider/segmented_btn_provider.dart';
import 'package:studybuddy/provider/time_table_provider.dart';
import 'package:studybuddy/provider/user_data_provider.dart';
import 'package:studybuddy/screens/on_boarding.dart';
import 'package:studybuddy/services/onboarding_pref.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:studybuddy/utils/days_enum.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OnboardingPref.init();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CourseAdapter());
  Hive.registerAdapter(CourseScheduleAdapter());
  Hive.registerAdapter(AssignmentScheduleAdapter());
  Hive.registerAdapter(TimeTableDataAdapter());
  Hive.registerAdapter(DatetimeFromToAdapter());
  Hive.registerAdapter(DayAdapter());
  await Hive.openBox<User>(HiveBoxes.userBox);
  await Hive.openBox<TimeTableData>(HiveBoxes.timetableBox);
  await Hive.openBox<Course>(HiveBoxes.courseBox);
  await Hive.openBox<CourseSchedule>(HiveBoxes.courseScheduleBox);
  await Hive.openBox<AssignmentSchedule>(HiveBoxes.assignmentScheduleBox);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
  );
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
        ChangeNotifierProvider(
          create: (_) => AssignmentProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TimeTableProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TempTimeTableProvider(),
        )
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
