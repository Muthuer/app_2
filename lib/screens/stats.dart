import 'package:app_2/components/image.const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../components/daily_activity.dart';
import '../components/header.dart';
import '../components/most_productive_hour.dart';
import '../components/productive_day.dart';
import '../components/time_spent_today.dart';
import '../components/weekly_chart.dart';
import '../models/task_event.dart';
import '../services/routines_provider.dart';

class Statistics extends StatelessWidget {
  const Statistics({super.key});
  static const routeName = "/stats";

  @override
  Widget build(BuildContext context) {
    void clearHistory() {
      Provider.of<RoutineModel>(context, listen: false).clearHistory();
    }

    final textTheme = Theme.of(context).textTheme.apply(
          displayColor: Theme.of(context).colorScheme.onSurface,
        );
    return Scaffold(
      body: Stack(
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
            padding: const EdgeInsets.all(4.0),
            child: ListView(
              children: [
                const SizedBox(height: 10),
                const ScreenHeader(text: "Statistics", tag: "Statistics"),
                const SizedBox(height: 25),
                Hero(
                    tag: 'WeeklyChart',
                    child: WeeklyChart(textTheme: textTheme)),
                const SizedBox(height: 10),
                TodayProgress(textTheme: textTheme),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: ProductiveHour(textTheme: textTheme)),
                    Expanded(child: ProductiveDay(textTheme: textTheme)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: TimeSpentToday(textTheme: textTheme)),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "History",
                      style: textTheme.headlineMedium,
                    ),
                    TextButton.icon(
                        onPressed: () async {
                          final b = await showDialog<bool>(
                            context: context,
                            builder: ((context) => AlertDialog(
                                  title: const Text("Clear History"),
                                  content: const Text(
                                      "This is an irreversible action. This will delete all your stats."),
                                  actions: [
                                    TextButton(
                                      onPressed: (() =>
                                          Navigator.pop(context, false)),
                                      child: const Text("CANCEL"),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .error),
                                      onPressed: (() =>
                                          Navigator.pop(context, true)),
                                      child: const Text("DELETE"),
                                    )
                                  ],
                                )),
                          );
                          if (b == true) {
                            clearHistory();
                          }
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.red[300]),
                        icon: const Icon(Icons.delete),
                        label: const Text("Clear History"))
                  ],
                ),
                const SizedBox(height: 15),
                Selector<RoutineModel, List<TaskEvent>>(
                    builder: ((context, value, child) => Column(
                          children: value.reversed
                              .map((e) => Card(
                                    child: ListTile(
                                      trailing: IconButton(
                                        onPressed: () =>
                                            Provider.of<RoutineModel>(context,
                                                    listen: false)
                                                .removeHistory(e.id),
                                        color: Colors.red[300],
                                        icon: const Icon(Icons.close,
                                            semanticLabel: 'Delete'),
                                      ),
                                      // onTap: () => ,
                                      title: Text(e.taskName),
                                      subtitle: Text(DateFormat("MMMM d, y")
                                          .add_jm()
                                          .format(e.time)),
                                    ),
                                  ))
                              .toList(),
                        )),
                    selector: (p0, p1) => p1.getHistory())
              ],
            ),
          ))
        ],
      ),
    );
  }
}
