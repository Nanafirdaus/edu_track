import 'package:flutter/material.dart';
import 'package:studybuddy/screens/activity.dart';
import 'package:studybuddy/screens/add_tasks.dart';
import 'package:studybuddy/screens/home.dart';
import 'package:studybuddy/screens/profile.dart';

class AppBottomNavBar extends StatefulWidget {
  const AppBottomNavBar({super.key});

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  List<Widget> screens = const [
    HomeScreen(),
    ActivityScreen(),
    ProfileScreen(),
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskScreen(),
            ),
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
