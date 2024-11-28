import 'package:flutter/material.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key});

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  final levels = ["Level 1", "Level 2", "Level 3", "Level 4", "Level 5"];
  String? selectedItem = "Level 1";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your name",
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your department",
                ),
              ),
              DropdownButtonFormField(
                value: selectedItem,
                items: levels.map((String item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedItem = value;
                  });
                },
                icon: const Icon(Icons.arrow_drop_down),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
