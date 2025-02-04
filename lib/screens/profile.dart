import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/model/hive_boxes.dart';
import 'package:studybuddy/model/user.dart';
import 'package:studybuddy/provider/assignment_provider.dart';
import 'package:studybuddy/screens/edit_details.dart';
import 'package:studybuddy/services/hive_db.dart';
import 'package:studybuddy/utils/text_style.dart';
import 'package:studybuddy/widgets/custom_container.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserDataDB hiveDB = UserDataDB(userBox: Hive.box(HiveBoxes.userBox));

  @override
  Widget build(BuildContext context) {
    AssignmentProvider assignmentProvider =
        Provider.of<AssignmentProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Profile"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditDetails(),
                ),
              );
            },
            icon: const Icon(
              Icons.settings,
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: hiveDB.listenable(),
          builder: (context, hiveBox, _) {
            User? user = hiveBox.get('userKey');
            return Padding(
              padding: const EdgeInsets.all(35.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 80,
                      child: Icon(
                        Icons.person,
                        size: 80,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      user!.userName,
                      style: kTextStyle(25, isBold: true),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TaskCard(
                          title: 'Pending Task',
                          description: 'Next 7 Days',
                          body: Text(
                              '${assignmentProvider.assignments.where((assignment) => !assignment.isCompleted).length}',
                              style: kTextStyle(
                                30,
                                color: Colors.red,
                              )),
                        ),
                        TaskCard(
                          title: 'Overdue Task',
                          description: 'Next 7 Days',
                          body: Text(
                            assignmentProvider.assignments
                                .where((assignment) =>
                                    assignment.assignmentDateTime
                                        .isAfter(DateTime.now()) &&
                                    !assignment.isCompleted)
                                .length
                                .toString(),
                            style: kTextStyle(
                              30,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
