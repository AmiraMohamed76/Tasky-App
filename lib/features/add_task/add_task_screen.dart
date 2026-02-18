import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/core/widgets/custom_text_form_field.dart';
import 'package:tasky_app/features/add_task/controller/add_task_controller.dart';


class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext _) {
    return ChangeNotifierProvider<AddTaskController>(
      create: (_) => AddTaskController(),
      /// we use builder here to use its context to call addTask function from controller coz if we didn't do that it will use build context not provider
      builder: (context, _){
        final controller = context.read<AddTaskController>();
        return Scaffold(
          appBar: AppBar(title: Text("New Task")),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
              child: Form(
                key: controller.key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFormField(
                              controller: controller.taskNameController,
                              hintText: 'Please Enter Task Name',
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Please Enter Task Name";
                                }
                                return null;
                              },
                              title: "Task Name",
                            ),
                            SizedBox(height: 20),
                            CustomTextFormField(
                              controller: controller.taskDescriptionController,
                              hintText: 'Finish onboarding UI and hand off to devs by Thursday.',
                              maxLines: 5,
                              title: "Task Description",
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "High Priority",
                                    style: Theme.of(context).textTheme.titleMedium
                                ),
                                Consumer<AddTaskController>(
                                  builder: (BuildContext context, AddTaskController value, Widget? child) {
                                    return Switch(
                                      value: value.isHighPriority, // we don't use controller coz controller is read not watch which read not rebuild and i need rebuild to Switch button
                                      onChanged: (bool value) => controller.priorityToggle(value),
                                      // activeTrackColor: Color(0xFF15B86C),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => controller.addTask(context),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width, 40),
                      ),
                      label: Text("Add Task",),
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
