import 'package:euclipse/constants/local_data_constants.dart';
import 'package:euclipse/models/assignmentsListData_Model.dart';
import 'package:euclipse/models/classSummary_Model.dart';
import 'package:euclipse/models/projectListData_Model.dart';
import 'package:euclipse/models/toDoListData_Model.dart';
import 'package:euclipse/models/userProfileData_Model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxes {
  static Box<String> getInitUserStatBox() => Hive.box(initUserStatusKey);
  static Box<UserProfileData> getUserProfileData() => Hive.box(userProfileData);
  static Box<ToDoListModel> getToDoListBox() => Hive.box(toDoListData);
  static Box<AssignmentListDataModel> getAssignmentsListBox() =>
      Hive.box(assignmentsListData);
  static Box<ProjecttListDataModel> getProjetcsListBox() =>
      Hive.box(projectListData);
  static Box<ClassSummaryDataModel> getClassSummaryDataBox() =>
      Hive.box(classSummaryData);
}
