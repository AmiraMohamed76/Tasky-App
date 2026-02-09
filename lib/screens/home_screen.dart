import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky_app/model/task_model.dart';
import 'package:tasky_app/screens/add_task_screen.dart';
import 'package:tasky_app/widgets/task_list_widget.dart';

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

  @override
  void initState() {
    super.initState();

    _loadUserName();
    _loadTasks();
  }

  void _loadUserName() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("username");
    });
  }

  void _loadTasks() async {
    setState(() {
      isLoading = true;
    });

    final pref = await SharedPreferences.getInstance();
    final tasksList = pref.getString("tasks");

    if (tasksList != null) {
      final tasksListDecode = jsonDecode(tasksList) as List<dynamic>;
      print("Tasks $tasksListDecode");
      setState(() {
        tasks = tasksListDecode
            .map((element) => TaskModel.fromJson(element))
            .toList();

        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Color(0xFFFFFCFC),
                        ),
                      ),
                      Text(
                        "One task at a time.One step closer.",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFFC6C6C6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                "Yuhuu ,Your work Is",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFFFFCFC),
                ),
              ),
              Row(
                children: [
                  Text(
                    "almost done ! ",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFFFFCFC),
                    ),
                  ),
                  SvgPicture.asset("assets/images/waving_hand.svg"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 16),
                child: Text(
                  "My Tasks",
                  style: TextStyle(color: Color(0xFFFFFCFC), fontSize: 20),
                ),
              ),
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFFFCFC),
                        ),
                      )
                    : TaskListWidget(
                        tasks: tasks,
                        onTap: (bool? value, int? index) async {
                          setState(() {
                            tasks[index!].isDone = value ?? false;
                          });

                          // to save isDone in sharedPref
                          final pref = await SharedPreferences.getInstance();
                          final updatedTasksList = tasks
                              .map((element) => element.toJson())
                              .toList();
                          await pref.setString(
                            "tasks",
                            jsonEncode(updatedTasksList),
                          );
                        },
                      ),
              ),
            ],
          ),
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
          backgroundColor: Color(0xFF15B86C),
          foregroundColor: Color(0xFFFFFCFC),
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
