import 'package:flutter/material.dart';

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
      height: 200,
      width: 180,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            24,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              description,
              style: TextStyle(color: Colors.grey[700]),
            ),
            body,
          ],
        ),
      ),
    );
  }
}
