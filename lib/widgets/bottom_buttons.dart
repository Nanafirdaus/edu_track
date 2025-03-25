import 'package:flutter/material.dart';
import 'package:studybuddy/utils/text_style.dart';

class BottomButtons extends StatelessWidget {
  final int current;
  final VoidCallback onNextTapped;
  final VoidCallback onPrevTapped;
  final String label1, label2;
  const BottomButtons({
    required this.current,
    required this.onNextTapped,
    required this.onPrevTapped,
    required this.label1,
    required this.label2,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: current == 0
            ? MainAxisAlignment.end
            : MainAxisAlignment.spaceBetween,
        children: [
          if (current != 0)
            SizedBox(
              height: 50,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onPrevTapped,
                child: Text(
                  label1,
                  style: kTextStyle(18, isBold: true, color: Colors.green),
                ),
              ),
            ),
          SizedBox(
            height: 50,
            child: FilledButton(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onNextTapped,
              child: Text(
                label2,
                style: kTextStyle(18, isBold: true, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
