import 'package:flutter/material.dart';

class TimetableDataFields extends StatelessWidget {
  final List<List<TextEditingController>> textEditingCtrls;
  final int currentIndex;
  const TimetableDataFields(
      {required this.textEditingCtrls, required this.currentIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: TextField(
            controller: textEditingCtrls[currentIndex][0],
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              labelText: "Lecturer",
              border: OutlineInputBorder(),
              
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: TextField(
            controller: textEditingCtrls[currentIndex][1],
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              labelText: "Venue",
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
