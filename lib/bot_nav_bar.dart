import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/model/user.dart';
import 'package:studybuddy/provider/user_data_provider.dart';
import 'package:studybuddy/screens/activity.dart';
import 'package:studybuddy/screens/home.dart';
import 'package:studybuddy/screens/profile.dart';
import 'package:studybuddy/utils/extension.dart';
import 'package:studybuddy/utils/text_style.dart';

class AppBottomNavBar extends StatefulWidget {
  const AppBottomNavBar({super.key});

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar>
    with SingleTickerProviderStateMixin {
  List<Widget> screens = const [
    HomeScreen(),
    ActivityScreen(),
    ProfileScreen(),
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    UserDataProvider? userDataProvider = Provider.of<UserDataProvider>(context);
    User? user = userDataProvider.user;
    String selectedCourse = user!.userCourses[0].courseTitle;
    TextEditingController descriptionCtrl = TextEditingController();
    TextEditingController dateTimeCtrl = TextEditingController();

    return Scaffold(
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              DateTime? date;
              TimeOfDay? timeOfDay;
              DateTime? dateTime;

              return BottomSheet(
                  showDragHandle: true,
                  onClosing: () {
                    log("Closing");
                    dateTimeCtrl.clear();
                    descriptionCtrl.clear();
                    setState(() {
                      selectedCourse = user!.userCourses[0].courseTitle;
                    });
                  },
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return SizedBox(
                        height: context.screenHeight * .8,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: SingleChildScrollView(
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
                                        ...user.userCourses.map(
                                          (course) {
                                            return ChoiceChip(
                                              label: Text(
                                                course.courseTitle,
                                                style: kTextStyle(16),
                                              ),
                                              selected: selectedCourse ==
                                                  course.courseTitle,
                                              onSelected: (_) {
                                                setState(() {
                                                  selectedCourse =
                                                      course.courseTitle;
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
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      decoration: InputDecoration(
                                        hintText: "Task description",
                                        hintStyle:
                                            kTextStyle(15, color: Colors.grey),
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text("Due date",
                                        style: kTextStyle(18, isBold: true)),
                                    const SizedBox(height: 5),
                                    TextField(
                                      readOnly: true,
                                      controller: dateTimeCtrl,
                                      decoration: InputDecoration(
                                        hintText: "Task description",
                                        hintStyle:
                                            kTextStyle(15, color: Colors.grey),
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
                                                    data: MediaQuery.of(context)
                                                        .copyWith(
                                                            alwaysUse24HourFormat:
                                                                false),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      width: context.screenWidth * .3,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )),
                                        onPressed: () {
                                          descriptionCtrl.clear();
                                          dateTimeCtrl.clear();
                                          selectedCourse =
                                              user!.userCourses[0].courseTitle;
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: kTextStyle(18,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: context.screenWidth * .3,
                                      child: ListenableBuilder(
                                          listenable: Listenable.merge(
                                              [descriptionCtrl, dateTimeCtrl]),
                                          builder: (context, _) {
                                            bool isEnabled = descriptionCtrl
                                                    .text.isNotEmpty &&
                                                dateTimeCtrl.text.isNotEmpty;
                                            return ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                backgroundColor: isEnabled
                                                    ? const Color(0xff497255)
                                                    : Colors.grey,
                                              ),
                                              onPressed: () {},
                                              child: Text(
                                                "Save",
                                                style: kTextStyle(18,
                                                    color: Colors.white),
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  });
            },
          );
        },
        elevation: 2,
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (newIndex) {
          setState(() {
            currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.grey,
            icon: Icon(
              Icons.home_filled,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: "Activity",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
