import 'dart:developer';

import 'package:euclipse/constants/local_data_constants.dart';
import 'package:euclipse/models/assignmentsListData_Model.dart';
import 'package:euclipse/models/classSummary_Model.dart';
import 'package:euclipse/models/projectListData_Model.dart';
import 'package:euclipse/models/toDoListData_Model.dart';
import 'package:euclipse/models/userProfileData_Model.dart';
import 'package:euclipse/utility/get_hive_box.dart';

class LocalData {
  //==================== USER DATA MODIFICATION/RETRIEVAL =======================

  String? checkInitUserStatus() {
    var hiveBox = HiveBoxes.getInitUserStatBox();
    return hiveBox.get(initUserStatusKey);
  }

  int updateInitUserStatus({String status = ''}) {
    var hiveBox = HiveBoxes.getInitUserStatBox();
    try {
      hiveBox.put(initUserStatusKey, status);
      return 0; //SUCCESS
    } catch (_) {
      return 1; //FAILED
    }
  }

  int saveUserProfileData(UserProfileData data) {
    var hiveBox = HiveBoxes.getUserProfileData();
    try {
      hiveBox.put(0, data);
      // getUserProfileData();
      return 0;
    } catch (e) {
      log(e.toString());
      return 1;
    }
  }

  UserProfileData? getUserProfileData() {
    var hiveBox = HiveBoxes.getUserProfileData();
    try {
      UserProfileData? _data = hiveBox.getAt(0);
      return _data;
    } catch (e) {
      return null;
    }
  }

  int saveClassSummary(
      {required ClassSummaryDataModel data, required String date}) {
    var hiveBox = HiveBoxes.getClassSummaryDataBox();
    try {
      // save date in '1974-03-20 00:00:00.000' so it can later be parsed back to datetime
      hiveBox.put(date, data);
      return 0;
    } catch (e) {
      log(e.toString());
      return 1;
    }
  }

  //==================== DATA RETRIEVAL =======================

  List<ToDoListModel> getToDoListData() {
    var hiveBox = HiveBoxes.getToDoListBox();
    try {
      List<ToDoListModel> _list = [];
      Iterable<ToDoListModel> _data = hiveBox.values;
      for (ToDoListModel t in _data) {
        _list.add(t);
      }
      return _list;
    } catch (e) {
      log(e.toString() + ': todo');
      return [];
    }
  }

  List<AssignmentListDataModel> getAssignmentsListData() {
    var hiveBox = HiveBoxes.getAssignmentsListBox();
    try {
      List<AssignmentListDataModel> _list = [];
      Iterable<AssignmentListDataModel> _data = hiveBox.values;
      for (AssignmentListDataModel t in _data) {
        _list.add(t);
      }
      return _list;
    } catch (e) {
      log(e.toString() + ' : assignment');
      return [];
    }
  }

  List<ProjecttListDataModel> getProjectsListData() {
    var hiveBox = HiveBoxes.getProjetcsListBox();
    try {
      List<ProjecttListDataModel> _list = [];
      Iterable<ProjecttListDataModel> _data = hiveBox.values;
      for (ProjecttListDataModel t in _data) {
        _list.add(t);
      }
      return _list;
    } catch (e) {
      log(e.toString() + ' : assignment');
      return [];
    }
  }

  ClassSummaryDataModel? getClassSummaryByDate(String date) {
    var hiveBox = HiveBoxes.getClassSummaryDataBox();
    try {
      ClassSummaryDataModel? _data = hiveBox.get(date);
      if (_data != null) {
        return _data;
      }
      return null;
    } catch (e) {
      log(e.toString() + ': todo');
      return null;
    }
  }

  List<ClassSummaryDataModel> getAllClassSummary() {
    var hiveBox = HiveBoxes.getClassSummaryDataBox();
    try {
      Iterable<ClassSummaryDataModel> _dataList = [];
      _dataList = hiveBox.values;
      return _dataList.toList();
    } catch (e) {
      log(e.toString() + ': todo');
      return [];
    }
  }

  //==================== DATA MODIFICATION =======================

  List<AssignmentListDataModel> modifyAssignmentListData(int index,
      {AssignmentListDataModel? data,
      bool update = false,
      bool remove = false}) {
    var hiveBox = HiveBoxes.getAssignmentsListBox();
    try {
      if (update) {
        hiveBox.putAt(index, data!);
      } else if (remove) {
        hiveBox.deleteAt(index);
      } else {
        hiveBox.put(index, data!);
      }
      return getAssignmentsListData();
    } catch (e) {
      log(e.toString() + 'h');
      return [];
    }
  }

  List<ToDoListModel> modifyToDoListData(int index,
      {ToDoListModel? data, bool update = false, bool remove = false}) {
    var hiveBox = HiveBoxes.getToDoListBox();
    try {
      if (update) {
        hiveBox.putAt(index, data!);
      } else if (remove) {
        hiveBox.deleteAt(index);
      } else {
        hiveBox.put(index, data!);
      }
      return getToDoListData();
    } catch (e) {
      log(e.toString() + 'h');
      return [];
    }
  }

  List<ProjecttListDataModel> modifyProjectsListData(int index,
      {ProjecttListDataModel? data, bool update = false, bool remove = false}) {
    var hiveBox = HiveBoxes.getProjetcsListBox();
    try {
      if (update) {
        hiveBox.putAt(index, data!);
      } else if (remove) {
        hiveBox.deleteAt(index);
      } else {
        hiveBox.put(index, data!);
      }
      return getProjectsListData();
    } catch (e) {
      log(e.toString() + 'h');
      return [];
    }
  }

  int modifyClassSummaryDataByDate(
      {required ClassSummaryDataModel data, required String date}) {
    var hiveBox = HiveBoxes.getClassSummaryDataBox();
    try {
      // if (hiveBox.containsKey(date)) {
      hiveBox.put(date, data);
      // return 0;
      // } else {
      //   return 1;
      // }
      return 0;
    } catch (e) {
      log(e.toString() + 'h');
      return 1;
    }
  }
}
