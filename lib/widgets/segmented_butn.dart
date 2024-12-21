import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/provider/segmented_btn_provider.dart';
import 'package:studybuddy/utils/extension.dart';
import 'package:studybuddy/utils/text_style.dart';

class CustomSegmentedButton extends StatelessWidget {
  const CustomSegmentedButton({super.key});

  @override
  Widget build(BuildContext context) {
    var sButtonController = Provider.of<SegmentedButtonController>(context);
    bool classIsSelected = sButtonController.classIsSelected;
    return Container(
      width: context.screenWidth * .5,
      padding: const EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF474747),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                !classIsSelected
                    ? sButtonController.toggleSelection(true)
                    : null;
              },
              child: Card(
                elevation: classIsSelected ? 1 : 0,
                color: classIsSelected
                    ? const Color(0xFFB9B9B9)
                    : const Color(0xFFF6F6F6),
                shape: RoundedRectangleBorder(
                  side: classIsSelected ? BorderSide.none : BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  height: 40,
                  child: Center(
                    child: Text(
                      "Classes",
                      style: kTextStyle(12, isBold: true),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                classIsSelected
                    ? sButtonController.toggleSelection(false)
                    : null;
              },
              child: Card(
                elevation: classIsSelected ? 0 : 1,
                color: !classIsSelected
                    ? const Color(0xFFB9B9B9)
                    : const Color(0xFFF6F6F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: !classIsSelected ? BorderSide.none : BorderSide.none,
                ),
                child: SizedBox(
                  height: 40,
                  child: Center(
                    child: Text(
                      "Tasks",
                      style: kTextStyle(12, isBold: true),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
