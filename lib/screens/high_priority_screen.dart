import 'dart:convert';

import 'package:flutter/material.dart';
import '../core/services/preferences_manager.dart';
import '../model/task_model.dart';
import '../widgets/task_list_widget.dart';

class HighPriorityScreen extends StatefulWidget {
  const HighPriorityScreen({super.key});

  @override
  State<HighPriorityScreen> createState() => _HighPriorityScreenState();
}

class _HighPriorityScreenState extends State<HighPriorityScreen> {
  List<TaskModel> highPriorityTasks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  void _loadTask() async {
    setState(() {
      isLoading = true;
    });

    final tasksList = PreferencesManager().getString("tasks");
    if (tasksList != null) {
      final tasksListDecode = jsonDecode(tasksList) as List<dynamic>;
      setState(() {
        highPriorityTasks = tasksListDecode
            .map((element) => TaskModel.fromJson(element))
            .where((element) => element.isHighPriority)
            .toList();

        highPriorityTasks = highPriorityTasks.reversed.toList();
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("High Priority Tasks")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(
            child: CircularProgressIndicator(color: Color(0xFFFFFCFC)))
            : TaskListWidget(
          tasks: highPriorityTasks,
          onTap: (bool? value, int? index) async {
            setState(() {
              highPriorityTasks[index!].isDone = value ?? false;
            });

            // to save isDone in sharedPref
            final allData = PreferencesManager().getString("tasks");
            // to update changed item not change all list
            if (allData != null) {
              List<TaskModel> allDataList = (jsonDecode(allData) as List)
                  .map((element) => TaskModel.fromJson(element))
                  .toList();
              final newIndex = allDataList.indexWhere((e) =>
              e.id == highPriorityTasks[index!].id);
              allDataList[newIndex] = highPriorityTasks[index!];
              await PreferencesManager().setString("tasks", jsonEncode(allDataList));
              // To update screen after check task
              _loadTask();
            }

          },
          emptyMessage: "No Tasks Found",
        ),
      ),
    );
  }
}
