import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/task_model.dart';
import '../widgets/task_list_widget.dart';

class CompleteTasksScreen extends StatefulWidget {
  const CompleteTasksScreen({super.key});

  @override
  State<CompleteTasksScreen> createState() => _CompleteTasksScreenState();
}

class _CompleteTasksScreenState extends State<CompleteTasksScreen> {
  bool isLoading = false;
  List<TaskModel> completedTasks = [];

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
      final taskDecoded = jsonDecode(finalTasks) as List<dynamic>;
      setState(() {
        completedTasks = taskDecoded
            .map((element) => TaskModel.fromJson(element))
            .where((element) => element.isDone == true)
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
          child: Text("Completed Tasks",
            style: TextStyle(
                color: Color(0xFFFFFCFC),
                fontSize: 20
            ),),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: Color(0xFFFFFCFC)))
                : TaskListWidget(
              tasks: completedTasks,
              onTap: (bool? value, int? index) async {
                setState(() {
                  completedTasks[index!].isDone = value ?? false;
                });
                final pref = await SharedPreferences.getInstance();
                final allData = pref.getString("tasks");

                if(allData != null){
                  final allDataList = (jsonDecode(allData) as List).map((element) => TaskModel.fromJson(element)).toList();
                  /// newIndex -> item index in fullList, index -> same item index but in completedList to update item in fullList
                  final newIndex = allDataList.indexWhere((e) => e.id == completedTasks[index!].id);
                  allDataList[newIndex] = completedTasks[index!];
                  await pref.setString("tasks", jsonEncode(allDataList));

                  // To update screen after check task
                  _loadTask();
                }
              },
              emptyMessage: "No Tasks Found",
            ),
          ),
        )

      ],
    );
  }
}
