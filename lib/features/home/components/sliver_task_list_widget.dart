import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/features/home/home_controller.dart';
import 'package:tasky_app/model/task_model.dart';
import 'package:tasky_app/core/components/task_item_widget.dart';

class SliverTaskListWidget extends StatelessWidget {

  const SliverTaskListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (BuildContext context, HomeController value, Widget? child) {
        final controller = context.read<HomeController>();
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
                padding: EdgeInsets.only(bottom: 50),
                sliver: SliverList.separated(
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TaskItemWidget(
                      task: tasks[index],
                      onChanged: (bool? value) => controller.doneTask(value, index),
                      onDelete: (int? id) => controller.deleteTask(id),
                      onEdit: () => controller.loadTasks(),
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
