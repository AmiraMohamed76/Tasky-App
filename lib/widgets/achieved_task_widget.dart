import 'dart:math';

import 'package:flutter/material.dart';

class AchievedTaskWidget extends StatelessWidget {
  final int totalTasks;
  final int doneTasks;
  final double precent;

  const AchievedTaskWidget({
    super.key,
    required this.totalTasks,
    required this.doneTasks,
    required this.precent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Achieved Tasks",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                "$doneTasks Out of $totalTasks Done",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: -pi / 2,
                // to rotate progress to start from top left
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    value: precent,
                    backgroundColor: Color(0xFF6D6D6D),
                    valueColor: AlwaysStoppedAnimation(Color(0xFF15B86C)),
                    strokeWidth: 4,
                  ),
                ),
              ),
              Text(
                "${(precent * 100).toStringAsFixed(0)}%",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
