import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:studybuddy/provider/model/onboarding_items.dart';
import 'package:studybuddy/utils/extension.dart';
import 'package:studybuddy/widgets/get_started_btn.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController pageController = PageController();
  final onboardingItems = OnboardingItems();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
           isLastPage ? const SizedBox() : Row(
              children: [
                TextButton(
                  onPressed: () {
                    pageController.jumpToPage(onboardingItems.items.length - 1);
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        bottomSheet: isLastPage
            ? const GetStartedBtn()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SmoothPageIndicator(
                      controller: pageController,
                      count: onboardingItems.items.length,
                      effect: WormEffect(
                        dotHeight: context.screenHeight * 0.015,
                        dotWidth: context.screenHeight * 0.015,
                        activeDotColor: const Color(0xff92E3A9),
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
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: PageView.builder(
            onPageChanged: (value) => setState(() {
              isLastPage = onboardingItems.items.length - 1 == value;
            }),
            itemCount: onboardingItems.items.length,
            controller: pageController,
            itemBuilder: (context, value) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(onboardingItems.items[value].image),
                  SizedBox(
                    height: context.screenHeight * 0.05,
                  ),
                  Text(
                    onboardingItems.items[value].title,
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
                      onboardingItems.items[value].description,
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
