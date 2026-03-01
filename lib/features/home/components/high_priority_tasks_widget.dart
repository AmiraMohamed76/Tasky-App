import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/core/widgets/custom_check_box.dart';
import 'package:tasky_app/core/widgets/custom_svg_picture.dart';
import 'package:tasky_app/features/tasks/high_priority_tasks_screen.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/services/theme_controller.dart';
import '../../tasks/controller/tasks_controller.dart';

class HighPriorityTasksWidget extends StatelessWidget {
  const HighPriorityTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksController>(
      builder: (BuildContext context, TasksController value, Widget? child) {
        final controller = context.read<TasksController>();

        final tasks = value.tasks;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.r20),
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
                padding: EdgeInsets.only(
                  top: AppSizes.ph16,
                  right: AppSizes.pw16,
                  left: AppSizes.pw16,
                ),
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
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.pw30,
                              vertical: AppSizes.ph30,
                            ),
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
                                      controller.doneTask(value, task.id);
                                    },
                                  ),
                                  Flexible(
                                    child: Text(
                                      task.taskName,
                                      style: task.isDone
                                          ? Theme.of(
                                              context,
                                            ).textTheme.titleLarge
                                          : Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
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
                      controller.init();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSizes.ph8, horizontal: AppSizes.pw8),
                      child: Container(
                        width: AppSizes.w48,
                        height: AppSizes.h48,
                        padding: EdgeInsets.symmetric(vertical: AppSizes.ph8, horizontal: AppSizes.pw8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primaryContainer,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        child: CustomSvgPicture(
                          imagePath: "assets/images/arrow_up_right.svg",
                          height: AppSizes.h24,
                          width: AppSizes.w24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
