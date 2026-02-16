import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tasky_app/core/services/preferences_manager.dart';
import 'package:tasky_app/core/widgets/custom_text_form_field.dart';
import 'package:tasky_app/model/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  //TODO: DISPOSE THIS CONTROLLERS
  final TextEditingController taskNameController = TextEditingController();

  final TextEditingController taskDescriptionController =
      TextEditingController();

  bool isHighPriority = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Task")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: Form(
            key: _key,
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
                            Switch(
                              value: isHighPriority,
                              onChanged: (bool value) {
                                setState(() {
                                  isHighPriority = value;
                                });
                              },
                              // activeTrackColor: Color(0xFF15B86C),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_key.currentState?.validate() ?? false) {
                      // check by key {tasks} -> String?
                      final taskJson = PreferencesManager().getString("tasks");

                      List<dynamic> tasksList = []; // List<Map<String, dynamic>>

                      // check if there is tasks and decode string to map
                      if (taskJson != null) {
                        tasksList = jsonDecode(taskJson);
                      }

                      // to create TaskModel to save in sharedPreference
                      final task = TaskModel(
                        id: tasksList.length + 1,
                        taskName: taskNameController.text,
                        taskDescription: taskDescriptionController.text,
                        isHighPriority: isHighPriority,
                      );

                      // to covert data from Model to Map<key, value>
                      tasksList.add(task.toJson());

                      // covert this list to string to save it in SharedPreference
                      final tasksListEncode = jsonEncode(tasksList);
                      await PreferencesManager().setString("tasks", tasksListEncode);

                      // navigation with result (true) value to check on this result on HomeScreen to check if add task will loadTasks again to update list
                      Navigator.of(context).pop(true);
                    }
                  },
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
  }
}
