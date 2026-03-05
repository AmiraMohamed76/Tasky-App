import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileStorageManager {
  static final FileStorageManager _instance = FileStorageManager._();

  FileStorageManager._();

  factory FileStorageManager() {
    return _instance;
  }

  late final Directory _appDocumentsDirectory;
  late final File _tasksFile;

  init() async {
    _appDocumentsDirectory = await getApplicationDocumentsDirectory();
    _tasksFile = File("${_appDocumentsDirectory.path}/tasks.json");
  }

  saveTasks(List<dynamic> tasks) async {
    final tasksJson = jsonEncode(tasks);
    await _tasksFile.writeAsString(tasksJson);
  }

  Future<List<dynamic>> loadTasks() async {
    if(! await _tasksFile.exists())  return [];
    final list = await _tasksFile.readAsString();
    return jsonDecode(list) as List<dynamic>;
  }

  clear() async{
    if(! await _tasksFile.exists())  return;
    await _tasksFile.delete();
  }
}
