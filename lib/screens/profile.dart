import 'package:flutter/material.dart';
import 'package:studybuddy/widgets/custom_container.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Profile"),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Edit",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 80,
                child: Text(
                  "Profile Picture",
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Firdaus",
                style: TextStyle(fontSize: 35),
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TaskCard(
                    title: "Pending Tasks",
                    description: "Next 7 Days",
                    body: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text("1/1"),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 150,
                          child: LinearProgressIndicator(
                            value: 10,
                            minHeight: 20,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Colors.blue,
                          ),
                        )
                      ],
                    ),
                  ),
                  TaskCard(
                    title: "Overdue Tasks",
                    description: "Total",
                    body: Column(
                      children: [
                        Text(
                          "0",
                          style: TextStyle(color: Colors.red, fontSize: 30),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "view",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TaskCard(
                      title: "Task Completed",
                      description: "Last 7 Days",
                      body: Text(
                        "0",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                    TaskCard(
                      title: "Your Streak",
                      description: "Days with no tasks",
                      body: Text(
                        "0",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
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
