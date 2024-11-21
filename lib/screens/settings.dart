import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../components/app_colors.dart';
import '../components/image.const.dart';
import '../services/routines_provider.dart';
import '../services/theme_provider.dart';
import 'about.dart';
import 'archive_routines.dart';
import 'stats.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Stack(
      children: [
        Positioned.fill(
          child: SizedBox.fromSize(
            size: MediaQuery.sizeOf(context),
            child: Opacity(
              opacity: .7,
              child: Image.asset(
                AppImages.bg1,
                fit: BoxFit.cover,
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
              ),
            ),
          ),
        ),
        Positioned(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                    "Settings",
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      textStyle: Theme.of(context)
                          .textTheme
                          .apply(
                              displayColor:
                                  Theme.of(context).colorScheme.onSurface)
                          .headlineLarge,
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(
                      context, ArchiveRoutinesScreen.routeName),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Hero(
                          tag: "Archived",
                          child: Text(
                            "Archived",
                            style: textTheme.titleLarge,
                          ),
                        ),
                        GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, ArchiveRoutinesScreen.routeName),
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.7),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.black,
                                ))),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, Statistics.routeName),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Hero(
                          tag: "Statistics",
                          child: Text(
                            "Statistics",
                            style: textTheme.titleLarge,
                          ),
                        ),
                        GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, Statistics.routeName),
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.7),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.black,
                                ))),
                      ],
                    ),
                  ),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white.withOpacity(.6),
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              //   child: InkWell(
              //     onTap: () {
              //       Provider.of<ThemeModel>(context, listen: false)
              //           .toggleTheme();
              //     },
              //     child: Padding(
              //       padding: const EdgeInsets.all(15.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             "Dark Mode",
              //             style: textTheme.titleLarge,
              //           ),
              //           Consumer<ThemeModel>(
              //             builder: (context, value, child) => TextButton.icon(
              //                 label: value.getTheme == ThemeMode.system
              //                     ? const Text("System")
              //                     : value.getTheme == ThemeMode.dark
              //                         ? const Text("Dark")
              //                         : const Text("Light"),
              //                 onPressed: () {
              //                   Provider.of<ThemeModel>(context, listen: false)
              //                       .toggleTheme();
              //                 },
              //                 icon: value.getTheme == ThemeMode.system
              //                     ? const Icon(Icons.settings)
              //                     : value.getTheme == ThemeMode.dark
              //                         ? const Icon(Icons.dark_mode_rounded)
              //                         : const Icon(Icons.light_mode_rounded)),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: InkWell(
                  onTap: () {
                    Provider.of<RoutineModel>(context, listen: false)
                        .toggleNotifications();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Notifications ",
                          style: textTheme.titleLarge,
                        ),
                        Selector<RoutineModel, bool>(
                            selector: (p0, p1) => p1.notifications,
                            builder: (context, value, child) => GestureDetector(
                                  onTap: () {
                                    Provider.of<RoutineModel>(context,
                                            listen: false)
                                        .toggleNotifications();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(.7),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      children: [
                                        value
                                            ? const Icon(
                                                color: Colors.black,
                                                CupertinoIcons.bell_solid,
                                                size: 25,
                                              )
                                            : const Icon(
                                                color: Colors.black,
                                                CupertinoIcons.bell_slash_fill,
                                                size: 25,
                                              ),
                                        // const SizedBox(
                                        //   width: 10,
                                        // ),
                                        // value
                                        //     ? Text("On",
                                        //         style: TextStyle(
                                        //           fontSize: 15.sp,
                                        //           fontWeight: FontWeight.w400,
                                        //           color: AppColors.black,
                                        //         ))
                                        //     : Text("Off",
                                        //         style: TextStyle(
                                        //           fontSize: 15.sp,
                                        //           fontWeight: FontWeight.w400,
                                        //           color: AppColors.black,
                                        //         )),
                                        // const SizedBox(
                                        //   width: 5,
                                        // ),
                                      ],
                                    ),
                                  ),
                                )
                            // TextButton.icon(
                            //   label: value ? const Text("ON") : const Text("OFF"),
                            //   onPressed: () {
                            //     Provider.of<RoutineModel>(context, listen: false)
                            //         .toggleNotifications();
                            //   },
                            //   icon: value
                            //       ? const Icon(Icons.notifications_active_rounded)
                            //       : const Icon(Icons.notifications_off_rounded),
                            // ),
                            )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, AboutScreen.routeName),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "About ",
                          style: textTheme.titleLarge,
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.7),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            color: Colors.black,
                            CupertinoIcons.person_crop_circle,
                            size: 30,
                          ),
                        )
                        // IconButton(
                        //     onPressed: () => Navigator.pushNamed(
                        //         context, AboutScreen.routeName),
                        //     icon: const Icon(Icons.person)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: Text(
                  "Version: 1.0.0",
                  style: textTheme.labelMedium!.apply(
                      color: textTheme.labelMedium!.color!.withOpacity(0.5)),
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  "Powered by Pearl with ❤️",
                  style: textTheme.labelMedium!.apply(
                      color: textTheme.labelMedium!.color!.withOpacity(0.5)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ))
      ],
    );
  }
}
