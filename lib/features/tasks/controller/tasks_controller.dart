import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky_app/core/services/file_storage_manager.dart';

import '../../../core/constants/storage_key.dart';
import '../../../core/services/preferences_manager.dart';
import '../../../model/task_model.dart';

class TasksController extends ChangeNotifier {
  bool isLoading = false;
  List<TaskModel> tasks = [];
  List<TaskModel> todoTasks = [];
  List<TaskModel> completeTasks = [];
  List<TaskModel> highPriorityTasks = [];

  int totalTasks = 0;
  int doneTasks = 0;
  double precent = 0;

  void init() {
    _loadTasks();
  }

  void _loadTasks() async {
    isLoading = true;

    final tasksList = await FileStorageManager().loadTasks();
      tasks = tasksList
          .map((element) => TaskModel.fromJson(element))
          .toList();

      _loadData();

      _calculatePrecent();

    isLoading = false;
    notifyListeners();
  }

  void _loadData() {
    todoTasks = tasks.where((e) => !e.isDone).toList();
    completeTasks = tasks.where((e) => e.isDone).toList();
    highPriorityTasks = tasks.where((e) => e.isHighPriority).toList();
    highPriorityTasks = highPriorityTasks.reversed.toList();
  }

  void doneTask(bool? value, int? id) async {
    final index = tasks.indexWhere((e) => e.id == id);
    tasks[index].isDone = value ?? false;

    _loadData();
    _calculatePrecent();

    /// dealing with the full list so when change isDone State will change in fullList
    /// on the contrary in todoScreen and completeScreen i need to know the actual index from fullList
    /// and index in the screenList and match them to update correct item
    final updatedTasksList = tasks.map((element) => element.toJson()).toList();
    await FileStorageManager().saveTasks(updatedTasksList);

    notifyListeners();
  }

  void deleteTask(int? id) async {
    if (id == null) return;

    tasks.removeWhere((e) => e.id == id);

    _loadData(); // to update data lists
    _calculatePrecent();

    final updatedTasks = tasks.map((e) => e.toJson()).toList();
    await FileStorageManager().saveTasks(updatedTasks);

    notifyListeners();
  }

  void _calculatePrecent() {
    totalTasks = tasks.length;
    doneTasks = tasks.where((e) => e.isDone).length;

    precent = totalTasks == 0 ? 0 : (doneTasks / totalTasks);

    notifyListeners();
  }

  void clearTasks() {
    _loadTasks();
  }


}
