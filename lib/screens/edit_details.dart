import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:studybuddy/model/hive_boxes.dart';
import 'package:studybuddy/model/user.dart';

class EditDetails extends StatefulWidget {
  const EditDetails({super.key});

  @override
  State<EditDetails> createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController(
        text: Hive.box<User>(HiveBoxes.userBox).values.first.userName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            const CircleAvatar(
              radius: 80,
              child: Icon(size: 80, Icons.person),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: textEditingController,
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff92E3A9),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          15,
                        ),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
