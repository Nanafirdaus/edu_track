import 'package:flutter/material.dart';
import 'package:studybuddy/screens/user_data.dart';
import 'package:studybuddy/utils/extension.dart';
import 'package:studybuddy/utils/onboarding_pref.dart';

class GetStartedBtn extends StatefulWidget {
  const GetStartedBtn({super.key});

  @override
  State<GetStartedBtn> createState() => _GetStartedBtnState();
}

class _GetStartedBtnState extends State<GetStartedBtn> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.screenHeight * 0.01),
      child: Container(
        width: context.screenWidth * 0.9,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
              5,
            ),
          ),
          color: Color(0xff92E3A9),
        ),
        child: TextButton(
          onPressed: () {
            OnboardingPref.passOnboardingScreen();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const UserDataScreen(),
              ),
            );
          },
          child: const Text(
            "Get Started",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
