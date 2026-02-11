import 'package:flutter/material.dart';
import 'package:tasky_app/model/task_model.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({super.key, required this.tasks, required this.onTap, this.emptyMessage});

  final List<TaskModel> tasks;
  final Function(bool?, int?) onTap;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    print("Tasks ${tasks.isEmpty}");
    return  tasks.isEmpty
        ? Center(
      child: Text(
        emptyMessage ?? "No Data",
        style: TextStyle(fontSize: 24, color: Color(0xFFFFFCFC)),
      ),
    ) : ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      padding: EdgeInsets.only(bottom: 50),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 56,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFF282828),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 8),
                child: Checkbox(
                  value: tasks[index].isDone,
                  onChanged: (bool? value) async {
                    onTap(value, index);
                  },
                  activeColor: Color(0xFF15B86C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tasks[index].taskName,
                      style: TextStyle(
                        color: tasks[index].isDone
                            ? Color(0xFFA0A0A0)
                            : Color(0xFFFFFCFC),
                        fontSize: 16,
                        decoration: tasks[index].isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: Color(0xFFA0A0A0),
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    if (tasks[index].taskDescription.isNotEmpty)
                      Text(
                        tasks[index].taskDescription,
                        style: TextStyle(
                          color: Color(0xFFC6C6C6),
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_vert_outlined,
                  color: tasks[index].isDone
                      ? Color(0xFFA0A0A0)
                      : Color(0xFFFFFCFC),
                  size: 24,
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 8);
      },
    );
  }
}
