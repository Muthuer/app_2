import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/routines_provider.dart';

class TimeSpentToday extends StatelessWidget {
  const TimeSpentToday({super.key, required this.textTheme});
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Selector<RoutineModel, int>(
          selector: (p0, p1) => p1.getTimeSpentToday(),
          builder: (context, value, child) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Text(
                  "Time Spent Today",
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: 10),
                Text(
                  "$value mins",
                  style: textTheme.headlineLarge,
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ));
  }
}
