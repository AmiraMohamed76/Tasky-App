import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      appBar: AppBar(

        title: Text("New Task"),
      ),
      body: SafeArea(
        child: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Task Name",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFFFFCFC),
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: taskNameController,
                          validator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please Enter Task Name";
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Finish UI design for login screen',
                            hintStyle: TextStyle(color: Color(0xFF6D6D6D)),
                            filled: true,
                            fillColor: Color(0xFF282828),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          cursorColor: Colors.white,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Task Description",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFFFFCFC),
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: taskDescriptionController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText:
                                'Finish onboarding UI and hand off to devs by Thursday.',
                            hintStyle: TextStyle(color: Color(0xFF6D6D6D)),
                            filled: true,
                            fillColor: Color(0xFF282828),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          maxLines: 5,
                          cursorColor: Colors.white,
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "High Priority",
                              style: TextStyle(
                                color: Color(0xFFFFFCFC),
                                fontSize: 16,
                              ),
                            ),
                            Switch(
                              value: isHighPriority,
                              onChanged: (bool value) {
                                setState(() {
                                  isHighPriority = value;
                                });
                              },
                              activeTrackColor: Color(0xFF15B86C),
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
                      final task = TaskModel(
                        taskName: taskNameController.text,
                        taskDescription: taskDescriptionController.text,
                        isHighPriority: isHighPriority,
                      );

                      final pref = await SharedPreferences.getInstance();
                      final taskJson = pref.getString("tasks"); // check if there are old tasks before adding new task

                      List<dynamic> tasksList = [];
                      if (taskJson != null) {
                        tasksList = jsonDecode(taskJson);
                      }
                      tasksList.add(task.toJson());

                      final tasksListEncode = jsonEncode(tasksList);
                      await pref.setString("tasks", tasksListEncode);

                      Navigator.of(context).pop(true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF15B86C),
                    foregroundColor: Color(0xFFFFFCFC),
                    fixedSize: Size(MediaQuery.of(context).size.width, 40),
                  ),
                  label: Text("Add Task"),
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
