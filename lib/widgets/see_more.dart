import 'dart:developer';
import 'dart:io';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:euclipse/bloc/home_cubit/home_cubit.dart';
import 'package:euclipse/constants/layout_constants.dart';
import 'package:euclipse/utility/navigator.dart';
import 'package:euclipse/widgets/form_diags/assignment_form_dialog.dart';
import 'package:euclipse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utility/utility.dart';
import 'form_diags/todo_form_dialog.dart';

// ignore: constant_identifier_names
enum SeeMoreType { TASK, ASSINGNMENT, PROJECTS }

class SeeMorePage extends StatefulWidget {
  const SeeMorePage({this.type = SeeMoreType.TASK, Key? key}) : super(key: key);

  final SeeMoreType type;

  @override
  State<SeeMorePage> createState() => _SeeMorePageState();
}

class _SeeMorePageState extends State<SeeMorePage> {
  late HomeCubit _homeCubit;
  var _selectedDate = DateTime.now();
  var _dataList = [];

  @override
  void initState() {
    super.initState();
    _homeCubit = BlocProvider.of<HomeCubit>(context, listen: false);
    loadData(widget.type);
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void onDeleteTask(int i) {
    if (widget.type == SeeMoreType.TASK) {
      var id =
          _homeCubit.toDoDataList.indexWhere((element) => element.taskId == i);
      _homeCubit.removeTodo(id);
    } else if (widget.type == SeeMoreType.ASSINGNMENT) {
      var id = _homeCubit.assignmentsDataList
          .indexWhere((element) => element.taskId == i);
      _homeCubit.removeAssignment(id);
    }
    loadData(widget.type);
    _homeCubit.updateProgressData();
  }

  void onComplete(int i) {
    if (widget.type == SeeMoreType.TASK) {
      var id =
          _homeCubit.toDoDataList.indexWhere((element) => element.taskId == i);
      _homeCubit.toDoDataList[id].isComplete =
          !_homeCubit.toDoDataList[id].isComplete;
      _homeCubit.updateTodoData(id);
    } else if (widget.type == SeeMoreType.ASSINGNMENT) {
      var id = _homeCubit.assignmentsDataList
          .indexWhere((element) => element.taskId == i);
      _homeCubit.assignmentsDataList[id].isComplete =
          !_homeCubit.assignmentsDataList[id].isComplete;
      _homeCubit.updateAssignmentData(id);
      _homeCubit.updateProgressData();
    }
  }

  void onNewTask() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18))),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          if (widget.type == SeeMoreType.TASK) {
            return ToDoDialog(
              preSelectedDate: _selectedDate,
              lastIndex: _homeCubit.todoLastIndex,
            );
          } else if (widget.type == SeeMoreType.ASSINGNMENT) {
            return AssignmentFormDialog(
              preSelectedDate: _selectedDate,
              lastIndex: _homeCubit.todoLastIndex,
            );
          }
          return Container();
        }).then(
      (_) {
        loadData(widget.type);
        _homeCubit.updateProgressData();
        _updateState();
      },
    );
  }

  bool onRemindTask(int i) {
    return true;
  }

  void loadData(SeeMoreType type) {
    switch (type) {
      case SeeMoreType.TASK:
        _dataList = _homeCubit.toDoDataList;
        break;
      case SeeMoreType.ASSINGNMENT:
        _dataList = _homeCubit.assignmentsDataList;
        break;
      case SeeMoreType.PROJECTS:
        _dataList = [];
        break;
      default:
        _dataList = [];
        break;
    }
    _dataList = _dataList
        .where((element) => widget.type == SeeMoreType.TASK
            ? element.addedOn.day == _selectedDate.day
            : element.deadline.day == _selectedDate.day)
        .toList();
  }

  Widget ifEmpty() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 38.0, vertical: 15),
            child: Text(
              'No ${taskTypeString(widget.type).toLowerCase()} for\nthis day.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
              onTap: () => onNewTask(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.type == SeeMoreType.TASK
                        ? 'Add Task'
                        : 'Add Assignment',
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 12),
                  ),
                  const Icon(
                    Icons.add,
                    size: 18,
                  )
                ],
              ))
        ],
      ),
    );
  }

  Widget _pageContent(List _data) {
    return ListView(
      // shrinkWrap: true,
      // childAspectRatio: widget.type == SeeMoreType.ASSINGNMENT
      //     ? mediaQuery.height * .00255
      //     : 1,
      // crossAxisCount: widget.type == SeeMoreType.TASK ? 2 : 1,
      children: _dataList
          // .where((element) => widget.type == SeeMoreType.TASK
          //     ? element.addedOn.day == _selectedDate.day
          //     : element.deadline.day == _selectedDate.day)
          // .toList()
          .asMap()
          .map((index, _taskData) => MapEntry(
              index,
              widget.type == SeeMoreType.TASK
                  ? todoContentCard(context, _taskData,
                      reminderActive: onRemindTask((_taskData).taskId),
                      onDelete: () => onDeleteTask((_taskData).taskId),
                      onComplete: () => onComplete((_taskData).taskId))
                  : assignmentContentCard(context, _taskData,
                      usePadding: false,
                      reminderActive: onRemindTask((_taskData).taskId),
                      onDelete: () => onDeleteTask((_taskData).taskId),
                      onComplete: () => onComplete((_taskData).taskId))))
          .values
          .toList(),
    );
  }

  @override
  void didUpdateWidget(covariant SeeMorePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var _textTheme = Theme.of(context).textTheme;
    var _mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.symmetric(
                  horizontal: horizontalPadding - 8) +
              EdgeInsets.only(
                  top: _mediaQuery.padding.top + (Platform.isAndroid ? 25 : 0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigate().popView(context),
                    child: const Icon(Icons.arrow_back_ios_new_outlined),
                  ),
                  const Spacer(),
                  Text(
                    widget.type == SeeMoreType.TASK
                        ? 'Tasks'
                        : widget.type == SeeMoreType.ASSINGNMENT
                            ? 'Assignments'
                            : widget.type == SeeMoreType.PROJECTS
                                ? 'Projects'
                                : '',
                    style: _textTheme.headline1!.copyWith(fontSize: 24),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: _dataList.isNotEmpty ? 0 : 24,
                  ),
                  if (_dataList.isNotEmpty)
                    InkWell(
                        onTap: () => onNewTask(), child: const Icon(Icons.add))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              DatePicker(
                DateTime.now(),
                initialSelectedDate: DateTime.now(),
                selectionColor: Colors.black,
                selectedTextColor: Colors.white,
                daysCount: 14,
                onDateChange: (date) {
                  _selectedDate = date;
                  // _updateState();
                  loadData(widget.type);
                  _updateState();
                },
              ),
              _dataList.isNotEmpty
                  ? Expanded(
                      child: _pageContent(_dataList
                          .where((element) => widget.type == SeeMoreType.TASK
                              ? element.addedOn.day == _selectedDate.day
                              : element.deadline.day == _selectedDate.day)
                          .toList()),
                    )
                  : ifEmpty()
            ],
          ),
        );
      }),
    );
  }
}
