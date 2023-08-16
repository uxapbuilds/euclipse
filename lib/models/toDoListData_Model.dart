import 'package:hive_flutter/hive_flutter.dart';

import '../widgets/form_diags/todo_form_dialog.dart';

part 'toDoListData_Model.g.dart';

@HiveType(typeId: 3)
class ToDoListModel extends HiveObject {
  @HiveField(1)
  int taskId;

  @HiveField(2)
  String task;

  @HiveField(3)
  String taskPriority;

  @HiveField(4)
  DateTime addedOn;

  @HiveField(5)
  DateTime startTime;

  @HiveField(6)
  DateTime endTime;

  @HiveField(7)
  bool isComplete;

  @HiveField(8)
  String description;

  ToDoListModel(
      {this.taskId = 0,
      this.task = '',
      this.description = '',
      this.taskPriority = '',
      required this.addedOn,
      this.isComplete = false,
      required this.startTime,
      required this.endTime});
}
