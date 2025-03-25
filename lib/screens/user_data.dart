import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:studybuddy/model/hive_boxes.dart';
import 'package:studybuddy/screens/courses_screen.dart';
import 'package:studybuddy/services/hive_db.dart';
import 'package:studybuddy/utils/extension.dart';
import 'package:studybuddy/utils/text_style.dart';
import 'package:studybuddy/widgets/custom_textfield1.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key});

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  final levels = [1, 2, 3, 4, 5];
  int? selectedLevel;
  TextEditingController nameController = TextEditingController();
  TextEditingController deptController = TextEditingController();
  UserDataDB hiveDB = UserDataDB(userBox: Hive.box(HiveBoxes.userBox));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/hat.png",
                height: 250,
              ),
              SizedBox(
                width: context.screenWidth,
                height: context.screenHeight * 0.045,
                child: Center(
                  child: Text(
                    "Input your Details",
                    style: kTextStyle(
                      (35),
                      isBold: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    TextFieldWidget(
                      formFieldValidator: (value) {
                        value.toString().isEmpty
                            ? "Please enter your name"
                            : null;
                        return null;
                      },
                      textEditingController: nameController,
                      prefixIcon: const Icon(
                        Icons.person,
                        size: 18,
                      ),
                      hintText: "Enter John Doe",
                      label: "Name",
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFieldWidget(
                      formFieldValidator: (value) {
                        value.toString().isEmpty
                            ? "Please enter your department"
                            : null;
                        return null;
                      },
                      textEditingController: deptController,
                      prefixIcon: const Icon(
                        Icons.place_rounded,
                        size: 18,
                      ),
                      hintText: "E.g Information Technology",
                      label: "Department",
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: context.screenWidth,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                15,
                              ),
                            ),
                            border: Border.all()),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            hint: const Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.school,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text("Select level"),
                              ],
                            ),
                            value: selectedLevel,
                            items: levels.map((int item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.school,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text("Level $item"),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (item) {
                              setState(() {
                                selectedLevel = item!;
                              });
                            },
                            icon: const Icon(Icons.arrow_drop_down),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ListenableBuilder(
                        listenable: Listenable.merge(
                          [
                            nameController,
                            deptController,
                          ],
                        ),
                        builder: (context, _) {
                          bool? isEnabled = nameController.text.isNotEmpty &&
                              deptController.text.isNotEmpty &&
                              selectedLevel != null;
                          return SizedBox(
                            width: context.screenWidth,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (isEnabled) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return CoursesScreen(
                                      name: nameController.text.trim(),
                                      dept: deptController.text.trim(),
                                      level: selectedLevel!,
                                    );
                                  }));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: isEnabled
                                    ? const Color(0xff497255)
                                    : Colors.grey,
                              ),
                              child: const Text(
                                "Continue",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
