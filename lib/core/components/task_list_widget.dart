import 'package:flutter/material.dart';
import 'package:tasky_app/model/task_model.dart';
import 'package:tasky_app/core/components/task_item_widget.dart';

class TaskListWidget extends StatelessWidget {
  final List<TaskModel> tasks;
  final Function(bool?, int?) onTap;
  final Function(int?) onDelete;
  final Function onEdit;
  final String? emptyMessage;

  const TaskListWidget({
    super.key,
    required this.tasks,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
    this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(
            child: Text(
              emptyMessage ?? "No Data",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            padding: EdgeInsets.only(bottom: 50),
            itemBuilder: (BuildContext context, int index) {
              return TaskItemWidget(
                task: tasks[index],
                onChanged: (bool? value) {
                  onTap(value, index);
                },
                onDelete: (int? id) {
                  onDelete(id);
                },
                onEdit: () => onEdit(),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 8);
            },
          );
  }
}
