import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky_app/core/enums/task_item_actions_enum.dart';
import 'package:tasky_app/core/services/theme_controller.dart';
import 'package:tasky_app/model/task_model.dart';

import '../services/preferences_manager.dart';
import '../widgets/custom_check_box.dart';
import '../widgets/custom_text_form_field.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskModel task;
  final Function(bool?) onChanged;
  final Function(int?) onDelete;
  final Function onEdit;

  const TaskItemWidget({
    super.key,
    required this.task,
    required this.onChanged,
    required this.onDelete,
    required this.onEdit
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
        border: Border.all(color: Theme.of(context).colorScheme.primary),
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
          PopupMenuButton<TaskItemActionsEnum>(
            icon: Icon(
              Icons.more_vert_outlined,
              color: ThemeController.isDark()
                  ? (task.isDone ? Color(0xFFA0A0A0) : Color(0xFFC6C6C6))
                  : (task.isDone ? Color(0xFF6A6A6A) : Color(0xFF3A4640)),
              size: 24,
            ),
            onSelected: (value) async {
              switch (value) {
                case TaskItemActionsEnum.markAsDone:
                  onChanged(!task.isDone);
                case TaskItemActionsEnum.edit:
                  final result = await _showBottomSheet(context, task);
                  if(result == true) onEdit();
                case TaskItemActionsEnum.delete:
                  await _showAlertDialog(context);
              }
            },
            itemBuilder: (context) => TaskItemActionsEnum.values.map((e) {
              return PopupMenuItem(value: e, child: Text(e.name));
            }).toList(),
          ),
        ],
      ),
    );
  }

  _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text("Delete Task"),
          content: Text("Are you sure you want to delete this task ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel", style: TextStyle(fontSize: 18)),
            ),
            TextButton(
              onPressed: () {
                onDelete(task.id);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text("Delete", style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showBottomSheet(BuildContext context, TaskModel task) {
    final GlobalKey<FormState> key = GlobalKey<FormState>();
    final TextEditingController taskNameController = TextEditingController(
      text: task.taskName,
    );
    final TextEditingController taskDescriptionController =
        TextEditingController(text: task.taskDescription);
    bool isHighPriority = task.isHighPriority;
    return showModalBottomSheet<bool?>(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 16,
                right: 16,
                bottom: 8.0,
              ),
              child: Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFormField(
                              controller: taskNameController,
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
                              controller: taskDescriptionController,
                              hintText:
                                  'Finish onboarding UI and hand off to devs by Thursday.',
                              maxLines: 5,
                              title: "Task Description",
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "High Priority",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                Switch(
                                  value: isHighPriority,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isHighPriority = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (key.currentState?.validate() ?? false) {
                          // check by key {tasks} -> String?
                            final taskJson = PreferencesManager().getString("tasks");

                            List<dynamic> tasksList = []; // List<Map<String, dynamic>>

                            // check if there is tasks and decode string to map
                            if (taskJson != null) {
                              tasksList = jsonDecode(taskJson);
                            }

                            // to edit TaskModel to save newModel after editing in sharedPreference
                            final editedTask = TaskModel(
                              id: task.id,
                              taskName: taskNameController.text,
                              taskDescription: taskDescriptionController.text,
                              isHighPriority: isHighPriority,
                              isDone: task.isDone
                            );

                            // to search about item using id in Map<key, value>   ///  to search about item using id in List<TaskModel>
                            final item = tasksList.firstWhere((e) => e['id'] == task.id);
                            /// = tasksList.map((e) => TaskModel.fromJson(e)).toList().firstWhere((element) => element.id == task.id);

                            final index = tasksList.indexOf(item);
                            // replace item after Editing
                            tasksList[index] = editedTask;

                            // covert this list to string to save it in SharedPreference
                            final tasksListEncode = jsonEncode(tasksList);
                            await PreferencesManager().setString("tasks", tasksListEncode);

                            Navigator.of(context).pop(true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width, 40),
                      ),
                      label: Text("Edit Task"),
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
