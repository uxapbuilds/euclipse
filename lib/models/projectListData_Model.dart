import 'package:hive_flutter/hive_flutter.dart';

part 'projectListData_Model.g.dart';

@HiveType(typeId: 5)
class ProjecttListDataModel extends HiveObject {
  @HiveField(1)
  int taskId;

  @HiveField(2)
  String project;

  @HiveField(3)
  DateTime addedOn;

  @HiveField(4)
  DateTime deadline;

  @HiveField(5)
  bool isComplete;

  @HiveField(6)
  String description;

  @HiveField(7)
  Map<int, String> teamMembers;

  ProjecttListDataModel(
      {this.taskId = 0,
      this.project = '',
      this.description = '',
      required this.teamMembers,
      required this.addedOn,
      required this.deadline,
      this.isComplete = false});
}
