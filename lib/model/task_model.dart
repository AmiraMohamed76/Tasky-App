class TaskModel {
  final String taskName;
  final String taskDescription;
  final bool isHighPriority;
  bool isDone;

  TaskModel({
    required this.taskName,
    required this.taskDescription,
    required this.isHighPriority,
    this.isDone = false,
  });

  Map<String, dynamic> toJson() { // Can rename it to be toMap
    return {
      "taskName": taskName,
      "taskDescription": taskDescription,
      "isHighPriority": isHighPriority,
      "isDone": isDone,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json){
    return TaskModel(
      taskName: json['taskName'],
      taskDescription: json['taskDescription'],
      isHighPriority: json['isHighPriority'],
      isDone: json['isDone'] ?? false,
    );
  }
}
