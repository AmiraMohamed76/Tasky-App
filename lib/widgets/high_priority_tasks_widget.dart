import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky_app/core/widgets/custom_check_box.dart';
import 'package:tasky_app/model/task_model.dart';
import 'package:tasky_app/screens/high_priority_screen.dart';

class HighPriorityTasksWidget extends StatelessWidget {
  final List<TaskModel> tasks;
  final Function(bool?, int?) onTap;
  final Function refresh;

  const HighPriorityTasksWidget({
    super.key,
    required this.tasks,
    required this.onTap,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                  child: Text(
                    "High Priority Tasks",
                    style: TextStyle(
                      color: Color(0xFF15B86C),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:
                      tasks.reversed
                              .where((e) => e.isHighPriority)
                              .toList()
                              .length >
                          4
                      ? 4
                      : tasks.reversed
                            .where((e) => e.isHighPriority)
                            .toList()
                            .length,

                  itemBuilder: (context, index) {
                    final task = tasks.reversed
                        .where((e) => e.isHighPriority)
                        .toList()[index];
                    return Row(
                      children: [
                        CustomCheckBox(
                          value: task.isDone,
                          onChanged: (bool? value) {
                            final index = tasks.indexWhere(
                              (e) => e.id == task.id,
                            );
                            onTap(value, index);
                          },
                        ),
                        Flexible(
                          child: Text(
                            task.taskName,
                            style: task.isDone
                                ? Theme.of(context).textTheme.titleLarge
                                : Theme.of(context).textTheme.titleMedium,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return HighPriorityScreen();
                  },
                ),
              );
              refresh();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 48,
                height: 56,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  border: Border.all(color: Color(0xFF6E6E6E)),
                ),
                child: SvgPicture.asset("assets/images/arrow_up_right.svg"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
