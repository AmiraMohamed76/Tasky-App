import 'package:flutter/material.dart';
import 'package:tasky_app/core/services/theme_controller.dart';
import 'package:tasky_app/model/task_model.dart';

import '../core/widgets/custom_check_box.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskModel task;
  final Function(bool?) onChanged;

  const TaskItemWidget({
    super.key,
    required this.task,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8),
            child: CustomCheckBox(
              value: task.isDone,
              onChanged: (bool? value) => onChanged(value),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.taskName,
                  style: task.isDone
                      ? Theme.of(context).textTheme.titleLarge
                      : Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                ),
                if (task.taskDescription.isNotEmpty)
                  Text(
                    task.taskDescription,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert_outlined,
              color: ThemeController.isDark()
                  ? (task.isDone ? Color(0xFFA0A0A0) : Color(0xFFC6C6C6))
                  : (task.isDone ? Color(0xFF6A6A6A) : Color(0xFF3A4640)),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

