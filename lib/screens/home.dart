import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Good Afternoon!",
                  style: TextStyle(fontSize: 18),
                ),
                const Text(
                  "FIRDAUS",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Sat, 16 Nov",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      height: 30,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        color: Colors.blue[100],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      height: 30,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        color: Colors.blue[100],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      height: 30,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        color: Colors.blue[100],
                      ),
                      child: const Center(
                        child: Text(
                          "0 Classes",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Text.rich(
                  TextSpan(
                    text: "No classes, tasks or exams left for today",
                    children: [TextSpan()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
