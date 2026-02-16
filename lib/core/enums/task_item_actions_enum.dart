enum TaskItemActionsEnum{
  markAsDone(name: "Done | UnDone"),
  edit(name: "Edit"),
  delete(name : "Delete");


  final String name;

  const TaskItemActionsEnum({required this.name});

  /// Explanation
  // Create enum with two values (delete, edit) when i call its name it must be (delete, edit) in lowerCase as i wrote them,
  // but when create constructor of that class with name parameter this will override this names to given name in constructor
  // can add new enum without any problem it will be rendering normal using map and switch will give us error if missed any of them

}