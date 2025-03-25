import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/model/course.dart';
import 'package:studybuddy/model/hive_boxes.dart';
import 'package:studybuddy/model/user.dart';
import 'package:studybuddy/provider/user_data_provider.dart';
import 'package:studybuddy/utils/days_enum.dart';
import 'package:studybuddy/utils/extension.dart';
import 'package:studybuddy/utils/text_style.dart';
import 'package:studybuddy/widgets/custom_textfield2.dart';
import 'package:uuid/uuid.dart';

class EditDetails extends StatefulWidget {
  const EditDetails({super.key});

  @override
  State<EditDetails> createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {
  late TextEditingController nameCtrl;
  late TextEditingController deptCtrl;
  late TextEditingController courseCtrl = TextEditingController();
  late TextEditingController courseCodeCtrl = TextEditingController();
  final levels = [1, 2, 3, 4, 5];
  List<Course> courses = [];
  int? selectedLevel;
  List<Day> days = [];

  @override
  void initState() {
    nameCtrl = TextEditingController(
      text: Hive.box<User>(HiveBoxes.userBox).values.first.userName,
    );
    deptCtrl = TextEditingController(
      text: Hive.box<User>(HiveBoxes.userBox).values.first.userDepartment,
    );
    selectedLevel = Hive.box<User>(HiveBoxes.userBox).values.first.userLevel;
    courses = Hive.box<User>(HiveBoxes.userBox).values.first.userCourses;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () {
                if (nameCtrl.text.trim() !=
                    context.read<UserDataProvider>().user!.userName) {
                  context
                      .read<UserDataProvider>()
                      .updateName(nameCtrl.text.trim());
                }
                if (deptCtrl.text.trim() !=
                    context.read<UserDataProvider>().user!.userDepartment) {
                  context
                      .read<UserDataProvider>()
                      .updateDept(deptCtrl.text.trim());
                }
                if (selectedLevel !=
                    context.read<UserDataProvider>().user!.userLevel) {
                  context.read<UserDataProvider>().updateLevel(selectedLevel!);
                }

                context.read<UserDataProvider>().updateCourses(courses);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Saved",
                      style: kTextStyle(15),
                    ),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(4),
                    duration: const Duration(milliseconds: 700),
                  ),
                );
                Navigator.pop(context);
              },
              child: Text(
                "Save",
                style: kTextStyle(15),
              ),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 13,
              children: [
                Center(
                  child: const Icon(
                    size: 200,
                    Iconsax.profile_circle,
                    color: Color(0xff497255),
                  ),
                ),
                TextField(
                  controller: nameCtrl,
                  onChanged: (newName) {},
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
                TextField(
                  controller: deptCtrl,
                  onChanged: (newDept) {
                    context.read<UserDataProvider>().updateDept(newDept);
                  },
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
                        icon: const Icon(Iconsax.arrow_down_1_copy),
                      ),
                    ),
                  ),
                ),
                Wrap(
                  spacing: 5,
                  children: [
                    ...courses.map((course) {
                      return FilterChip(
                        padding: const EdgeInsets.all(10),
                        color: WidgetStatePropertyAll(Colors.green[100]),
                        deleteIcon: const Icon(Icons.cancel),
                        onDeleted: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "Delete course",
                                  style: kTextStyle(20, isBold: true),
                                ),
                                content: SizedBox(
                                    width: context.screenWidth * .70,
                                    child: Text(
                                      "Do you want to delete this course",
                                      style: kTextStyle(18),
                                    )),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        courses = courses
                                            .where((crs) => crs != course)
                                            .toList();
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Yes",
                                      style: kTextStyle(16),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "No",
                                      style: kTextStyle(16),
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                        },
                        label: Text(course.courseCode),
                        onSelected: (_) {},
                      );
                    }),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(4),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            isDismissible: false,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (contex, setState) {
                                return Container(
                                  margin: EdgeInsets.all(15),
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Column(
                                    spacing: 10,
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Add course",
                                        style: kTextStyle(25, isBold: true),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        spacing: 5,
                                        children: [
                                          TextFieldWidget2(
                                            textCapitalization:
                                                TextCapitalization.words,
                                            textEditingController: courseCtrl,
                                            label: "Course Title",
                                            hintText: "E.g Math",
                                            prefixIcon:
                                                const Icon(Iconsax.book),
                                          ),
                                          TextFieldWidget2(
                                            textCapitalization:
                                                TextCapitalization.characters,
                                            textEditingController:
                                                courseCodeCtrl,
                                            label: "Course Code",
                                            hintText: "E.g ABC1203",
                                            prefixIcon:
                                                const Icon(Iconsax.code),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        spacing: 5,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () {
                                                courseCodeCtrl.clear();
                                                courseCtrl.clear();
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                "Cancel",
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: FilledButton(
                                              onPressed: () {
                                                setState(() {
                                                  courses.add(Course(
                                                    courseTitle:
                                                        courseCtrl.text.trim(),
                                                    courseCode: courseCodeCtrl
                                                        .text
                                                        .trim(),
                                                    courseId: const Uuid().v4(),
                                                  ));
                                                });
                                                courseCodeCtrl.clear();
                                                courseCtrl.clear();
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Add",
                                                  style: kTextStyle(14)),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });
                            });
                      },
                      child: const Icon(Iconsax.add_copy),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
