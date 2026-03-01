import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/core/constants/app_sizes.dart';
import 'package:tasky_app/core/widgets/custom_svg_picture.dart';
import 'package:tasky_app/features/home/controller/home_controller.dart';
import 'package:tasky_app/features/add_task/add_task_screen.dart';
import 'package:tasky_app/features/home/components/achieved_task_widget.dart';
import 'package:tasky_app/features/home/components/high_priority_tasks_widget.dart';
import 'package:tasky_app/features/home/components/sliver_task_list_widget.dart';
import 'package:tasky_app/features/tasks/controller/tasks_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (context) => HomeController()..init(),
      child: Scaffold(
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal: AppSizes.pw16, vertical: AppSizes.ph16),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: AppSizes.w8,
                      children: [
                        Selector<HomeController, String?>(
                          selector:
                              (BuildContext context, HomeController controller) => controller.userImagePath,
                          builder:
                              (BuildContext context, userImagePath, Widget? child) {
                                return CircleAvatar(
                                  backgroundImage: userImagePath == null
                                      ? AssetImage("assets/images/person.png")
                                      : FileImage(File(userImagePath)),
                                );
                              },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Selector<HomeController, String?>(
                              selector:
                                  (BuildContext context, HomeController controller) => controller.username,
                              builder:
                                  (BuildContext context, String? username, Widget? child) {
                                    return Text(
                                      "Good Evening ,$username",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    );
                                  },
                            ),
                            Selector<HomeController, String>(
                              selector:
                                  (BuildContext context, HomeController controller) => controller.motivationQuote,
                              builder:
                                  (BuildContext context, String motivationQuote, Widget? child) {
                                    return Text(
                                      motivationQuote,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    );
                                  },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.ph16),
                    Text(
                      "Yuhuu ,Your work Is",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Row(
                      children: [
                        Text(
                          "almost done ! ",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        CustomSvgPicture.withoutColor(
                          imagePath: "assets/images/waving_hand.svg",
                        ),
                      ],
                    ),
                    AchievedTaskWidget(),
                    SizedBox(height: AppSizes.ph8),
                    HighPriorityTasksWidget(),
                    Padding(
                      padding: EdgeInsets.only(top: AppSizes.ph24, bottom: AppSizes.ph16),
                      child: Text(
                        "My Tasks",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ),
              SliverTaskListWidget(),
            ],
          ),
        ),
        floatingActionButton: SizedBox(
          height: AppSizes.h40,
          child: Builder(
            builder: (BuildContext controllerContext) {
              return FloatingActionButton.extended(
                onPressed: () async {
                  final bool? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return AddTaskScreen();
                      },
                    ),
                  );

                  if(!context.mounted) return;
                  if (result != null && result) {
                    // we have to use HomeController context coz context is navigation context
                    controllerContext.read<TasksController>().init();
                  }
                },
                label: Text("Add New Task"),
                icon: Icon(Icons.add),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.r100),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
