import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/features/tasks/controller/tasks_controller.dart';
import '../../core/components/task_list_widget.dart';
import '../../core/constants/app_sizes.dart';

class HighPriorityTasksScreen extends StatelessWidget {
  const HighPriorityTasksScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final controller = context.read<TasksController>();
    return Scaffold(
      appBar: AppBar(title: Text("High Priority Tasks")),
      body: Padding(
        padding:  EdgeInsets.symmetric(vertical: AppSizes.ph16, horizontal: AppSizes.pw16),
        child: controller.isLoading
            ? Center(child: CircularProgressIndicator(color: Color(0xFFFFFCFC)))
            : Consumer<TasksController>(
          builder: (BuildContext context, TasksController valueController, Widget? child) {
            return TaskListWidget(
              tasks: valueController.highPriorityTasks,
              onTap: (bool? value, int? index) => controller.doneTask(value, valueController.highPriorityTasks[index!].id),
              onDelete: (int? id) =>   controller.deleteTask(id),
              onEdit: () => controller.init(),
              emptyMessage: "No Tasks Found",
            );
          },
        ),
      ),
    );
  }
}
