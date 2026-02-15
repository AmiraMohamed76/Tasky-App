import 'package:flutter/material.dart';
import 'package:tasky_app/model/task_model.dart';
import 'package:tasky_app/widgets/task_item_widget.dart';

class SliverTaskListWidget extends StatelessWidget {
  const SliverTaskListWidget({
    super.key,
    required this.tasks,
    required this.onTap,
    this.emptyMessage,
  });

  final List<TaskModel> tasks;
  final Function(bool?, int?) onTap;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? SliverToBoxAdapter(
            child: Center(
              child: Text(
                emptyMessage ?? "No Data",
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          )
        : SliverPadding(
            padding: EdgeInsets.only(bottom: 50),
            sliver: SliverList.separated(
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) {
                return TaskItemWidget(
                  task: tasks[index],
                  onChanged: (bool? value) {
                    onTap(value, index);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 8);
              },
            ),
          );
  }
}
