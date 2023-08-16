// ignore_for_file: prefer_final_fields
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:euclipse/models/assignmentsListData_Model.dart';
import 'package:euclipse/models/projectListData_Model.dart';
import 'package:euclipse/models/subjectDetail_Model.dart';
import 'package:euclipse/models/timeTable_Model.dart';
import 'package:euclipse/models/toDoListData_Model.dart';
import 'package:euclipse/models/userProfileData_Model.dart';
import 'package:euclipse/utility/local_data.dart';
import 'package:euclipse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utility/utility.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeInitial());

  //VARS
  late UserProfileData _userData = UserProfileData('', '', '', '', '', []);
  late List<TimeTableModel> _timeTableDataList = [];
  late List<SubjectDetailsModel> _subjectsOfToday = [];
  late TimeTableModel _timeTableData;
  late bool _showClassSummary = false;
  late List<ToDoListModel> _toDoDataList = [];
  late List<AssignmentListDataModel> _assignmentsDataList = [];
  late List<ProjecttListDataModel> _projectsDataList = [];
  late int _selectedTaskIndex = 0;
  late Map<String, Map<String, int>> _progressData = {
    'todo': {'total': 0, 'completed': 0},
    'assignments': {'total': 0, 'completed': 0},
    'projects': {'total': 0, 'completed': 0}
  };
  late int _todolastIndex;
  late int _assignmentLastIndex;
  late int _projectLastIndex;
  late int _subjectDuration = 0;
  late int _subjectEndsIn = 0;
  late int _subjectStartsIn = 1440;
  late SubjectDetailsModel _ongoingSub = SubjectDetailsModel();
  late SubjectDetailsModel _upcomingSubject = SubjectDetailsModel();
  late bool _inSession = false;
  late bool _isDayOff = false;
  DateTime _subjectStartTime = DateTime.now();
  DateTime _subjectEndTime = DateTime.now();
  List _startTimeSplit = [];
  List _endTimeSplit = [];

  //GETTERS
  UserProfileData get userData => _userData;
  List<TimeTableModel> get timeTableDataList => _timeTableDataList;
  TimeTableModel get timeTableData => _timeTableData;
  List<SubjectDetailsModel> get subjectsOfToday => _subjectsOfToday;
  List<ToDoListModel> get toDoDataList => _toDoDataList;
  List<AssignmentListDataModel> get assignmentsDataList => _assignmentsDataList;
  List<ProjecttListDataModel> get projectsDataList => _projectsDataList;
  SubjectDetailsModel get ongoingSubject => _ongoingSub;
  SubjectDetailsModel get upcomingSubject => _upcomingSubject;
  Map<String, Map<String, int>> get progressData => _progressData;
  int get selectedTaskIndex => _selectedTaskIndex;
  int get todoLastIndex => _todolastIndex;
  int get subjectEndIn => _subjectEndsIn;
  int get nextSubStartsIn => _subjectStartsIn;
  int get assignmentLastIndex => _assignmentLastIndex;
  int get projecttLastIndex => _projectLastIndex;
  bool get showClassSummary => _showClassSummary;
  bool get isDayOff => _isDayOff;

  //=============== USER DATA MODIFICATION/RETRIEVAL ===============

  void getUserData() {
    emit(const HomeUpdating());
    _userData = LocalData().getUserProfileData()!;
    _timeTableDataList = _userData.timeTableData;
    emit(const HomeUpdated());
  }

  void updateUserInfo() {
    var _res = LocalData().saveUserProfileData(_userData);
    if (_res == 0) {
      makeToast('Done!');
    } else {
      makeToast('error');
    }
  }

  //=============== DATA RETRIEVAL ===============

  void retrieveData() {
    emit(const HomeUpdating());
    getUserData();
    getClasses(DateTime.now());
    getToDoData();
    getAssignmentsData();
    getProjectsData();
    updateProgressData();
    emit(const HomeUpdated());
  }

  void getToDoData() {
    // emit(const HomeUpdating());
    _toDoDataList = LocalData().getToDoListData();
    _todolastIndex =
        _toDoDataList.isNotEmpty ? _toDoDataList.last.taskId + 1 : 1;
    // emit(const HomeUpdated());
  }

  void getAssignmentsData() {
    // emit(const HomeUpdating());
    _assignmentsDataList = LocalData().getAssignmentsListData();
    _assignmentLastIndex = _assignmentsDataList.isNotEmpty
        ? _assignmentsDataList.last.taskId + 1
        : 1;
    // emit(const HomeUpdated());
  }

  void getProjectsData() {
    // emit(const HomeUpdating());
    _projectsDataList = LocalData().getProjectsListData();
    _projectLastIndex =
        _projectsDataList.isNotEmpty ? _projectsDataList.last.taskId + 1 : 1;
    // emit(const HomeUpdated());
  }

  void getClasses(DateTime currentDateTime) {
    emit(const HomeUpdating());
    _ongoingSub = SubjectDetailsModel();
    _upcomingSubject = SubjectDetailsModel();
    var day = DateFormat('EEEE').format(currentDateTime);
    getUserData();
    if (_timeTableDataList.isNotEmpty) {
      //GET BY DAY
      List<TimeTableModel> _byDay = _timeTableDataList.where((element) {
        return mapDayCharToFullWord(element.day, addShortForm: false)
                .trim()
                .toLowerCase() ==
            'monday';
        // day.toLowerCase();
      }).toList();
      if (_byDay.isNotEmpty) {
        _subjectsOfToday = _byDay.first.subjectList!;
        //SORT
        if (_subjectsOfToday.isNotEmpty) {
          _isDayOff =
              _subjectsOfToday.length == 1 && _subjectsOfToday[0].isDayOff
                  ? true
                  : false;
          _subjectsOfToday.sort((a, b) => timeToInt(TimeOfDay.fromDateTime(
                  DateFormat('HH:mm aa').parse(a.startTime)))
              .compareTo(timeToInt(TimeOfDay.fromDateTime(
                  DateFormat('HH:mm aa').parse(b.startTime)))));
        }
      }
    }
    getOngoingClassData();
    emit(const HomeUpdated());
  }

  void getOngoingClassData() {
    _subjectStartsIn = 1440;
    emit(const HomeUpdating());
    // late DateTime now = DateTime.now();
    late DateTime _now =
        DateTime.now(); //DateTime(now.year, now.month, now.day, 24, 56);
    if (_subjectsOfToday.isNotEmpty) {
      if (!_subjectsOfToday[0].isDayOff) {
        //_subjectsOfToday.length != 1 &&
        _inSession = false;
        _showClassSummary = false;
        _upcomingSubject = SubjectDetailsModel();
        _ongoingSub = SubjectDetailsModel();
        for (var _subject in _subjectsOfToday) {
          var _startTimeSplit = _subject.startTime.trim().split(' ');
          var _endTimeSplit = _subject.endTime.trim().split(' ');

          var _isStartBeforeTwelve =
              _startTimeSplit[1].toLowerCase() == 'am' ? true : false;
          var _isEndBeforeTwelve =
              _endTimeSplit[1].toLowerCase() == 'am' ? true : false;

          // DateTime _subjectStartTime = DateTime.now();
          // DateTime _subjectEndTime = DateTime.now();

          // List _startTimeSplit = _subject.startTime.split(' ')[0].split(':');
          // List _endTimeSplit = _subject.endTime.split(' ')[0].split(':');
          var _startTimeSplitA = _startTimeSplit[0].split(':');
          var _endTimeSplitA = _endTimeSplit[0].split(':');
          // log(_startTimeSplit[0].toString() +
          //     " : " +
          //     _endTimeSplit[0].toString());

          _subjectStartTime = DateTime(
              _now.year,
              _now.month,
              _now.day,
              (int.parse(_startTimeSplitA[0]) +
                  (_isStartBeforeTwelve || int.parse(_startTimeSplitA[0]) == 12
                      ? 0
                      : 12)),
              int.parse(_startTimeSplitA[1]));

          _subjectEndTime = DateTime(
              _now.year,
              _now.month,
              _now.day,
              (int.parse(_endTimeSplitA[0]) +
                  (_isEndBeforeTwelve || int.parse(_endTimeSplitA[0]) == 12
                      ? 0
                      : 12)),
              int.parse(_endTimeSplitA[1]));

          // log('${_subject.startTime} : ${_subject.endTime}');
          // log('${_subjectStartTime.toString()} : ${_subjectEndTime.toString()}');
          // ignore: unnecessary_null_comparison
          if (_subjectStartTime != null && _subjectEndTime != null) {
            _subjectDuration =
                _subjectEndTime.difference(_subjectStartTime).inMinutes;
            // log('SUBJECT DURATION : ' + _subjectDuration.toString());

            var _remainingSubjectDuration = _now.isAfter(_subjectStartTime)
                ? _subjectEndTime.difference(_now).inMinutes > 0
                    ? _subjectEndTime.difference(_now).inMinutes
                    : 0
                : 0;
            // log('REMAINING DURATION: ' + _remainingSubjectDuration.toString());
            // log('${_subject.subjectName} - TIMECHECK:\nSUB START TIME - ${_subjectStartTime.toString()},\nSUB END TIME - ${_subjectEndTime.toString()},\n##CURRENT TIME - ${_now.toString()}\nSUB ENDS IN - ${_subEndInDateTime.toString()}');

            if (_now.isAfter(_subjectStartTime) &&
                _now.isBefore(_subjectEndTime) &&
                _remainingSubjectDuration > 0) {
              // log('#@ st' + _subjectStartTime.toString());
              _inSession = true;
              _ongoingSub = _subject;
              _subjectEndsIn = _remainingSubjectDuration;
            }

            if (_subjectStartTime.isAfter(_now) &&
                _subjectEndTime.isAfter(_now) &&
                _remainingSubjectDuration == 0) {
              // log('#@ et' +
              //     _subjectStartTime.toString() +
              //     " : " +
              //     _subject.subjectName);
              // print(_subject.subjectName);
              if (_upcomingSubject.subjectName.isEmpty) {
                _upcomingSubject = _subject;
                var startIn = _subjectStartTime.difference(_now).inMinutes > 0
                    ? _subjectStartTime.difference(_now).inMinutes
                    : 0;
                // log('STARTINCALC: $startIn, sub: ${_subject.subjectName}');
                _subjectStartsIn =
                    _subjectStartsIn < startIn ? _subjectStartsIn : startIn;
              }
            }

            // log('-----------------------------------');
            // log('REST: IN SESSION - $_inSession, ONGOINGSUB - ${_subject.subjectName}, SUBJECT ENDS IN - $_subjectEndsIn, FISRT START IN - $_firstStartIn\n-------------------------------------');
          }
          // log('REST: IN SESSION - $_inSession, SUBJECT - ${_subject.subjectName}, SUBJECT ENDS IN - $_subjectEndsIn, FISRT START IN - $_firstStartIn');
        }

        // log(DateTime(now.year, now.month, now.day, 24, 0)
        //         .difference(_now)
        //         .inMinutes
        //         .toString() +
        //     ' : ' +
        //     _subjectStartsIn.toString() +
        //     ' : subname:' +
        //     _upcomingSubject.subjectName);

        // log('SUBDETAILS: insession - $_inSession, ONGOINGSUB - ${_ongoingSub != null ? _ongoingSub!.subjectName : 'NONE'}, UPCOMINGSUB - ${_upcomingSubject != null ? _upcomingSubject!.subjectName : 'NONE'}, SUBJECT ENDS IN - $_subjectEndsIn, FISRT START IN - $_firstStartIn');
        // log('-----------------------\n----------------------\nFINAL: IN SESSION - $_inSession, FISRT START IN - $_firstStartIn\n');
        // log('TEST: ${DateTime(now.year, now.month, now.day, 24, 0).difference(_now).inMinutes} : ${_subjectStartsIn}');
        // if (_inSession && _ongoingSub.subjectName.isNotEmpty) {
        //   // log('####################### A SUBJECT IS IN SESSION ####################### ${_ongoingSub.subjectName} : ${_upcomingSubject.subjectName} ${_subjectStartsIn}');
        // } else if (!_inSession &&
        //     _subjectStartsIn > 0 &&
        //     DateTime(now.year, now.month, now.day, 24, 0)
        //             .difference(_now)
        //             .inMinutes >
        //         _subjectStartsIn &&
        //     _upcomingSubject.subjectName.isNotEmpty) {
        //   // log('####################### A SUBJECT IS ABOUT TO START ####################### ${_ongoingSub.subjectName} : ${_upcomingSubject.subjectName} ${_subjectStartsIn}');
        // } else
        if (!_inSession &&
            DateTime(_now.year, _now.month, _now.day, 24, 0)
                    .difference(_now)
                    .inMinutes <
                _subjectStartsIn &&
            _upcomingSubject.subjectName.isEmpty) {
          // log('####################### CLASSES HAVE ENDED FOR TODAY (SHOW SUMMARY) #######################');
          _showClassSummary = true;
        }
      }
    }
    emit(const HomeUpdating());
  }

  //=============== DATA MODIFICATION (ADD) ===============

  void updateProgressData() {
    emit(const HomeUpdating());
    if (_progressData.containsKey('todo')) {
      var _list = _toDoDataList
          .where((task) => task.addedOn.day == DateTime.now().day)
          .toList();
      _progressData['todo']?['total'] = _list.length;
      _progressData['todo']?['completed'] =
          _list.where((element) => element.isComplete).toList().length;
    }
    if (_progressData.containsKey('assignments')) {
      var _list = _assignmentsDataList
          .where((task) =>
              // task.deadline.day <= DateTime.now().day + 7 &&
              task.addedOn.day >= DateTime.now().day)
          .toList();
      _progressData['assignments']?['total'] = _list.length;
      _progressData['assignments']?['completed'] =
          _list.where((element) => element.isComplete).toList().length;
    }
    if (_progressData.containsKey('projects')) {
      _progressData['projects']?['total'] = _projectsDataList.length;
      _progressData['projects']?['completed'] = _projectsDataList
          .where((element) => element.isComplete)
          .toList()
          .length;
    }
    emit(const HomeUpdated());
  }

  void updateTaskIndex(int i) {
    emit(const HomeUpdating());
    _selectedTaskIndex = i;
    emit(const HomeUpdated());
  }

  void addToDo(int index, ToDoListModel data) {
    emit(const HomeUpdating());
    _toDoDataList = LocalData().modifyToDoListData(index, data: data);
    _todolastIndex = _toDoDataList.last.taskId + 1;
    emit(const HomeUpdated());
  }

  void addAssignment(int index, AssignmentListDataModel data) {
    emit(const HomeUpdating());
    _assignmentsDataList =
        LocalData().modifyAssignmentListData(index, data: data);
    _assignmentLastIndex = _assignmentsDataList.last.taskId + 1;
    emit(const HomeUpdated());
  }

  void addProject(int index, ProjecttListDataModel data) {
    emit(const HomeUpdating());
    _projectsDataList = LocalData().modifyProjectsListData(index, data: data);
    _projectLastIndex = _projectsDataList.last.taskId + 1;
    emit(const HomeUpdated());
  }

  //=============== DATA MODIFICATION (UPDATE) ===============

  void updateTodoData(int index) {
    emit(const HomeUpdating());
    _toDoDataList = LocalData()
        .modifyToDoListData(index, data: _toDoDataList[index], update: true);
    // _lastIndex = _toDoDataList.isNotEmpty ? _toDoDataList.last.taskId : 1;
    emit(const HomeUpdated());
  }

  void updateAssignmentData(int index) {
    emit(const HomeUpdating());
    _assignmentsDataList = LocalData().modifyAssignmentListData(index,
        data: _assignmentsDataList[index], update: true);
    // _lastIndex = _toDoDataList.isNotEmpty ? _toDoDataList.last.taskId : 1;
    emit(const HomeUpdated());
  }

  void updateProjectData(int index) {
    emit(const HomeUpdating());
    _projectsDataList = LocalData().modifyProjectsListData(index,
        data: _projectsDataList[index], update: true);
    // _lastIndex = _toDoDataList.isNotEmpty ? _toDoDataList.last.taskId : 1;
    emit(const HomeUpdated());
  }

  //=============== DATA MODIFICATION (REMOVE) ===============

  void removeTodo(int index) {
    emit(const HomeUpdating());
    _toDoDataList = LocalData().modifyToDoListData(index, remove: true);
    _todolastIndex =
        _toDoDataList.isNotEmpty ? _toDoDataList.last.taskId + 1 : 1;
    emit(const HomeUpdated());
  }

  void removeAssignment(int index) {
    emit(const HomeUpdating());
    _assignmentsDataList =
        LocalData().modifyAssignmentListData(index, remove: true);
    _assignmentLastIndex = _assignmentsDataList.isNotEmpty
        ? _assignmentsDataList.last.taskId + 1
        : 1;
    emit(const HomeUpdated());
  }

  void removeProject(int index) {
    emit(const HomeUpdating());
    _projectsDataList = LocalData().modifyProjectsListData(index, remove: true);
    _projectLastIndex =
        _projectsDataList.isNotEmpty ? _projectsDataList.last.taskId + 1 : 1;
    emit(const HomeUpdated());
  }

  void update() {
    emit(const HomeUpdating());
    // print('home upadted ${_subjectEndsIn} : ${_subjectStartsIn}');
    emit(const HomeUpdated());
  }
}
