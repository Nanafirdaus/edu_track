import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:studybuddy/provider/model/assignment_schedule.dart';
import 'package:studybuddy/provider/model/timetabledata.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize notification service
  static Future<void> init() async {
    tz_data.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  /// Schedule an assignment notification at the exact time
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
    );

    log('Scheduled notification for ${assignment.description} at $scheduledTime');
  }

  /// Schedule a timetable notification at the exact class time
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
            );

            // Schedule a notification 5 seconds before class starts
            await schedulePreNotification(
              'Upcoming Class Reminder',
              'Your class for ${timetable.course.courseTitle} starts soon!',
              dateTimeFromTo.from!,
              timetable.id.hashCode + i + 100, // Unique ID
            );
          }
        }
      }
    }
    log('Scheduled notifications for timetable');
  }

  /// Schedule a notification 5 seconds before the given event time
  static Future<void> schedulePreNotification(
      String title, String body, DateTime eventTime, int id) async {
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(eventTime, tz.local)
        .subtract(const Duration(seconds: 5));

    await _notificationsPlugin.zonedSchedule(
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      id,
      title,
      body,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'pre_notification_channel',
          'Pre-event Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );

    log('Scheduled pre-notification for $title at $scheduledTime');
  }

  /// Schedule notifications when an assignment or timetable event is added
  static Future<void> scheduleNotificationsOnAdd(
      {AssignmentSchedule? assignment, List<TimeTableData>? timetable}) async {
    if (assignment != null) {
      await scheduleAssignmentNotification(assignment);

      // Schedule a notification 5 seconds before assignment is due
      await schedulePreNotification(
        'Assignment Reminder',
        '${assignment.courseId}: ${assignment.description} is due soon!',
        assignment.assignmentDateTime,
        assignment.assignmentId.hashCode + 200, // Unique ID
      );
    }
    if (timetable != null) {
      await scheduleTimetableNotifications(timetable);
    }
  }
}
