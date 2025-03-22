import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/provider/model/assignment_schedule.dart';
import 'package:studybuddy/provider/model/user.dart';
import 'package:studybuddy/provider/assignment_provider.dart';
import 'package:studybuddy/provider/user_data_provider.dart';
import 'package:studybuddy/utils/extension.dart';
import 'package:studybuddy/utils/text_style.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen>
    with SingleTickerProviderStateMixin {
  DateTime? date;
  TimeOfDay? timeOfDay;
  DateTime? dateTime;
  int selectedCourse = 0;
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController dateTimeCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserDataProvider? userDataProvider = Provider.of<UserDataProvider>(context);
    User? user = userDataProvider.user;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select courses",
                          style: kTextStyle(18, isBold: true),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 5,
                          children: [
                            ...user!.userCourses.map(
                              (course) {
                                return ChoiceChip(
                                  label: Text(
                                    course.courseTitle,
                                    style: kTextStyle(16),
                                  ),
                                  selected: user.userCourses[selectedCourse]
                                          .courseTitle ==
                                      course.courseTitle,
                                  onSelected: (_) {
                                    setState(() {
                                      selectedCourse =
                                          user.userCourses.indexOf(course);
                                    });
                                  },
                                );
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Description",
                          style: kTextStyle(18, isBold: true),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: descriptionCtrl,
                          style: kTextStyle(15),
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: "Task description",
                            hintStyle: kTextStyle(15, color: Colors.grey),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text("Due date", style: kTextStyle(18, isBold: true)),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          controller: dateTimeCtrl,
                          decoration: InputDecoration(
                            hintText: "Task description",
                            hintStyle: kTextStyle(15, color: Colors.grey),
                            border: const OutlineInputBorder(),
                          ),
                          onTap: () async {
                            date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2099),
                            );
                            if (date != null) {
                              timeOfDay = await showTimePicker(
                                  // ignore: use_build_context_synchronously
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  builder: (context, child) {
                                    return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: false),
                                        child: child!);
                                  });
                              if (timeOfDay != null) {
                                dateTime = DateTime(
                                    date!.year,
                                    date!.month,
                                    date!.day,
                                    timeOfDay!.hour,
                                    timeOfDay!.minute);
                                setState(() {
                                  dateTimeCtrl.text =
                                      "${DateFormat('d/M/y').format(dateTime!)} - ${DateFormat.Hm().format(dateTime!)}";
                                });
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 50,
                          width: context.screenWidth * .3,
                        ),
                        SizedBox(
                          height: 50,
                          width: context.screenWidth * .3,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListenableBuilder(
              listenable: Listenable.merge([descriptionCtrl, dateTimeCtrl]),
              builder: (context, _) {
                bool isEnabled = descriptionCtrl.text.isNotEmpty &&
                    dateTimeCtrl.text.isNotEmpty;
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: context.screenHeight * .05,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor:
                            isEnabled ? const Color(0xff497255) : Colors.grey,
                      ),
                      onPressed: () {
                        if (isEnabled) {
                          context.read<AssignmentProvider>().addAssignment(
                                AssignmentSchedule(
                                  isCompleted: false,
                                  courseId: selectedCourse.toString(),
                                  assignmentDateTime: dateTime!,
                                  assignmentId: DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString(),
                                  description: descriptionCtrl.text.trim(),
                                ),
                              );
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "Save",
                        style: kTextStyle(18, color: Colors.white),
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
