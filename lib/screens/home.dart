import 'dart:ui';

import 'package:app_2/components/app_colors.dart';
import 'package:app_2/components/image.const.dart';
import 'package:app_2/services/routines_provider.dart';
import 'package:app_2/utils/greetings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../components/weekly_chart.dart';
import '../models/routine.dart';
import 'start_routine.dart';
import 'stats.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onTapChange});
  final void Function() onTapChange;
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
        //! Bottom
        Positioned(
            right: 10.w,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width -
                  (10.w * 2) -
                  5.w -
                  (14.w * 2) -
                  5.w,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: 460.w + 20.w,
                    bottom: MediaQuery.paddingOf(context).bottom + 20.w,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Today's Routines",
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          textStyle: textTheme.headlineMedium,
                        ),
                      ),
                      Consumer<RoutineModel>(
                        builder: (context, value, child) {
                          List<Routine> todayRoutines = value.todaysRoutines();
                          final Duration totalTime =
                              value.todaysRoutines().fold(
                                    Duration.zero,
                                    (previousValue, element) =>
                                        previousValue + element.getTimeLeft(),
                                  );
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${totalTime.inMinutes} mins left to reach your goal today",
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w400,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .apply(
                                          displayColor: Theme.of(context)
                                              .colorScheme
                                              .onSurface)
                                      .bodyLarge,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Column(
                                children: todayRoutines.isEmpty
                                    ? [
                                        const SizedBox(height: 50),
                                        Center(
                                          child: Text(
                                            "You seem free today!",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall,
                                          ),
                                        ),
                                        Center(
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                            onPressed: onTapChange,
                                            child: const Text("Change that?"),
                                          ),
                                        ),
                                      ]
                                    : todayRoutines
                                        .asMap()
                                        .map(
                                          (key, value) => MapEntry(
                                            key,
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    '${key + 1}',
                                                    style: GoogleFonts.lato(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      textStyle: textTheme
                                                          .headlineLarge,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 10,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(.4),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 5,
                                                    ),
                                                    child: ListTile(
                                                      title: Text(
                                                        value.name,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge,
                                                      ),
                                                      subtitle: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 3,
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            value.inCompletedTasks
                                                                    .isEmpty
                                                                ? const Text(
                                                                    "Completed")
                                                                : Text(
                                                                    'Completed ${value.tasks.length - value.inCompletedTasks.length} out of ${value.tasks.length}',
                                                                  ),
                                                            const SizedBox(
                                                                height: 5),
                                                            LinearPercentIndicator(
                                                              backgroundColor:
                                                                  Colors.pink[
                                                                      100],
                                                              animateFromLastPercent:
                                                                  true,
                                                              animation: true,
                                                              percent: value
                                                                  .getPercentage()
                                                                  .clamp(0, 1),
                                                              barRadius:
                                                                  const Radius
                                                                      .circular(
                                                                      10),
                                                              lineHeight: 3,
                                                              progressColor:
                                                                  Colors.green[
                                                                      400],
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      trailing: IconButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  ((context) =>
                                                                      RoutineScreen(
                                                                        routine:
                                                                            value.id,
                                                                      )),
                                                            ),
                                                          );
                                                        },
                                                        icon: Icon(
                                                          value.isCompleted
                                                              ? Icons
                                                                  .replay_rounded
                                                              : Icons
                                                                  .play_arrow_rounded,
                                                          size: 30,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .values
                                        .toList(),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )),
        //! Top
        Positioned(
            left: 0,
            right: 0,
            height: 460.w,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.background.withOpacity(.4),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      SafeArea(
                          left: false,
                          right: false,
                          bottom: false,
                          child: Header(textTheme: textTheme)),
                      const SizedBox(height: 20),
                      Hero(
                        tag: 'WeeklyChart',
                        child: WeeklyChart(textTheme: textTheme),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, Statistics.routeName),
                            child: Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.7),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(width: 10.w),
                                  const Text("More Stats"),
                                  SizedBox(width: 4.w),
                                  Icon(Icons.chevron_right_rounded),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Good ${greeting()} 👋',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            textStyle: textTheme.headlineLarge,
          ),
        ),
        Text(
          DateFormat.MMMMEEEEd().format(DateTime.now()),
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w400,
            textStyle: Theme.of(context).textTheme.titleLarge!.apply(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
          ),
        ),
      ],
    );
  }
}
