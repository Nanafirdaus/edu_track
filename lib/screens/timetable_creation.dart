import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/model/datetime_from_to.dart';
import 'package:studybuddy/provider/time_table_provider.dart';
import 'package:studybuddy/provider/user_data_provider.dart';
import 'package:studybuddy/utils/days_enum.dart';
import 'package:studybuddy/utils/text_style.dart';
import 'package:studybuddy/widgets/bottom_buttons.dart';
import 'package:studybuddy/widgets/date_time_widget.dart';
import 'package:studybuddy/widgets/timetable_data_fields.dart';

class TimetableCreationScreen extends StatefulWidget {
  const TimetableCreationScreen({super.key});

  @override
  State<TimetableCreationScreen> createState() =>
      _TimetableCreationScreenState();
}

class _TimetableCreationScreenState extends State<TimetableCreationScreen> {
  PageController pageController = PageController();
  int currentIndex = 0;
  List<List<TextEditingController>>? textEditingCtrls;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      textEditingCtrls = List.generate(
          context.read<UserDataProvider>().user!.userCourses.length, (index) {
        return [TextEditingController(), TextEditingController()];
      });
      log(textEditingCtrls!.length.toString());
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    UserDataProvider userDataProvider = Provider.of<UserDataProvider>(context);
    TimeTableProvider timeTableProvider =
        Provider.of<TimeTableProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 500),
                      tween:
                          Tween<double>(begin: 0, end: currentIndex.toDouble()),
                      builder: (context, val, _) {
                        return LinearProgressIndicator(
                          value: ((val + 1) /
                              userDataProvider.user!.userCourses.length),
                          backgroundColor: Colors.grey[400],
                        );
                      }),
                ),
                Expanded(
                  child: Column(
                    children: [
                      // Text(
                      //   "${currentIndex + 1}/${userDataProvider.user!.userCourses.length}",
                      //   style: kTextStyle(18, isBold: true),
                      // ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .90,
                        child: Center(
                          child: Text(
                            userDataProvider
                                .user!.userCourses[currentIndex].courseTitle,
                            style: kTextStyle(35, isBold: true),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        "Select days",
                        style: kTextStyle(15, isBold: true),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: PageView(
                          controller: pageController,
                          onPageChanged: (newIndex) {
                            setState(() {
                              currentIndex = newIndex;
                            });
                            log(currentIndex.toString());
                          },
                          children: [
                            ...userDataProvider.user!.userCourses.map((course) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Wrap(
                                        spacing: 3,
                                        children: [
                                          ...Day.values.map((day) {
                                            return FilterChip(
                                              selectedColor: Colors.green,
                                              label: Text(
                                                day.name,
                                                style: kTextStyle(15,
                                                    color: timeTableProvider
                                                            .timetableDataList[
                                                                currentIndex]
                                                            .days
                                                            .contains(day)
                                                        ? Colors.white
                                                        : Colors.black),
                                              ),
                                              selected: timeTableProvider
                                                  .timetableDataList[
                                                      currentIndex]
                                                  .days
                                                  .contains(day),
                                              onSelected: (_) {
                                                timeTableProvider.updateDays(
                                                  day,
                                                  currentIndex,
                                                );
                                                setState(() {});
                                              },
                                            );
                                          })
                                        ],
                                      ),
                                      const SizedBox(height: 30),
                                      ...Day.values.map((day) {
                                        if (timeTableProvider
                                            .timetableDataList[currentIndex]
                                            .days
                                            .contains(day)) {
                                          int dateTimeFromToIndex =
                                              timeTableProvider
                                                  .timetableDataList[
                                                      currentIndex]
                                                  .days
                                                  .indexOf(day);
                                          TimeOfDay timeOfDay1 =
                                              TimeOfDay.fromDateTime(
                                                  DateTime.now().copyWith(
                                                      hour: 8, minute: 0));
                                          TimeOfDay timeOfDay2 =
                                              TimeOfDay.fromDateTime(
                                                  DateTime.now().copyWith(
                                                      hour: 8, minute: 0));
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  day.name[0].toUpperCase() +
                                                      day.name.substring(1),
                                                  style: kTextStyle(25,
                                                      isBold: true),
                                                ),
                                                const SizedBox(height: 10),
                                                if (timeTableProvider
                                                    .timetableDataList[
                                                        currentIndex]
                                                    .dateTimeFromTo
                                                    .isNotEmpty)
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: InkWell(
                                                          onTap: () async {
                                                            final result =
                                                                await showTimePicker(
                                                                    initialTime:
                                                                        timeOfDay1,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context,
                                                                            child) {
                                                                      return MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            alwaysUse24HourFormat:
                                                                                false),
                                                                        child:
                                                                            child!,
                                                                      );
                                                                    });
                                                            DatetimeFromTo newDateTimeFromTo = timeTableProvider
                                                                .timetableDataList[
                                                                    currentIndex]
                                                                .dateTimeFromTo[
                                                                    dateTimeFromToIndex]
                                                                .copyWith(
                                                                    from: DateTime.now().copyWith(
                                                                        hour: result!
                                                                            .hour,
                                                                        minute:
                                                                            result.minute));
                                                            timeTableProvider
                                                                    .timetableDataList[
                                                                        currentIndex]
                                                                    .dateTimeFromTo[dateTimeFromToIndex] =
                                                                newDateTimeFromTo;
                                                            setState(() {});
                                                          },
                                                          child: DateTimeWidget(
                                                              dateTime: timeTableProvider
                                                                  .timetableDataList[
                                                                      currentIndex]
                                                                  .dateTimeFromTo[
                                                                      dateTimeFromToIndex]
                                                                  .from),
                                                        ),
                                                      ),
                                                      const Icon(
                                                          Icons.arrow_right),
                                                      Expanded(
                                                        child: InkWell(
                                                          onTap: () async {
                                                            final result =
                                                                await showTimePicker(
                                                                    initialTime:
                                                                        timeOfDay2,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context,
                                                                            child) {
                                                                      return MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            alwaysUse24HourFormat:
                                                                                false),
                                                                        child:
                                                                            child!,
                                                                      );
                                                                    });
                                                            DatetimeFromTo newDateTimeFromTo = timeTableProvider
                                                                .timetableDataList[
                                                                    currentIndex]
                                                                .dateTimeFromTo[
                                                                    dateTimeFromToIndex]
                                                                .copyWith(
                                                                    to: DateTime.now().copyWith(
                                                                        hour: result!
                                                                            .hour,
                                                                        minute:
                                                                            result.minute));
                                                            timeTableProvider
                                                                    .timetableDataList[
                                                                        currentIndex]
                                                                    .dateTimeFromTo[dateTimeFromToIndex] =
                                                                newDateTimeFromTo;
                                                            setState(() {});
                                                          },
                                                          child: DateTimeWidget(
                                                              dateTime: timeTableProvider
                                                                  .timetableDataList[
                                                                      currentIndex]
                                                                  .dateTimeFromTo[
                                                                      dateTimeFromToIndex]
                                                                  .to),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                              ],
                                            ),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      }),
                                      TimetableDataFields(
                                        textEditingCtrls: textEditingCtrls!,
                                        currentIndex: currentIndex,
                                      ),
                                    ],
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
                BottomButtons(
                  current: currentIndex,
                  onNextTapped: () {
                    if (currentIndex + 1 ==
                        userDataProvider.user!.userCourses.length) {
                      timeTableProvider.createTimetable(context);
                      return;
                    }
                    if (currentIndex <
                        userDataProvider.user!.userCourses.length) {
                      if (timeTableProvider.timetableDataList[currentIndex].days
                              .isNotEmpty &&
                          timeTableProvider.timetableDataList[currentIndex]
                              .dateTimeFromTo.isNotEmpty) {
                        pageController.jumpToPage(currentIndex + 1);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Fill the required fields"),
                            duration: Duration(milliseconds: 800),
                          ),
                        );
                      }
                    }
                  },
                  onPrevTapped: () {
                    if (currentIndex > 0) {
                      pageController.jumpToPage(currentIndex - 1);
                    }
                  },
                  label1: "Previous",
                  label2: currentIndex + 1 <
                          userDataProvider.user!.userCourses.length
                      ? "Next"
                      : "Create Timetable",
                )
              ],
            ),
    );
  }
}
