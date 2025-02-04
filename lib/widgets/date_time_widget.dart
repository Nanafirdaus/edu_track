import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeWidget extends StatelessWidget {
  final DateTime? dateTime;

  const DateTimeWidget({required this.dateTime, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
          child: Text(
        dateTime == null
            ? "Select time"
            : Intl().date(DateFormat.HOUR_MINUTE).format(dateTime!),
      )),
    );
  }
}
