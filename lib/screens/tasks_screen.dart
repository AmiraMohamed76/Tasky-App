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
  List<TaskModel> todoTasks = [];

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
      final taskAfterDecode = jsonDecode(finalTasks) as List<
          dynamic>; // to covert string to List<Map<String, dynamic>>
      setState(() {
        todoTasks = taskAfterDecode
            .map((element) =>
            TaskModel.fromJson(
            element)) // convert List<Map<String, dynamic>> to List<Model>
            .where((element) => !element.isDone) // filter allDataList to get items which has isDone = false
            .toList();
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text("To Do Tasks",
            style: TextStyle(
                color: Color(0xFFFFFCFC),
                fontSize: 20
            ),),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLoading
                ? Center(
                child: CircularProgressIndicator(color: Color(0xFFFFFCFC)))
                : TaskListWidget(
              tasks: todoTasks,
              onTap: (bool? value, int? index) async {
                setState(() {
                  todoTasks[index!].isDone = value ?? false;
                });

                // to save isDone in sharedPref
                final pref = await SharedPreferences.getInstance();
                final allData = pref.getString("tasks");
                // to update changed item not change all list
                if (allData != null) {
                  List<TaskModel> allDataList = (jsonDecode(allData) as List)
                      .map((element) => TaskModel.fromJson(element))
                      .toList();
                  final newIndex = allDataList.indexWhere((e) =>
                  e.id == todoTasks[index!].id);
                  allDataList[newIndex] = todoTasks[index!];
                  await pref.setString("tasks", jsonEncode(allDataList));
                  // To update screen after check task
                  _loadTask();
                }

              },
              emptyMessage: "No Tasks Found",
            ),
          ),
        ),
      ],
    );
  }
}
