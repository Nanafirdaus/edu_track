import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:studybuddy/model/hive_boxes.dart';
import 'package:studybuddy/model/user.dart';
import 'package:studybuddy/services/hive_db.dart';
import 'package:studybuddy/utils/date_time_utils.dart';
import 'package:studybuddy/utils/text_style.dart';
import 'package:studybuddy/widgets/segmented_butn.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HiveDB hiveDB = HiveDB(userBox: Hive.box(HiveBoxes.userBox));
  String selectedOption = "Classes";

  List<Widget> screens = const [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: hiveDB.listenable(),
          builder: (context, hiveBox, _) {
            User? user = hiveBox.get('userKey');
            return Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hello,",
                          style: kTextStyle(
                            40,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          user!.userName.split(' ').first,
                          style: kTextStyle(40, isBold: true),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(DateTime.now().formatDateTime,
                        style: kTextStyle(30, color: Colors.grey)),
                    const SizedBox(
                      height: 20,
                    ),
                    const CustomSegmentedButton(),
                    // Expanded(
                    //   child: SingleChildScrollView(
                    //     child: Column(
                    //       children: [
                    //         // context.watch<SegmentedButtonController>().classIsSelected ? null : context.watch<AssignmentProvider>().assignments.where((assignment) => assignment.assignment)
                    //       ],
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
