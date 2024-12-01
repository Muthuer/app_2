import 'package:app_2/components/app_colors.dart';
import 'package:app_2/components/image.const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../components/create_task_bottom_sheet.dart';
import '../components/header.dart';
import '../components/task_tile.dart';
import '../models/task.dart';
import '../services/routines_provider.dart';
import '../services/tasks_provider.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key, this.isBottomNavWidget = false});
  static const routeName = "/tasks";
  final bool isBottomNavWidget;
  @override
  Widget build(BuildContext context) {
    void addTask(Task t) {
      Provider.of<TaskModel>(context, listen: false).add(t);
    }

    void onEdit(Task t) {
      Provider.of<TaskModel>(context, listen: false).edit(t);
      Provider.of<RoutineModel>(context, listen: false).editTask(t);
    }

    void onCreateTask() async {
      Task? t = await showModalBottomSheet<Task>(
          barrierColor: Colors.black.withOpacity(0.6),
          backgroundColor: Colors.white,
          isScrollControlled: true,
          isDismissible: true,
          context: context,
          builder: ((context) => const CreateTaskBottomSheet()));
      if (t != null) {
        addTask(t);
      }
    }

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: onCreateTask,
      //   child: const Icon(Icons.add),
      // ),
      body: Consumer<TaskModel>(
        builder: ((context, value, child) => value.tasks.isEmpty
            ? Stack(
                children: [
                  Positioned.fill(
                    child: SizedBox.expand(
                      child: Opacity(
                        opacity: .7,
                        child: Image.asset(
                          AppImages.bg2,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Center(
                          child: Text(
                            "My Task",
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
                      ),
                    ),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          child ?? Container(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Seems like you haven't added any tasks yet.",
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors.black.withOpacity(.5),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: IntrinsicWidth(
                              child: GestureDetector(
                                onTap: onCreateTask,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                    vertical: 18.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.add,
                                        size: 26,
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        "Create One",
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          color: AppColors.black,
                                        ),
                                      ),
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
                      child: ListView.builder(
                          itemCount: value.tasks.length,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, right: 10, left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Text(
                                            "My Task",
                                            style: GoogleFonts.lato(
                                              fontWeight: FontWeight.bold,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .apply(
                                                      displayColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onSurface)
                                                  .headlineLarge,
                                            ),
                                            // style: Theme.of(context)
                                            //     .textTheme
                                            //     .headlineLarge!
                                            //     .apply(
                                            //         color: Theme.of(context)
                                            //             .colorScheme
                                            //             .onSurface),
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: onCreateTask,
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
                                        ),
                                      ],
                                    ),
                                    child ?? Container(),
                                    const SizedBox(height: 25),
                                    TaskTile(
                                      task: value.tasks[index],
                                      onEdit: onEdit,
                                    )
                                  ],
                                ),
                              );
                            }
                            return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TaskTile(
                                  task: value.tasks[index],
                                  onEdit: onEdit,
                                ));
                          }))
                ],
              )),
        // child: isBottomNavWidget
        //     ? Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 8),
        //         child: Text(
        //           "My Task",
        //           style: Theme.of(context)
        //               .textTheme
        //               .headlineLarge!
        //               .apply(color: Theme.of(context).colorScheme.onSurface),
        //         ),
        //       )
        //     : const ScreenHeader(
        //         text: "My Tasks",
        //         tag: "My Tasks",
        //       )
      ),
    );
  }
}
