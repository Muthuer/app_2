import 'dart:ui';

import 'package:app_2/utils/duration_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../models/routine.dart';
import '../models/task.dart';
import '../screens/tasks.dart';
import '../services/tasks_provider.dart';
import '../utils/parse_duration.dart';
import '../utils/time_of_day_util.dart';
import 'name_page_bottom_sheet.dart';

enum RepeatType {
  daily,
  onlyOn,
}

class CreateRoutineBottomSheet extends StatefulWidget {
  const CreateRoutineBottomSheet({
    super.key,
    this.editRoutine,
  });
  final Routine? editRoutine;

  @override
  State<CreateRoutineBottomSheet> createState() =>
      _CreateRoutineBottomSheetState();
}

class _CreateRoutineBottomSheetState extends State<CreateRoutineBottomSheet> {
  late final PageController _pageController;
  late final TextEditingController _nameController;

  final List<Task> selectedTask = [];
  Map<String, bool> selectedDays = {
    "Monday": true,
    "Tuesday": true,
    "Wednesday": true,
    "Thursday": true,
    "Friday": true,
    "Saturday": true,
    "Sunday": true,
  };
  int pageIndex = 0;
  bool pageComplected = false;
  bool notifications = true;
  TimeOfDay? time =
      TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);
  @override
  void initState() {
    _pageController = PageController();
    _nameController = TextEditingController();

    if (widget.editRoutine != null) {
      _nameController.text = widget.editRoutine!.name;
      selectedDays = selectedDays.map((key, value) =>
          MapEntry(key, widget.editRoutine!.days.contains(key)));

      for (var element in widget.editRoutine!.tasks) {
        selectedTask.add(element);
      }
      if (widget.editRoutine!.time != null) {
        time = dateTimeToTimeOfDay(widget.editRoutine!.time!);
      } else {
        notifications = false;
        time = TimeOfDay(
            hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);
      }
      pageComplected = true;
    }
    super.initState();
  }

  void validateName(String _) {
    if (_nameController.text.length > 2) {
      if (!pageComplected) {
        setState(() {
          pageComplected = true;
        });
      }
    } else if (pageComplected) {
      setState(() {
        pageComplected = false;
      });
    }
  }

  void onChangeRepeatType(RepeatType r) {
    if (r == RepeatType.daily) {
      setState(() {
        selectedDays = selectedDays.map((key, value) => MapEntry(key, true));
        pageComplected = true;
      });
    } else {
      setState(() {
        pageComplected = false;
        selectedDays = selectedDays.map((key, value) => MapEntry(key, false));
      });
    }
  }

  void onDayChange(String e, bool value) {
    setState(() {
      selectedDays[e] = value;
      if (selectedDays.values.contains(true)) {
        pageComplected = true;
      } else {
        pageComplected = false;
      }
    });
  }

  // void onTap(bool selected, int index, BuildContext context) {
  //   if (selected) {
  //     if (selectedTask.length == 1) {
  //       setState(() {
  //         selectedTask.removeWhere((element) =>
  //             element.id ==
  //             Provider.of<TaskModel>(context, listen: false).tasks[index].id);
  //         pageComplected = false;
  //       });
  //     } else {
  //       setState(() {
  //         selectedTask.removeWhere((element) =>
  //             element.id ==
  //             Provider.of<TaskModel>(context, listen: false).tasks[index].id);
  //       });
  //     }
  //   } else {
  //     setState(() {
  //       selectedTask
  //           .add(Provider.of<TaskModel>(context, listen: false).tasks[index]);
  //       pageComplected = true;
  //     });
  //   }
  // }
  void onAdd(Task t) {
    setState(() {
      selectedTask.add(t);
      pageComplected = true;
    });
  }

  void onRemove(int index) {
    if (selectedTask.length == 1) {
      setState(() {
        selectedTask.removeAt(index);
        pageComplected = false;
      });
      return;
    }
    setState(() {
      selectedTask.removeAt(index);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.transparent,
      padding: EdgeInsets.only(
          top: 10,
          right: 10,
          left: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10),
      child: Wrap(
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 40.w,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  width: 30.w,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("Create a Routine",
                    // style: Theme.of(context).textTheme.headlineSmall,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 32.sp,
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 250),
              tween: Tween<double>(
                  begin: 0.25,
                  end: pageIndex == 1
                      ? 0.7
                      : pageIndex == 0
                          ? 0.25
                          : 0.4),
              builder: (context, value, child) => SizedBox(
                height: MediaQuery.of(context).size.height * value,
                child: child,
              ),
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  NamePage(
                    nameController: _nameController,
                    validateName: validateName,
                    pageComplected: pageComplected,
                    hintText: "ex. Gym",
                    title: "Routine Name",
                  ),
                  TaskSelectPage(
                    onChangeOrder: (oldIndex, newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final item = selectedTask.removeAt(oldIndex);
                        selectedTask.insert(newIndex, item);
                      });
                    },
                    onTapDelete: onRemove,
                    selectedTask: selectedTask,
                    onTapAdd: onAdd,
                  ),
                  RepeatPage(
                    notification: notifications,
                    onChangeTime: ((t) => setState(() {
                          time = t;
                        })),
                    onToggleNotification: () => setState(() {
                      notifications = !notifications;
                    }),
                    time: time,
                    onDayChange: onDayChange,
                    selectedDays: selectedDays,
                    onChangeRepeatType: onChangeRepeatType,
                  )
                ],
              ),
            ),
          ),
          SafeArea(
            child: Buttons(
                text: pageIndex == 2 ? "Done" : null,
                pageIndex: pageIndex,
                onPrevious: () {
                  setState(() {
                    pageIndex--;
                  });
                  if (pageIndex == 0) {
                    validateName("");
                  }
                  if (pageIndex == 1) {
                    setState(() {
                      pageComplected = selectedTask.isNotEmpty;
                    });
                  }

                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeIn,
                  );
                },
                onNext: pageComplected
                    ? () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        if (pageIndex == 2) {
                          List<String> temp = [];
                          selectedDays.forEach((key, value) {
                            if (value) {
                              temp.add(key);
                            }
                          });
                          if (widget.editRoutine != null) {
                            List<Task> diff = Routine.taskDiff(
                                widget.editRoutine!.tasks, selectedTask);

                            if (selectedTask.length >
                                widget.editRoutine!.tasks.length) {
                              diff.addAll(widget.editRoutine!.inCompletedTasks);
                            } else {
                              diff = Routine.taskDiff(
                                  diff, widget.editRoutine!.inCompletedTasks);
                            }
                            return Navigator.pop(
                                context,
                                widget.editRoutine!.copyWith(
                                  tasks: selectedTask,
                                  name: _nameController.text,
                                  days: temp,
                                  time: notifications ? time : null,
                                  inCompletedTasks: diff,
                                  isCompleted: diff.isEmpty,
                                ));
                          } else {
                            return Navigator.pop(
                              context,
                              Routine.create(
                                name: _nameController.text,
                                tasks: selectedTask,
                                days: temp,
                                time: notifications
                                    ? timeOfDayToDateTime(time)
                                    : null,
                              ),
                            );
                          }
                        }

                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeIn,
                        );
                        if (pageIndex == 0) {
                          if (selectedTask.isEmpty) {
                            setState(() {
                              pageIndex++;
                              pageComplected = false;
                            });
                            return;
                          }
                        }
                        if (pageIndex == 1) {
                          if (!selectedDays.values.contains(true)) {
                            setState(() {
                              pageComplected = false;
                              pageIndex++;
                            });
                            return;
                          }
                        }
                        setState(() {
                          pageIndex++;
                        });
                      }
                    : null),
          )
        ],
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({
    super.key,
    required this.pageIndex,
    required this.onNext,
    required this.onPrevious,
    required this.text,
  });

  final int pageIndex;
  final void Function()? onNext;
  final void Function() onPrevious;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: pageIndex != 0
              ? GestureDetector(
                  onTap: onPrevious,
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.chevron_left_sharp),
                        Text(
                          "Back",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                )
              // ? ElevatedButton.icon(
              //     style: ElevatedButton.styleFrom(
              //       foregroundColor:
              //           Theme.of(context).colorScheme.onSecondaryContainer,
              //       backgroundColor:
              //           Theme.of(context).colorScheme.secondaryContainer,
              //     ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
              //     onPressed: onPrevious,
              //     icon: const Icon(Icons.chevron_left_sharp),
              //     label: Text(
              //       "Back",
              //       style: Theme.of(context).textTheme.bodyLarge,
              //     ),
              //   )
              : GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.pink.shade100)),
                    child: Center(
                      child: Text("Cancel",
                          style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  ),
                ),
        ),
        const Spacer(
          flex: 2,
        ),
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: onNext,
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text ?? "Next",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  text == null
                      ? const Icon(Icons.chevron_right_sharp)
                      : Container()
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class TaskSelectPage extends StatelessWidget {
  const TaskSelectPage({
    super.key,
    required this.selectedTask,
    required this.onTapAdd,
    required this.onTapDelete,
    required this.onChangeOrder,
  });
  final List<Task> selectedTask;
  final void Function(Task task) onTapAdd;
  final void Function(int index) onTapDelete;
  final void Function(int oldIndex, int newIndex) onChangeOrder;
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(builder: ((context, value, child) {
      if (value.tasks.isEmpty) {
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Looks like you haven't created any tasks",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      TasksScreen.routeName,
                    );
                  },
                  child: const Text(
                    "Create One",
                    style: TextStyle(fontSize: 18),
                  ))
            ],
          ),
        );
      }

      return ReorderableListView(
        header: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Tasks',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.grey.shade600,
                  ),
                  // style: Theme.of(context)
                  //     .textTheme
                  //     .headlineMedium!
                  //     .apply(color: Theme.of(context).colorScheme.onSurface)
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(
                      context,
                      TasksScreen.routeName,
                    );
                  },
                  child: Container(
                    height: 50,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.pink.shade100),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_rounded,
                          color: Colors.pink[200],
                        ),
                        Text(
                          'Edit Tasks',
                          style: Theme.of(context).textTheme.titleMedium!.apply(
                                color: Colors.pink[200],
                                // Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                )
                // TextButton.icon(
                //   onPressed: (() {
                //     Navigator.pushNamed(
                //       context,
                //       TasksScreen.routeName,
                //     );
                //   }),
                //   icon: Icon(
                //     Icons.edit_rounded,
                //     color: Colors.pink[200],
                //   ),
                //   label: Text(
                //     'Edit Tasks',
                //     style: Theme.of(context).textTheme.titleMedium!.apply(
                //           color: Colors.pink[200],
                //           // Theme.of(context).colorScheme.primary,
                //         ),
                //   ),
                // )
              ],
            ),
            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Selected Tasks',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.grey.shade600,
                  ),
                  // style: Theme.of(context).textTheme.titleLarge!
                ),
                Text(
                  'Selected (${selectedTask.length})',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .apply(color: Colors.pink[200]
                          //  Theme.of(context).colorScheme.primary
                          ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
        footer: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text('Tasks', style: Theme.of(context).textTheme.titleLarge!),
            const SizedBox(height: 10),
            if (value.tasks.isEmpty)
              Column(
                children: [
                  const SizedBox(height: 15),
                  Center(
                    child: Text('Looks Empty! ',
                        style: Theme.of(context).textTheme.titleMedium!),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          TasksScreen.routeName,
                        );
                      },
                      child: const Text("Add a Task?"))
                ],
              )
            else
              ...value.tasks
                  .asMap()
                  .map((key, value) => MapEntry(
                      key,
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.pink[50],
                            border: Border.all(color: Colors.pink.shade100),
                            borderRadius: BorderRadius.circular(15)),
                        key: Key('$key+${value.id}'),
                        child: ListTile(
                            trailing: TextButton.icon(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                              label: const Text(
                                "ADD",
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () => onTapAdd(value),
                            ),
                            subtitle: Text(
                              'Duration : ${durationToString(parseDuration(value.duration))} Min',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .apply(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.8)),
                            ),
                            title: Text(
                              value.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            )),
                      )))
                  .values
          ],
        ),
        onReorder: onChangeOrder,
        buildDefaultDragHandles: false,
        children: [
          if (selectedTask.isEmpty)
            Padding(
              key: const Key("empty"),
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Center(
                child: Text(
                  'Select a task and it appears here!',
                  // style: Theme.of(context).textTheme.titleMedium!
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          for (int index = 0; index < selectedTask.length; index++)
            Container(
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  color: Colors.pink[50],
                  border: Border.all(color: Colors.pink.shade100),
                  borderRadius: BorderRadius.circular(15)),
              key: Key('$index'),
              child: ReorderableDelayedDragStartListener(
                index: index,
                child: ListTile(
                    leading: IconButton(
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.red,
                      ),
                      color: Theme.of(context).colorScheme.error,
                      onPressed: () => onTapDelete(index),
                    ),
                    trailing: ReorderableDragStartListener(
                      index: index,
                      child: const Icon(
                        Icons.drag_handle_rounded,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      'Duration : ${durationToString(parseDuration(selectedTask[index].duration))} Min',
                      style: Theme.of(context).textTheme.bodyMedium!.apply(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.8)),
                    ),
                    title: Text(
                      selectedTask[index].name,
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
              ),
            ),
        ],
      );
    }));
  }
}

class RepeatPage extends StatelessWidget {
  const RepeatPage({
    super.key,
    required this.onDayChange,
    required this.selectedDays,
    required this.onChangeRepeatType,
    required this.time,
    required this.onChangeTime,
    required this.onToggleNotification,
    required this.notification,
  });
  final void Function(String, bool) onDayChange;
  final Map<String, bool> selectedDays;
  final void Function(RepeatType) onChangeRepeatType;
  final TimeOfDay? time;
  final void Function(TimeOfDay time) onChangeTime;
  final void Function() onToggleNotification;
  final bool notification;

  @override
  Widget build(BuildContext context) {
    Future<void> selectTime(BuildContext context) async {
      TimeOfDay? pickedTime = await showTimePicker(
        
        context: context,
        initialTime: time ?? TimeOfDay.now(),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child ?? Container(),
        ),
      );
      if (pickedTime != null && pickedTime != time) {
        onChangeTime(pickedTime);
      }
    }

    return ListView(
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          "Repeat",
          // style: Theme.of(context).textTheme.titleLarge,
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          children: [
            ChoiceChip(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.pink.shade100)),
              label: const Text("Daily"),
              pressElevation: 0,
              // shape: const RoundedRectangleBorder(
              //   // borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
              // ),
              selected: !selectedDays.values.contains(false),
              selectedColor: Colors.pink.shade100,
              backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
              onSelected: (value) => onChangeRepeatType(RepeatType.daily),
              // selectedColor: Theme.of(context).colorScheme.inversePrimary,
              labelStyle: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              width: 10,
            ),
            ChoiceChip(
              label: const Text("Only on"),
              // shape: const RoundedRectangleBorder(
              //   borderRadius:
              //       BorderRadius.horizontal(right: Radius.circular(5)),
              // ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.pink.shade100)),
              pressElevation: 0,
              selected: selectedDays.values.contains(false),
              backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
              onSelected: (value) => onChangeRepeatType(RepeatType.onlyOn),
              // selectedColor: Theme.of(context).colorScheme.inversePrimary,
              selectedColor: Colors.pink.shade100,
              labelStyle: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        selectedDays.values.contains(false)
            ? Wrap(
                spacing: 2,
                runSpacing: -8,
                children: selectedDays.keys
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ChoiceChip(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: Colors.pink.shade100)),
                          elevation: 3,
                          label: Text(e),
                          selected: selectedDays[e] ?? false,
                          backgroundColor:
                              Theme.of(context).colorScheme.onInverseSurface,
                          onSelected: (value) => onDayChange(e, value),
                          // selectedColor:
                          //     Theme.of(context).colorScheme.inversePrimary,
                          selectedColor: Colors.pink.shade100,

                          labelStyle: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    )
                    .toList())
            : Container(),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Notification",
              // style: Theme.of(context).textTheme.titleLarge,
              style: TextStyle(
                fontSize: 17.sp,
                color: Colors.grey.shade600,
              ),
            ),
            GestureDetector(
              onTap: onToggleNotification,
              child: Container(
                height: 50,
                width: 80,
                margin: EdgeInsets.only(right: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.pink.shade100),
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: Row(
                    children: [
                      notification
                          ? Icon(
                              Icons.notifications_active_rounded,
                              color: Colors.pink[200],
                            )
                          : Icon(
                              Icons.notifications_off_rounded,
                              color: Colors.pink[200],
                            ),
                      Text(
                        notification ? 'ON' : 'OFF',
                        style: Theme.of(context).textTheme.titleMedium!.apply(
                              color: Colors.pink[200],
                              // Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // TextButton.icon(
            //     onPressed: onToggleNotification,
            //     icon: notification
            //         ? const Icon(Icons.notifications_active_rounded)
            //         : const Icon(Icons.notifications_off_rounded),
            //     label: notification ? const Text("ON") : const Text("OFF"))
          ],
        ),
        notification
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select Time",
                      // style: Theme.of(context).textTheme.titleMedium,
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => selectTime(context),
                      child: Container(
                        height: 50,

                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.pink.shade100),
                            borderRadius: BorderRadius.circular(15)),
                        // style: ElevatedButton.styleFrom(
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        // ),

                        child: time == null
                            ? Center(child: const Text("Select Time"))
                            : Center(
                                child: Text(
                                  time!.format(context),
                                  style: TextStyle(color: Colors.pink[200]),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              )
            : Container()
      ],
    );
  }
}
