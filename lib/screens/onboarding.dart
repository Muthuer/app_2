import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});
  static const routeName = "/onBoarding";

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int _index = 0;
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFBBA5B).withOpacity(0.8), // Color 1
                  const Color(0xFF2C9BF3).withOpacity(0.4), // Color 2
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(4, 4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.6),
                    offset: const Offset(-4, -4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 10,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (value) => setState(() {
                        _index = value;
                      }),
                      children: [
                        const Page(
                          backgroundImage: 'assets/images/bg3.png',
                          title: "Koduko",
                          imagePath: 'assets/animation/person.json',
                          des:
                              "Welcome! This habit tracker is designed to help you efficiently manage your daily and weekly habits.",
                        ),
                        const Page(
                          backgroundImage: 'assets/images/bg1.png',
                          title: "You ask features?",
                          imagePath: 'assets/animation/gym.json',
                          des:
                              "It has a lot of them. You add a routine which can contain multiple tasks, select a time, and you're done. It will remind you at the specified time. Also, there are statistics.",
                        ),
                        const Page(
                          backgroundImage: 'assets/images/bg2.png',
                          title: "Ready?",
                          imagePath: 'assets/animation/watch.json',
                          des: "We hope you are! \n Have fun.",
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Buttons(
                        onSkip: () {
                          setState(() {
                            _index = 2;
                          });
                          _pageController.animateToPage(
                            2,
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 250),
                          );
                        },
                        pageIndex: _index,
                        onNext: () {
                          if (_index == 2) {
                            final box = Hive.box<bool>('Theme');
                            if (box.isOpen) {
                              box.put('isNewUser', false);
                            }
                            Navigator.pushReplacementNamed(context, '/');
                          }
                          if (_index > 1) {
                            return;
                          }
                          setState(() {
                            _index++;
                          });
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeIn,
                          );
                        },
                        onPrevious: () {
                          if (_index <= 0) {
                            return;
                          }
                          setState(() {
                            _index--;
                          });
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeIn,
                          );
                        },
                        text: _index == 2 ? 'Start' : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Page extends StatelessWidget {
  const Page(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.des,
      required this.backgroundImage});

  final String imagePath;
  final String title;
  final String backgroundImage;
  final String des;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: SizedBox.fromSize(
            size: MediaQuery.sizeOf(context),
            child: Opacity(
              opacity: 0.7,
              child: Image.asset(
                'assets/images/bg4.png', // Example asset
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: SizedBox.fromSize(
            size: MediaQuery.sizeOf(context),
            child: Opacity(
              opacity: 0.7,
              child: Image.asset(
                backgroundImage, // Example asset
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Lottie.asset(imagePath, width: 400, fit: BoxFit.cover),
              ),
              Text(
                title,
                style: GoogleFonts.catamaran(
                  fontWeight: FontWeight.bold,
                  textStyle: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  des,
                  style: GoogleFonts.raleway(
                    textStyle: Theme.of(context).textTheme.titleMedium,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({
    super.key,
    required this.pageIndex,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
    required this.text,
  });

  final int pageIndex;
  final void Function() onNext;
  final void Function() onPrevious;
  final void Function() onSkip;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedCrossFade(
            alignment: Alignment.center,
            firstChild: TextButton.icon(
              icon: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.black,
              ),
              label: const Text(
                'Back',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              onPressed: onPrevious,
            ),
            secondChild: GestureDetector(
              onTap: onSkip,
              child: Container(
                  width: 100,
                  // height: 50,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      'Skip',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )),
            ),
            crossFadeState: pageIndex == 0
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
          AnimatedCrossFade(
            alignment: Alignment.center,
            firstChild: TextButton.icon(
              label: text == null
                  ? const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.black,
                    )
                  : Container(),
              icon: const Text('Next',
                  style: TextStyle(color: Colors.black, fontSize: 15)),
              onPressed: onNext,
            ),
            secondChild: GestureDetector(
              onTap: onNext,
              child: Container(
                  width: 100,
                  // height: 50,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      text ?? 'Done',
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )),
            ),
            crossFadeState: text == null
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}
