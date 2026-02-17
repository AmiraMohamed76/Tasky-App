import 'dart:convert';

import 'package:flutter/material.dart';
import '../../core/services/preferences_manager.dart';
import '../../model/task_model.dart';
import '../../core/components/task_list_widget.dart';

class HighPriorityTasksScreen extends StatefulWidget {
  const HighPriorityTasksScreen({super.key});

  @override
  State<HighPriorityTasksScreen> createState() => _HighPriorityTasksScreenState();
}

class _HighPriorityTasksScreenState extends State<HighPriorityTasksScreen> {
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

  void _onTap(bool? value, int? index) async {
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
      final newIndex = allDataList.indexWhere(
            (e) => e.id == highPriorityTasks[index!].id,
      );
      allDataList[newIndex] = highPriorityTasks[index!];
      await PreferencesManager().setString(
        "tasks",
        jsonEncode(allDataList),
      );
      // To update screen after check task
      _loadTask();
    }
  }

  void _onDelete(int? id) {
    List<TaskModel> tasks = [];
    final tasksList = PreferencesManager().getString("tasks");
    if(tasksList != null) {
      final tasksListDecode = jsonDecode(tasksList) as List<dynamic>;
      tasks = tasksListDecode.map((e) => TaskModel.fromJson(e)).toList();
      tasks.removeWhere((e) => e.id == id);

      setState(() {
        highPriorityTasks.removeWhere((e) => e.id == id);
      });

      final updatedTasks = tasks.map((e) => e.toJson()).toList();
      PreferencesManager().setString("tasks", jsonEncode(updatedTasks));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("High Priority Tasks")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: Color(0xFFFFFCFC)))
            : TaskListWidget(
                tasks: highPriorityTasks,
                onTap: (bool? value, int? index) => _onTap(value, index),
                onDelete: (int? id) => _onDelete(id),
                onEdit: () => _loadTask(),
                emptyMessage: "No Tasks Found",
              ),
      ),
    );
  }
}
