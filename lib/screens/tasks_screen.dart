import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky_app/model/task_model.dart';
import 'package:tasky_app/widgets/task_list_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool isLoading = false;
  List<TaskModel> tasks = [];

  @override
  void initState() {
    super.initState();

    _loadTask();
  }

  void _loadTask() async {
    setState(() {
      isLoading = true;
    });
    final pref = await SharedPreferences.getInstance();
    final finalTasks = pref.getString("tasks");

    if (finalTasks != null) {
      final taskDecoded = jsonDecode(finalTasks) as List<dynamic>;
      setState(() {
        tasks = taskDecoded
            .map((element) => TaskModel.fromJson(element))
            .where((element) => element.isDone == false)
            .toList();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("To Do Tasks")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: Color(0xFFFFFCFC)))
            : TaskListWidget(
                tasks: tasks,
                onTap: (bool? value, int? index) async {
                  setState(() {
                    tasks[index!].isDone = value ?? false;
                  });

                  // to save isDone in sharedPref
                  final pref = await SharedPreferences.getInstance();
                  final updatedTasksList = tasks
                      .map((element) => element.toJson())
                      .toList();
                  await pref.setString("tasks", jsonEncode(updatedTasksList));

                  // To update screen after check task
                  _loadTask();
                },
                emptyMessage: "No Tasks Found",
              ),
      ),
    );
  }
}
