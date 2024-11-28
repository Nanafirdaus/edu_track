import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:studybuddy/model/onboarding_items.dart';
import 'package:studybuddy/utils/extension.dart';
import 'package:studybuddy/widgets/get_started_btn.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController pageController = PageController();
  final controller = OnboardingItems();

  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomSheet: isLastPage
            ? const GetStartedBtn()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SmoothPageIndicator(
                    controller: pageController,
                    count: controller.items.length,
                    effect: WormEffect(
                      dotHeight: context.screenHeight * 0.015,
                      dotWidth: context.screenHeight * 0.015,
                      activeDotColor: Colors.green,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: PageView.builder(
            onPageChanged: (value) => setState(() {
              isLastPage = controller.items.length - 1 == value;
            }),
            itemCount: controller.items.length,
            controller: pageController,
            itemBuilder: (context, value) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(controller.items[value].image),
                  SizedBox(
                    height: context.screenHeight * 0.05,
                  ),
                  Text(
                    controller.items[value].title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: context.screenHeight * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      controller.items[value].description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
