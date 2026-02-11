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
        color: Color(0xFF282828),
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
                style: TextStyle(
                  color: Color(0xFFFFFCFC),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "$doneTasks Out of $totalTasks Done",
                style: TextStyle(
                  color: Color(0xFFC6C6C6),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
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
                style: TextStyle(
                  color: Color(0xFFC6C6C6),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
