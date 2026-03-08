import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:tasky_app/core/constants/storage_key.dart';
import 'package:tasky_app/model/task_model.dart';

class HiveStorageManager {
  static final HiveStorageManager _instance = HiveStorageManager._();

  HiveStorageManager._();

  factory HiveStorageManager() {
    return _instance;
  }

  late Box<TaskModel> _tasksBox;

  init() async {
   await Hive.initFlutter();
   Hive.registerAdapter(TaskModelAdapter());
   _tasksBox = await Hive.openBox<TaskModel>(StorageKey.tasks);
  }

  saveTasks(List<TaskModel> tasks) async {
    await _tasksBox.clear();
    await _tasksBox.addAll(tasks);
  }

  List<TaskModel> loadTasks()  {
    return _tasksBox.values.toList();
  }

  clear() async{
   await _tasksBox.clear();
  }
}
