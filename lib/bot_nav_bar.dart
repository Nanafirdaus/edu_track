import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
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
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      floatingActionButton: currentIndex == 1
          ? FloatingActionButton(
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
                Iconsax.add_copy,
                size: 30,
              ),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (newIndex) {
          setState(() {
            currentIndex = newIndex;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(
              currentIndex == 0 ? Iconsax.home : Iconsax.home_copy,
            ),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(
              currentIndex == 1 ? Iconsax.activity : Iconsax.activity_copy,
            ),
            label: "Activity",
          ),
          NavigationDestination(
            icon: Icon(
              currentIndex == 2
                  ? Iconsax.profile_circle
                  : Iconsax.profile_circle_copy,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
