import 'package:flutter/material.dart';
import 'package:studybuddy/screens/user_data2.dart';
import 'package:studybuddy/utils/extension.dart';
import 'package:studybuddy/widgets/custom_textfield.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key});

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  final levels = ["Level 1", "Level 2", "Level 3", "Level 4", "Level 5"];
  late String selectedItem;
  TextEditingController nameController = TextEditingController();
  TextEditingController deptController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() => selectedItem = levels[0]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              width: context.screenWidth,
              height: context.screenHeight * 0.2,
              child: const Center(
                child: Text(
                  "Input your Details",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 45,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFieldWidget(
                    textEditingController: nameController,
                    prefixIcon: const Icon(
                      Icons.person,
                      size: 18,
                    ),
                    hintText: "Enter John Doe",
                    label: "Name",
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFieldWidget(
                    textEditingController: deptController,
                    prefixIcon: const Icon(
                      Icons.place_rounded,
                      size: 18,
                    ),
                    hintText: "E.g Information Technology",
                    label: "Department",
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: context.screenWidth,
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        value: selectedItem,
                        items: levels.map((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(item),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedItem = value!;
                          });
                        },
                        icon: const Icon(Icons.arrow_drop_down),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                15,
                              ),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff92E3A9),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: context.screenWidth,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserDataScreen2(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor:const Color(0xff92E3A9),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
