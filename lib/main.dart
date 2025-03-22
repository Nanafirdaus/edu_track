import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/bot_nav_bar.dart';
import 'package:studybuddy/provider/model/datetime_from_to.dart';
import 'package:studybuddy/provider/model/hive_boxes.dart';
import 'package:studybuddy/provider/model/assignment_schedule.dart';
import 'package:studybuddy/provider/model/course.dart';
import 'package:studybuddy/provider/model/course_schedule.dart';
import 'package:studybuddy/provider/model/timetabledata.dart';
import 'package:studybuddy/provider/model/user.dart';
import 'package:studybuddy/provider/assignment_provider.dart';
import 'package:studybuddy/provider/segmented_btn_provider.dart';
import 'package:studybuddy/provider/time_table_provider.dart';
import 'package:studybuddy/provider/user_data_provider.dart';
import 'package:studybuddy/screens/on_boarding.dart';
import 'package:studybuddy/services/notifications_service.dart';
import 'package:studybuddy/services/onboarding_pref.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:studybuddy/utils/days_enum.dart';
import 'package:permission_handler/permission_handler.dart'; // Import for permission handling

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OnboardingPref.init();
  await Hive.initFlutter();
  await NotificationService.init();

  // Register Hive Adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CourseAdapter());
  Hive.registerAdapter(CourseScheduleAdapter());
  Hive.registerAdapter(AssignmentScheduleAdapter());
  Hive.registerAdapter(TimeTableDataAdapter());
  Hive.registerAdapter(DatetimeFromToAdapter());
  Hive.registerAdapter(DayAdapter());

  // Open Hive Boxes
  await Hive.openBox<User>(HiveBoxes.userBox);
  await Hive.openBox<TimeTableData>(HiveBoxes.timetableBox);
  await Hive.openBox<Course>(HiveBoxes.courseBox);
  await Hive.openBox<CourseSchedule>(HiveBoxes.courseScheduleBox);
  await Hive.openBox<AssignmentSchedule>(HiveBoxes.assignmentScheduleBox);

  // Request Notification Permission If Not Granted
  await requestNotificationPermission();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
  );

  runApp(const MyApp());
}

/// Requests notification permission only if it hasn't been granted
Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.status;

  if (status.isDenied || status.isPermanentlyDenied) {
    // If permission is denied, request it
    final result = await Permission.notification.request();

    if (result.isGranted) {
      print("🔔 Notification permission granted!");
    } else {
      print("❌ Notification permission denied.");
    }
  } else {
    print("✅ Notification permission already granted.");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SegmentedButtonController()),
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
        ChangeNotifierProvider(create: (_) => AssignmentProvider()),
        ChangeNotifierProvider(create: (_) => TimeTableProvider()),
        ChangeNotifierProvider(create: (_) => TempTimeTableProvider()),
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
