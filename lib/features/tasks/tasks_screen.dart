import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tasky_app/core/services/preferences_manager.dart';
import 'package:tasky_app/model/task_model.dart';
import 'package:tasky_app/core/components/task_list_widget.dart';

import '../../core/constants/storage_key.dart';

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
    final finalTasks = PreferencesManager().getString(StorageKey.tasks);

    if (finalTasks != null) {
      final taskAfterDecode = jsonDecode(finalTasks) as List<dynamic>; // to covert string to List<Map<String, dynamic>>
      setState(() {
        todoTasks = taskAfterDecode
            .map(
              (element) => TaskModel.fromJson(element),
            ) // convert List<Map<String, dynamic>> to List<Model>
            .where(
              (element) => !element.isDone,
            ) // filter allDataList to get items which has isDone = false
            .toList();
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void _onTap (bool? value, int? index) async {
    setState(() {
      todoTasks[index!].isDone = value ?? false;
    });

    final allData = PreferencesManager().getString(StorageKey.tasks);
    // to update changed item not change all list
    if (allData != null) {
      List<TaskModel> allDataList =
      (jsonDecode(allData) as List)
          .map((element) => TaskModel.fromJson(element))
          .toList();
      final newIndex = allDataList.indexWhere(
            (e) => e.id == todoTasks[index!].id,
      );
      allDataList[newIndex] = todoTasks[index!];
      await PreferencesManager().setString(
        StorageKey.tasks,
        jsonEncode(allDataList),
      );
      // To update screen after check task
      _loadTask();
    }
  }

  void _deleteTask(int? id) async {
    List<TaskModel> tasks = [];
    final finalTasks = PreferencesManager().getString(StorageKey.tasks);
    if(finalTasks != null){
      final taskAfterDecode = jsonDecode(finalTasks) as List<dynamic>;
      tasks = taskAfterDecode.map((e) => TaskModel.fromJson(e)).toList();
      tasks.removeWhere((e) => e.id == id);

    setState(() {
      todoTasks.removeWhere((e) => e.id == id);
    });
    final updatedTasks = tasks.map((e) => e.toJson()).toList();
    await PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTasks));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              "To Do Tasks",
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Color(0xFFFFFCFC)),
                  )
                : TaskListWidget(
                    tasks: todoTasks,
                    onTap: (bool? value, int? index) => _onTap(value, index),
                    onDelete: (int? id) => _deleteTask(id),
                    onEdit: () => _loadTask(),
                    emptyMessage: "No Tasks Found",
                  ),
          ),
        ),
      ],
    );
  }
}
