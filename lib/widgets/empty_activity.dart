import 'package:flutter/material.dart';
import 'package:studybuddy/screens/timetable_creation.dart';

import '../utils/text_style.dart';

class EmptyActivity extends StatelessWidget {
  final String text;
  bool? today;
  EmptyActivity({super.key, required this.text, this.today = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        Image.asset(
          "assets/images/addnote.png",
          height: 300,
        ),
        if (!today!) ...{
          Text(
            text == "class"
                ? "No classes today"
                : "Nothing to show here\nCreate ${text.toLowerCase()} to get started",
            style: kTextStyle(18),
            textAlign: TextAlign.center,
          ),
          if (text != "class")
            FilledButton(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (cotext) => TimetableCreationScreen()),
                );
              },
              child: Text(
                "Create $text",
                style: kTextStyle(18),
              ),
            )
        } else ...{
          Text(
            "No $text today",
            style: kTextStyle(30),
          )
        }
      ],
    );
  }
}
