import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../core/constants/storage_key.dart';
import '../../core/services/preferences_manager.dart';
import '../../model/task_model.dart';

class HomeController with ChangeNotifier {
  List<TaskModel> tasks = [];

  String? username;
  String? userImagePath;
  late String motivationQuote;
  bool isChecked = false;
  bool isLoading = false;
  int totalTasks = 0;
  int doneTasks = 0;
  double precent = 0;

  init() {
    loadUserData();
    loadTasks();
  }

  void loadUserData() async {
    username = PreferencesManager().getString(StorageKey.userName);
    userImagePath = PreferencesManager().getString(StorageKey.userImage);
    motivationQuote =
        PreferencesManager().getString(StorageKey.motivationQuote) ??
        "One task at a time. One step closer";

    notifyListeners();
  }

  void loadTasks() async {
    isLoading = true;

    final tasksList = PreferencesManager().getString(StorageKey.tasks);

    if (tasksList != null) {
      final tasksListDecode = jsonDecode(tasksList) as List<dynamic>;

      tasks = tasksListDecode
          .map((element) => TaskModel.fromJson(element))
          .toList();
      calculatePrecent();
    }
    isLoading = false;

    notifyListeners();
  }

  void calculatePrecent() {
    totalTasks = tasks.length;
    doneTasks = tasks.where((e) => e.isDone).length;

    precent = totalTasks == 0 ? 0 : (doneTasks / totalTasks);

    notifyListeners();
  }

  void doneTask(bool? value, int? index) async {
    tasks[index!].isDone = value ?? false;
    calculatePrecent();

    /// dealing with the full list so when change isDone State will change in fullList
    /// on the contrary in todoScreen and completeScreen i need to know the actual index from fullList
    /// and index in the screenList and match them to update correct item
    final updatedTasksList = tasks.map((element) => element.toJson()).toList();
    await PreferencesManager().setString(
      StorageKey.tasks,
      jsonEncode(updatedTasksList),
    );

    notifyListeners();
  }

  void deleteTask(int? id) {
    tasks.removeWhere((task) => task.id == id);
    calculatePrecent();

    final updatedTasks = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTasks));

    notifyListeners();
  }
}
