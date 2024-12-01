import 'package:app_2/components/image.const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../components/header.dart';
import '../services/routines_provider.dart';

class ArchiveRoutinesScreen extends StatelessWidget {
  const ArchiveRoutinesScreen({super.key});
  static const routeName = "/archive";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RoutineModel>(
        builder: (context, value, child) => value.archiveRoutines().isEmpty
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
                      child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          child ?? Container(),
                          Expanded(
                            flex: 10,
                            child: Center(
                              child: Text(
                                "Archived routines will show up here!",
                                textAlign: TextAlign.center,
                                // style: Theme.of(context)
                                //     .textTheme
                                //     .apply(
                                //         displayColor:
                                //             Theme.of(context).colorScheme.onSurface)
                                //     .headlineMedium,
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
                      ),
                    ),
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
                    child: ListView.builder(
                        itemCount: value.archiveRoutines().length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: child ?? Container(),
                            );
                          }
                          index -= 1;
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.4),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: ListTile(
                              title: Text(
                                value.archiveRoutines()[index].name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              subtitle: Text(
                                "Archived",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                ),
                              ),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Provider.of<RoutineModel>(context,
                                                listen: false)
                                            .removeFromArchive(value
                                                .archiveRoutines()[index]
                                                .id);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: const Icon(
                                            Icons.unarchive_rounded,
                                            color: Colors.blue,
                                          )),
                                    ),
                                    // GestureDetector(
                                    //   color: Colors.red[300],
                                    //   onPressed: () {},
                                    //   icon: const Icon(Icons.delete),
                                    // )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
        child: const ScreenHeader(text: 'Archived', tag: 'Archived'),
      ),
    );
  }
}

class Action extends StatelessWidget {
  const Action(
      {super.key,
      required this.onPress,
      required this.color,
      required this.icon,
      required this.label});

  final Function(BuildContext context) onPress;
  final Color color;
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
            child: TextButton.icon(
          onPressed: (() {
            onPress(context);
            Slidable.of(context)?.close();
          }),
          icon: Icon(
            icon,
            color: color,
          ),
          label: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium!.apply(color: color),
          ),
        )),
      ),
    );
  }
}
