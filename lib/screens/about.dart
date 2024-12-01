import 'package:app_2/components/image.const.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/header.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  static const routeName = "/about";

  @override
  Widget build(BuildContext context) {
    Future<void> openUrl(url) async {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      body: Stack(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Positioned.fill(
            child: SizedBox.expand(
              child: Opacity(
                opacity: .7,
                child: Image.asset(
                  AppImages.bg1,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
              child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const ScreenHeader(
                    text: "About",
                    tag: "About",
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                              text:
                                  "Welcome to Day Quest! This habit tracker is your ultimate companion for organizing and achieving your daily and weekly goals.With Day Quest, you can: Add routines that consist of multiple tasks.Schedule tasks at specific times and get timely reminders.Monitor your progress with detailed statistics and insights.Whether you're building new habits or staying consistent with existing ones, Day Quest helps you stay on track effortlessly. Start your journey to a more organized and productive life today! ",
                              style: Theme.of(context).textTheme.bodyLarge,
                              children: const [
                                // TextSpan(
                                //   text: "here",
                                //   recognizer: TapGestureRecognizer()
                                //     ..onTap = () => openUrl(Uri.parse(
                                //         'https://github.com/Mazahir26/koduko')),
                                //   style: Theme.of(context)
                                //       .textTheme
                                //       .bodyLarge!
                                //       .copyWith(
                                //         color: Theme.of(context).colorScheme.primary,
                                //       ),
                                // )
                              ]),
                        ),
                        // const SizedBox(height: 15),
                        // Text(
                        //   'Developer Contact',
                        //   style: Theme.of(context)
                        //       .textTheme
                        //       .headlineMedium!
                        //       .copyWith(fontWeight: FontWeight.bold),
                        // ),
                        // const SizedBox(height: 10),
                        // Text(
                        //   "For any questions or suggestions regarding Koduko's functionality or code, You can reach me out via telegram or github",
                        //   style: Theme.of(context).textTheme.bodyLarge,
                        // ),
                        // const SizedBox(height: 10),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     TextButton(
                        //         onPressed: () {
                        //           openUrl(Uri.parse('https://github.com/Mazahir26'));
                        //         },
                        //         child: const Text("GitHub")),
                        //     TextButton(
                        //         onPressed: () {
                        //           openUrl(Uri.parse('https://t.me/mazahir26'));
                        //         },
                        //         child: const Text("Telegram"))
                        //   ],
                        // ),
                        // const SizedBox(height: 30),
                        // Center(
                        //   child: Text(
                        //     "Thank You ❤️",
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .headlineMedium!
                        //         .copyWith(fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
