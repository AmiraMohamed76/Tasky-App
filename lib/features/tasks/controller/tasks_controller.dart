import 'package:flutter/material.dart';
import '../../../core/services/hive_storage_manager.dart';
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

  void _loadTasks() {
    isLoading = true;

    tasks = HiveStorageManager().loadTasks();

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

    await HiveStorageManager().saveTasks(tasks);

    notifyListeners();
  }

  void deleteTask(int? id) async {
    if (id == null) return;

    tasks.removeWhere((e) => e.id == id);

    _loadData(); // to update data lists
    _calculatePrecent();

    await HiveStorageManager().saveTasks(tasks);

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
