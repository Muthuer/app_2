import 'package:app_2/utils/duration_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../services/routines_provider.dart';
import '../services/tasks_provider.dart';
import '../utils/parse_duration.dart';
import 'create_task_bottom_sheet.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, required this.onEdit});
  final Task task;
  final void Function(Task) onEdit;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () async {
                    Task? t = await showModalBottomSheet<Task>(
                        isScrollControlled: true,
                        isDismissible: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10),
                            bottom: Radius.zero,
                          ),
                        ),
                        context: context,
                        builder: ((context) => CreateTaskBottomSheet(
                              task: task,
                            )));

                    if (t != null) {
                      onEdit(task.copyWith(
                          color: t.color, duration: t.duration, name: t.name));
                    }
                  },
                  icon: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.black,
                      ))),
              IconButton(
                  onPressed: () async {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        final brightness = Brightness.dark;
                        return CupertinoTheme(
                            data: CupertinoThemeData(
                              // primaryColor: Colors.green, not now color
                              brightness: brightness,
                            ),
                            child: CupertinoAlertDialog(
                              title: Text("Delete task?"),
                              content: Text(
                                  "This task will be removed from all routines. If a routine contains only this task, the routine will be deleted as well."),
                              actions: [
                                CupertinoDialogAction(
                                  child: Text(
                                    "Not Now",
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                CupertinoDialogAction(
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(
                                        color: CupertinoColors.destructiveRed),
                                  ),
                                  onPressed: () {
                                    Provider.of<TaskModel>(context,
                                            listen: false)
                                        .delete(task.id);
                                    Provider.of<RoutineModel>(context,
                                            listen: false)
                                        .removeTask(task);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ));
                      },
                    );
                    // showDialog(
                    //     context: context,
                    //     builder: ((context) => AlertDialog(
                    //           title: const Text("Delete task?"),
                    //           content: const Text(
                    //               "This task will be removed from all routines. If a routine contains only this task, the routine will be deleted as well."),
                    //           actions: [
                    //             // TextButton(
                    //             //   onPressed: () {
                    //             //     Navigator.pop(context);
                    //             //   },
                    //             //   child: const Text("CANCEL"),
                    //             // ),
                    //             TextButton(
                    //               style: TextButton.styleFrom(
                    //                   foregroundColor:
                    //                       Theme.of(context).colorScheme.error),
                    //               onPressed: () {
                    //                 Provider.of<TaskModel>(context,
                    //                         listen: false)
                    //                     .delete(task.id);
                    //                 Provider.of<RoutineModel>(context,
                    //                         listen: false)
                    //                     .removeTask(task);
                    //                 Navigator.pop(context);
                    //               },
                    //               child: const Text("DELETE"),
                    //             )
                    //           ],
                    //         )));
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ))
            ],
          ),
        ),
        subtitle: Text(
            'Duration : ${durationToString(parseDuration(task.duration))} Min'),
        title: Text(
          task.name,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
