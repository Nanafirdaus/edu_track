import 'package:intl/intl.dart';

extension DateTimeUtils on DateTime {
  String get formatDateTime {
    final intl = Intl();
    final format = intl.date(DateFormat.ABBR_MONTH_WEEKDAY_DAY);
    return format.format(this);
  }

  String format(String dateFormt) {
    final intl = Intl();
    final format = intl.date(dateFormt);
    return format.format(this);
  }
}
