import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../core/constants/storage_key.dart';
import '../../../core/services/preferences_manager.dart';
import '../../../model/task_model.dart';

class AddTaskController extends ChangeNotifier {
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();

  bool isHighPriority = true;

  void addTask(BuildContext context) async {
    if (key.currentState?.validate() ?? false) {
      // check by key {tasks} -> String?
      final taskJson = PreferencesManager().getString(StorageKey.tasks);

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
      await PreferencesManager().setString(StorageKey.tasks, tasksListEncode);

      // navigation with result (true) value to check on this result on HomeScreen to check if add task will loadTasks again to update list
      if(!context.mounted) return;
      Navigator.of(context).pop(true);
    }

  }

  void priorityToggle(bool value) {
    isHighPriority = value;
    notifyListeners();
  }
}
