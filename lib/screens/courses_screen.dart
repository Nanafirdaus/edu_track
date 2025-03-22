import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:studybuddy/bot_nav_bar.dart';
import 'package:studybuddy/provider/model/course.dart';
import 'package:studybuddy/provider/model/hive_boxes.dart';
import 'package:studybuddy/provider/model/user.dart';
import 'package:studybuddy/services/hive_db.dart';
import 'package:studybuddy/utils/extension.dart';
import 'package:studybuddy/utils/text_style.dart';
import 'package:studybuddy/widgets/custom_textfield2.dart';
import '../services/onboarding_pref.dart';

class CoursesScreen extends StatefulWidget {
  final String name, dept;
  final int level;
  const CoursesScreen({
    required this.name,
    required this.dept,
    required this.level,
    super.key,
  });

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  List<Course> courses = [];
  UserDataDB hiveDB = UserDataDB(userBox: Hive.box(HiveBoxes.userBox));
  late bool courseIsEmpty;

  @override
  void initState() {
    super.initState();
    courseIsEmpty = courses.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Add Courses"),
                          content: SizedBox(
                            height: 120,
                            width: context.screenWidth * .85,
                            child: Column(
                              children: [
                                TextFieldWidget2(
                                  textCapitalization: TextCapitalization.words,
                                  textEditingController: titleController,
                                  label: "Course Title",
                                  hintText: "E.g Math",
                                  prefixIcon: const Icon(Icons.book),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFieldWidget2(
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  textEditingController: codeController,
                                  label: "Course Code",
                                  hintText: "E.g ABC1203",
                                  prefixIcon: const Icon(Icons.code),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Cancel",
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  courses = [
                                    ...courses,
                                    Course(
                                      courseTitle: titleController.text.trim(),
                                      courseCode: codeController.text.trim(),
                                      courseId: DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                    ),
                                  ];
                                  courseIsEmpty = courses.isEmpty;
                                });
                                titleController.clear();
                                codeController.clear();
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Add",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      "Add Course",
                      style: TextStyle(color: Color(0xff497255), fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
          title: const Text(
            "Course List",
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Center(
              child: Image.asset(
                "assets/images/addnote.png",
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  Course course = courses[index];
                  return ListTile(
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          courses.remove(course);
                          courseIsEmpty = courses.isEmpty;
                        });
                      },
                      icon: const Icon(
                        Icons.delete,
                      ),
                    ),
                    title: Text(
                      course.courseTitle,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                    subtitle: Text(
                      course.courseCode,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: context.screenWidth,
                  height: context.screenHeight * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: courseIsEmpty
                            ? Colors.grey
                            : const Color(0xff497255)),
                    onPressed: () async {
                      if (!courseIsEmpty) {
                        await hiveDB.saveUserData(
                          User(
                            userName: widget.name,
                            userDepartment: widget.dept,
                            userLevel: widget.level,
                            userCourses: courses,
                          ),
                        );
                        await OnboardingPref.passOnboardingScreen();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppBottomNavBar(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    child: Text(
                      "Save and Continue",
                      style: kTextStyle(
                        color: Colors.white,
                        16,
                      ),
                    ),
                  ),
                )),
          ],
        ));
  }
}
