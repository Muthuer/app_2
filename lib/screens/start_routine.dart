import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../components/card.dart';
import '../components/image.const.dart';
import '../models/task.dart';
import '../services/notification_service.dart';
import '../services/routines_provider.dart';
import '../services/theme_provider.dart';
import '../utils/colors_util.dart';
import '../utils/parse_duration.dart';

class RoutineScreen extends StatefulWidget {
  final String routine;
  const RoutineScreen({super.key, required this.routine});

  @override
  State<RoutineScreen> createState() => RoutineScreenState();
}

class RoutineScreenState extends State<RoutineScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _buttonController;

  bool _isPlaying = false;
  bool _isComplete = false;
  bool _isSkipped = false;

  DateTime _playedOn = DateTime.now();

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(minutes: 1));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var routine = Provider.of<RoutineModel>(context, listen: false)
          .getRoutine(widget.routine);
      if (routine == null) {
        return;
      }
      if (routine.isCompleted) {
        Provider.of<RoutineModel>(context, listen: false).replay(routine.id);
        _controller.duration = parseDuration(
          Provider.of<RoutineModel>(context, listen: false)
              .getRoutine(routine.id)!
              .tasks
              .first
              .duration,
        );
      } else {
        _controller.duration = parseDuration(
          Provider.of<RoutineModel>(context, listen: false)
              .getRoutine(routine.id)!
              .inCompletedTasks
              .first
              .duration,
        );
      }
      setState(() {
        _isPlaying = false;
      });
    });

    _buttonController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _controller.addListener(() {
      if (_controller.status == AnimationStatus.forward) {
        final diff = DateTime.now().difference(_playedOn);

        //Check if the difference is more that 100 milliseconds
        if ((diff - (_controller.duration! * _controller.value))
                .abs()
                .inMilliseconds >
            100) {
          _controller.forward(
              from: (diff.inMilliseconds / _controller.duration!.inMilliseconds)
                  .clamp(0, 1));
        }
      }
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        NotificationService().cancelNotificationWithId(777);
        setState(() {
          _isComplete = true;
        });
      }
    });
    super.initState();
  }

  void onTap(TapUpDetails? _) async {
    final task = Provider.of<RoutineModel>(context, listen: false)
        .getRoutine(widget.routine)!
        .inCompletedTasks
        .first;
    if (_isPlaying) {
      setState(() {
        _isPlaying = false;
      });

      NotificationService().cancelNotification(task.id + widget.routine);

      _controller.stop();
      _buttonController.reverse();
    } else {
      Duration d = (_controller.duration! * _controller.value);
      setState(() {
        _playedOn = DateTime.now().subtract(d);
        _isPlaying = true;
      });
      NotificationService().scheduledNotification((_controller.duration! - d),
          task.id + widget.routine, task.name, 'Completed!');
      _controller.forward();
      _buttonController.forward();
    }
  }

  void onDismiss(DismissDirection t, BuildContext context) {
    final task = Provider.of<RoutineModel>(context, listen: false)
        .getRoutine(widget.routine)!
        .inCompletedTasks
        .first;
    NotificationService().cancelNotification(task.id + widget.routine);
    if (t == DismissDirection.endToStart) {
      Provider.of<RoutineModel>(context, listen: false)
          .skipTask(widget.routine);
      setState(() {
        _controller.reset();
        if (_isSkipped) {
          _isSkipped = false;
          if (_isPlaying) {
            _isPlaying = false;
            _buttonController.reverse();
          }
        }
      });
      var ts = Provider.of<RoutineModel>(context, listen: false)
          .getRoutine(widget.routine)!
          .inCompletedTasks;
      if (ts.isNotEmpty) {
        _controller.duration = parseDuration(ts.first.duration);
      }
    } else if (t == DismissDirection.startToEnd) {
      Provider.of<RoutineModel>(context, listen: false)
          .completeTask(widget.routine);
      _controller.reset();
      setState(() {
        if (_isPlaying) {
          _isPlaying = false;
          _buttonController.reverse();
        }
        if (_isComplete) {
          _isComplete = false;
          _playedOn = DateTime.now();
        }
      });
      var ts = Provider.of<RoutineModel>(context, listen: false)
          .getRoutine(widget.routine)!
          .inCompletedTasks;
      if (ts.isNotEmpty) {
        _controller.duration = parseDuration(ts.first.duration);
      }
    }
  }

  @override
  void dispose() {
    NotificationService().cancelNotificationWithId(777);
    _controller.dispose();
    _buttonController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
      ),
      child: Scaffold(
        body: Selector<RoutineModel, List<Task>>(
          selector: (p0, p1) => p1.getRoutine(widget.routine)!.inCompletedTasks,
          builder: ((context, value, child) => Stack(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignment: MainAxisAlignment.center,
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
                      top: 0,
                      left: 0,
                      child: SafeArea(
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: IconButton(
                                onPressed: () {
                                  if (Provider.of<RoutineModel>(context,
                                          listen: false)
                                      .getRoutine(widget.routine)!
                                      .inCompletedTasks
                                      .isNotEmpty) {
                                    final task = Provider.of<RoutineModel>(
                                            context,
                                            listen: false)
                                        .getRoutine(widget.routine)!
                                        .inCompletedTasks
                                        .first;
                                    NotificationService().cancelNotification(
                                        task.id + widget.routine);
                                  }

                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 20,
                                ),
                              ),
                            ),
                            Selector<RoutineModel, String>(
                              selector: (p0, p1) =>
                                  p1.getRoutine(widget.routine)!.name,
                              builder: (context, value, child) => Hero(
                                tag: value,
                                child: Text(
                                  value,
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
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment
                          .center, // Center the widget in the parent Stack
                      child: SizedBox(
                        height: 300,
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Center(
                              child: Text(
                                "Good Work",
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .apply(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .color,
                                      ),
                                ),
                              ),
                            ),
                            ...value
                                .asMap()
                                .entries
                                .map(
                                  (e) => Consumer<ThemeModel>(
                                    builder: (context, themeData, child) {
                                      bool isSwipeDis = false;
                                      if (e.key == 0) {
                                        int count = 0;
                                        for (var element in value) {
                                          if (element.id == e.value.id) {
                                            count++;
                                          }
                                        }
                                        if (count == value.length) {
                                          isSwipeDis = true;
                                        }
                                      }
                                      if (value.length == 0) {
                                        print("muthu");
                                      }

                                      return TaskCard(
                                        isSwipeDisabled:
                                            value.length == 1 || isSwipeDis,
                                        isSkipped: _isSkipped,
                                        isCompleted: _isComplete,
                                        buttonController: _buttonController,
                                        isPlaying: _isPlaying,
                                        onTap: onTap,
                                        name: e.value.name,
                                        controller:
                                            e.key == 0 ? _controller : null,
                                        color: themeData.isDark()
                                            ? darken(Color(e.value.color))
                                            : Color(e.value.color),
                                        index: (e.key) * 1.0,
                                        onDismissed: onDismiss,
                                      );
                                    },
                                  ),
                                )
                                .toList()
                                .reversed,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                      child: SafeArea(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 350),
                          tween: Tween(begin: 0, end: value.isEmpty ? 300 : 0),
                          curve: Curves.easeInCirc,
                          builder: ((context, double value, child) =>
                              Transform.translate(
                                offset: Offset(0, value),
                                child: IntrinsicHeight(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 13, horizontal: 25),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(90)),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _isSkipped = true;
                                              });
                                            },
                                            child: const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Icon(
                                                  Icons.swipe_left_rounded,
                                                  color: Colors.blue,
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  "Skip",
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            onTap(null);
                                          },
                                          // style: ButtonStyle(
                                          //   backgroundColor:
                                          //       WidgetStatePropertyAll(Colors
                                          //           .black
                                          //           .withOpacity(0.4)),
                                          //   elevation:
                                          //       WidgetStateProperty.all<double>(
                                          //           6),
                                          //   shape: WidgetStateProperty.all(
                                          //       const CircleBorder()),
                                          //   padding: WidgetStateProperty.all(
                                          //       const EdgeInsets.all(15)),
                                          // ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 13, horizontal: 14),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(90)),
                                            child: AnimatedIcon(
                                              icon: AnimatedIcons.play_pause,
                                              progress: _buttonController,
                                              // color: Theme.of(context)
                                              //     .colorScheme
                                              //     .primary,
                                              color: Colors.black,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isComplete = true;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 13, horizontal: 21),
                                            decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                                borderRadius:
                                                    BorderRadius.circular(90)),
                                            child: const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Icon(
                                                  Icons.swipe_right_rounded,
                                                  color: Colors.green,
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  "Done",
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ))),
                    ),
                  ))
                ],
              )),
        ),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget {
  const MyAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leadingWidth: 80,
      leading: Center(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).primaryIconTheme.color!, width: 1),
              borderRadius: BorderRadius.circular(90)),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: Theme.of(context).primaryIconTheme.color,
            iconSize: 30,
          ),
        ),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }
}
