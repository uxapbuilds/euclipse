import 'package:hive_flutter/hive_flutter.dart';

part 'assignmentsListData_Model.g.dart';

@HiveType(typeId: 4)
class AssignmentListDataModel extends HiveObject {
  @HiveField(1)
  int taskId;

  @HiveField(2)
  String assignment;

  @HiveField(3)
  DateTime addedOn;

  @HiveField(4)
  DateTime deadline;

  @HiveField(5)
  bool isComplete;

  @HiveField(6)
  String description;

  AssignmentListDataModel(
      {this.taskId = 0,
      this.assignment = '',
      this.description = '',
      required this.addedOn,
      required this.deadline,
      this.isComplete = false});
}
