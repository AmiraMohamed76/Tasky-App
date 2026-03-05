import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/features/tasks/controller/tasks_controller.dart';
import 'package:tasky_app/core/components/task_list_widget.dart';

import '../../core/constants/app_sizes.dart';


class ToDoTasksScreen extends StatelessWidget {
  const ToDoTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TasksController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.pw18),
            child: Text(
              "To Do Tasks",
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.pw16),
            child: controller.isLoading
                ? Center(
              child: CircularProgressIndicator(color: Color(0xFFFFFCFC)),
            )
                : Consumer<TasksController>(
              builder: (BuildContext context, TasksController valueController, Widget? child) {
                return TaskListWidget(
                  tasks: valueController.todoTasks,
                  onTap: (bool? value, int? index) => controller.doneTask(value, valueController.todoTasks[index!].id),
                  onDelete: (int? id) => controller.deleteTask(id),
                  onEdit: () => controller.init(),
                  emptyMessage: "No Tasks Found",
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
