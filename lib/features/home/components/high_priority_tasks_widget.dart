import 'package:flutter/material.dart';
import 'package:tasky_app/core/widgets/custom_check_box.dart';
import 'package:tasky_app/core/widgets/custom_svg_picture.dart';
import 'package:tasky_app/model/task_model.dart';
import 'package:tasky_app/features/tasks/high_priority_tasks_screen.dart';

import '../../../core/services/theme_controller.dart';

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
        border: Border.all(
          color: ThemeController.isDark()
              ? Colors.transparent
              : Color(0xFFD1DAD6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
            child: Text(
              "High Priority Tasks",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: tasks.isEmpty || tasks.length < 2
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Expanded(
                child: tasks.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Text("No Data", textAlign: TextAlign.center),
                      )
                    : ListView.builder(
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
              ),
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return HighPriorityTasksScreen();
                      },
                    ),
                  );
                  refresh();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 48,
                    height: 56,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    child: CustomSvgPicture(
                      imagePath: "assets/images/arrow_up_right.svg",
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
