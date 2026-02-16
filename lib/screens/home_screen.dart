import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky_app/core/services/preferences_manager.dart';
import 'package:tasky_app/core/widgets/custom_svg_picture.dart';
import 'package:tasky_app/model/task_model.dart';
import 'package:tasky_app/screens/add_task_screen.dart';
import 'package:tasky_app/widgets/achieved_task_widget.dart';
import 'package:tasky_app/widgets/high_priority_tasks_widget.dart';
import 'package:tasky_app/widgets/sliver_task_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username;
  List<TaskModel> tasks = [];
  bool isChecked = false;
  bool isLoading = false;
  int totalTasks = 0;
  int doneTasks = 0;
  double precent = 0;

  @override
  void initState() {
    super.initState();

    _loadUserName();
    _loadTasks();
  }

  void _loadUserName() async {
    setState(() {
      username = PreferencesManager().getString("username");
    });
  }

  void _loadTasks() async {
    setState(() {
      isLoading = true;
    });

    final tasksList = PreferencesManager().getString("tasks");

    if (tasksList != null) {
      final tasksListDecode = jsonDecode(tasksList) as List<dynamic>;
      setState(() {
        tasks = tasksListDecode
            .map((element) => TaskModel.fromJson(element))
            .toList();
        _calculatePrecent();
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void _calculatePrecent() {
    totalTasks = tasks.length;
    doneTasks = tasks.where((e) => e.isDone).length;

    precent = totalTasks == 0 ? 0 : (doneTasks / totalTasks);
  }

  void _doneTask(bool? value, int? index) async {
    setState(() {
      tasks[index!].isDone = value ?? false;
      _calculatePrecent();
    });

    /// dealing with the full list so when change isDone State will change in fullList
    /// on the contrary in todoScreen and completeScreen i need to know the actual index from fullList
    /// and index in the screenList and match them to update correct item
    final updatedTasksList = tasks.map((element) => element.toJson()).toList();
    await PreferencesManager().setString("tasks", jsonEncode(updatedTasksList));
  }

  void _deleteTask(int? id) {
    setState(() {
      tasks.removeWhere((task) => task.id == id);
      _calculatePrecent();
    });

    final updatedTasks = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString("tasks", jsonEncode(updatedTasks));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/images/person.png"),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good Evening ,$username",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            "One task at a time.One step closer.",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Yuhuu ,Your work Is",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Row(
                    children: [
                      Text(
                        "almost done ! ",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      CustomSvgPicture.withoutColor(
                        imagePath: "assets/images/waving_hand.svg",
                      ),
                    ],
                  ),
                  AchievedTaskWidget(
                    totalTasks: totalTasks,
                    doneTasks: doneTasks,
                    precent: precent,
                  ),
                  SizedBox(height: 8),
                  HighPriorityTasksWidget(
                    tasks: tasks,
                    onTap: (bool? value, int? index) {
                      _doneTask(value, index);
                    },
                    refresh: () {
                      _loadTasks();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 16),
                    child: Text(
                      "My Tasks",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFFFCFC),
                      ),
                    ),
                  )
                : SliverTaskListWidget(
                    tasks: tasks,
                    onTap: (bool? value, int? index) {
                      _doneTask(value, index);
                    },
                    onDelete: (int? id) {
                      _deleteTask(id);
                    },
                    onEdit: () => _loadTasks(),
                  ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 40,
        child: FloatingActionButton.extended(
          onPressed: () async {
            final bool? result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return AddTaskScreen();
                },
              ),
            );
            if (result != null && result) {
              _loadTasks();
            }
          },
          label: Text("Add New Task"),
          icon: Icon(Icons.add),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}
