import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/core/components/task_item_widget.dart';
import 'package:tasky_app/core/constants/app_sizes.dart';

import '../../tasks/controller/tasks_controller.dart';

class SliverTaskListWidget extends StatelessWidget {

  const SliverTaskListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksController>(
      builder: (BuildContext context, TasksController value, Widget? child) {
        final controller = context.read<TasksController>();
        final tasks = value.tasks;
        return value.isLoading
            ? SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFFFFCFC)),
                ),
              )
            : tasks.isEmpty
            ? SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    "No Data",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              )
            : SliverPadding(
                padding: EdgeInsets.only(bottom: AppSizes.ph50),
                sliver: SliverList.separated(
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TaskItemWidget(
                      task: tasks[index],
                      onChanged: (bool? value) => controller.doneTask(value, tasks[index].id),
                      onDelete: (int? id) => controller.deleteTask(id),
                      onEdit: () => controller.init(),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 8);
                  },
                ),
              );
      },
    );
  }
}
