import 'dart:ui';

import 'package:app_2/components/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../components/create_routine_bottom_sheet.dart';
import '../components/image.const.dart';
import '../components/routine_tile.dart';
import '../models/routine.dart';
import '../services/routines_provider.dart';

class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void addRoutine(Routine r) {
      Provider.of<RoutineModel>(context, listen: false).add(r);
    }

    void editRoutine(Routine r) {
      Provider.of<RoutineModel>(context, listen: false).edit(r);
    }

    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () async {
      //     Routine? r = await showModalBottomSheet<Routine>(
      //         isScrollControlled: true,
      //         isDismissible: true,
      //         shape: const RoundedRectangleBorder(
      //           borderRadius: BorderRadius.vertical(
      //             top: Radius.circular(10),
      //             bottom: Radius.zero,
      //           ),
      //         ),
      //         context: context,
      //         builder: ((context) => const CreateRoutineBottomSheet()));

      //     if (r != null) {
      //       addRoutine(r);
      //     }
      //   },
      // ),
      body: Consumer<RoutineModel>(
        builder: ((context, value, child) {
          final Duration totalTime = value.todaysRoutines().fold(
              Duration.zero,
              (previousValue, element) =>
                  previousValue + element.getTimeLeft());
          return value.todaysRoutines().isEmpty && value.allRoutines().isEmpty
              ? Stack(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Positioned.fill(
                      child: SizedBox.fromSize(
                        size: MediaQuery.sizeOf(context),
                        child: Opacity(
                          opacity: .7,
                          child: Image.asset(
                            AppImages.bg2,
                            fit: BoxFit.cover,
                            height: MediaQuery.sizeOf(context).height,
                            width: MediaQuery.sizeOf(context).width,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        SafeArea(
                          child: Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    "Routines",
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .apply(
                                              displayColor: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface)
                                          .headlineLarge,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                    Routine? r = await showModalBottomSheet<
                                            Routine>(
                                        barrierColor:
                                            Colors.black.withOpacity(0.6),
                                        backgroundColor: Colors.white,
                                        isScrollControlled: true,
                                        isDismissible: true,
                                        // shape: const RoundedRectangleBorder(
                                        //   borderRadius: BorderRadius.vertical(
                                        //     top: Radius.circular(10),
                                        //     bottom: Radius.zero,
                                        //   ),
                                        // ),
                                        context: context,
                                        builder: ((context) =>
                                            const CreateRoutineBottomSheet()));

                                    if (r != null) {
                                      addRoutine(r);
                                    }
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Expanded(
                          flex: 10,
                          child: Center(
                            child: Text(
                              "Looks Empty! \n Try to add a routine",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .apply(
                                      displayColor: Theme.of(context)
                                          .colorScheme
                                          .onSurface)
                                  .headlineMedium,
                            ),
                          ),
                        ),
                      ],
                    )),
                  ],
                )
              : Stack(
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
                        child: ListView(
                      children: [
                        value.todaysRoutines().isEmpty
                            ? Container()
                            : Container(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 20),
                                              Text(
                                                "Today's Routines",
                                                style: GoogleFonts.lato(
                                                  fontWeight: FontWeight.bold,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .apply(
                                                          displayColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSurface)
                                                      .headlineMedium,
                                                ),
                                              ),
                                              Text(
                                                "${totalTime.inMinutes} mins left to reach your goal today ",
                                                style: GoogleFonts.lato(
                                                  fontWeight: FontWeight.w400,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .apply(
                                                          displayColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSurface)
                                                      .bodyLarge,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              Routine? r = await showModalBottomSheet<
                                                      Routine>(
                                                  isScrollControlled: true,
                                                  isDismissible: true,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      top: Radius.circular(10),
                                                      bottom: Radius.zero,
                                                    ),
                                                  ),
                                                  context: context,
                                                  builder: ((context) =>
                                                      const CreateRoutineBottomSheet()));

                                              if (r != null) {
                                                addRoutine(r);
                                              }
                                            },
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      ...value
                                          .todaysRoutines()
                                          .map((e) => RoutineTile(
                                                routine: e,
                                                isToday: true,
                                                onEdit: editRoutine,
                                              ))
                                    ]),
                              ),
                        value.allRoutines().isEmpty
                            ? Container()
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.4),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      value.routines
                                              .where(
                                                (element) =>
                                                    element.days.contains(
                                                  DateFormat('EEEE')
                                                      .format(DateTime.now()),
                                                ),
                                              )
                                              .isEmpty
                                          ? const SizedBox(height: 20)
                                          : Container(),
                                      Text(
                                        "All Routines",
                                        style: GoogleFonts.lato(
                                            fontWeight: FontWeight.bold,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .apply(
                                                    displayColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .onSurface)
                                                .headlineMedium),
                                      ),
                                      const SizedBox(height: 20),
                                      ...value
                                          .allRoutines()
                                          .map((e) => RoutineTile(
                                                routine: e,
                                                onEdit: editRoutine,
                                              ))
                                    ]),
                              )
                      ],
                    ))
                  ],
                );
        }),
      ),
    );
  }
}
