import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:studybuddy/model/assignment_schedule.dart';
import 'package:studybuddy/model/timetabledata.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz_data.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> scheduleAssignmentNotification(
      AssignmentSchedule assignment) async {
    final tz.TZDateTime scheduledTime =
        tz.TZDateTime.from(assignment.assignmentDateTime, tz.local);

    await _notificationsPlugin.zonedSchedule(
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      assignment.assignmentId.hashCode,
      'Assignment Due',
      '${assignment.courseId}: ${assignment.description} is due soon!',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'assignment_channel',
          'Assignment Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    log('Scheduled notification for ${assignment.description}');
  }

  static Future<void> scheduleTimetableNotifications(
      List<TimeTableData> timetableDataList) async {
    for (var timetable in timetableDataList) {
      for (var i = 0; i < timetable.days.length; i++) {
        if (timetable.dateTimeFromTo.isNotEmpty) {
          final dateTimeFromTo = timetable.dateTimeFromTo[i];
          if (dateTimeFromTo.from != null) {
            final tz.TZDateTime scheduledTime = tz.TZDateTime.from(
              dateTimeFromTo.from!,
              tz.local,
            );

            await _notificationsPlugin.zonedSchedule(
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              timetable.id.hashCode + i,
              'Upcoming Class',
              '${timetable.course.courseTitle} with ${timetable.lecturerName} at ${timetable.venue}',
              scheduledTime,
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'timetable_channel',
                  'Class Schedule Notifications',
                  importance: Importance.high,
                  priority: Priority.high,
                ),
              ),
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
            );
          }
        }
      }
    }
    log('Scheduled notifications for timetable');
  }

  static Future<void> scheduleNotificationsOnAdd(
      {AssignmentSchedule? assignment, List<TimeTableData>? timetable}) async {
    if (assignment != null) {
      await scheduleAssignmentNotification(assignment);
    }
    if (timetable != null) {
      await scheduleTimetableNotifications(timetable);
    }
  }
}
