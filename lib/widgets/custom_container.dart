import 'package:flutter/material.dart';
import 'package:studybuddy/utils/extension.dart';
import 'package:studybuddy/utils/text_style.dart';

class TaskCard extends StatelessWidget {
  final String title, description;
  final Widget body;
  const TaskCard(
      {required this.title,
      required this.description,
      required this.body,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.screenHeight * .2,
      width: context.screenWidth * .4,
      decoration: BoxDecoration(
        color: Colors.greenAccent.withOpacity(0.2),
        borderRadius: BorderRadius.all(
          Radius.circular(
            24,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: kTextStyle(20, isBold: true),
            ),
            body,
            Text(
              description,
              style: kTextStyle(16),
            ),
          ],
        ),
      ),
    );
  }
}
