import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/model/user.dart';
import 'package:studybuddy/provider/user_data_provider.dart';
import 'package:studybuddy/utils/text_style.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserDataProvider? userDataProvider = Provider.of<UserDataProvider>(context);
    User? user = userDataProvider.user;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              controller: tabController,
              isScrollable: false,
              tabs: const [
                Tab(
                  text: "Classes",
                ),
                Tab(
                  text: "Tasks",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ...user!.userCourses.map(
                          (course) => ListTile(
                            leading: Text(
                              course.courseTitle,
                              style: kTextStyle(16),
                            ),
                            trailing: Text(
                              course.courseCode,
                              style: kTextStyle(16),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Center(child: Text('Favorites Screen')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
