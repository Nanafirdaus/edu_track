import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:studybuddy/model/hive_boxes.dart';
import 'package:studybuddy/model/user.dart';
import 'package:studybuddy/services/hive_db.dart';
import 'package:studybuddy/utils/text_style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  HiveDB hiveDB = HiveDB(userBox: Hive.box(HiveBoxes.userBox));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Profile"),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Edit",
              style: kTextStyle(18),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: hiveDB.listenable(),
          builder: (context, hiveBox, _) {
            User? user = hiveBox.get('userKey');
            return Padding(
              padding: const EdgeInsets.all(50.0),
              child: Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 80,
                      child: Icon(
                        Icons.person,
                        size: 80,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      user!.userName,
                      style: kTextStyle(25, isBold: true),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container()
                  ],
                ),
              ),
            );
          }),
    );
  }
}
