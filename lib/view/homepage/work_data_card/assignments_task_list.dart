import 'dart:developer';

import 'package:euclipse/bloc/home_cubit/home_cubit.dart';
import 'package:euclipse/constants/colors.dart';
import 'package:euclipse/models/assignmentsListData_Model.dart';
import 'package:euclipse/models/toDoListData_Model.dart';
import 'package:euclipse/utility/navigator.dart';
import 'package:euclipse/utility/utility.dart';
import 'package:euclipse/widgets/form_diags/assignment_form_dialog.dart';
import 'package:euclipse/widgets/see_more.dart';
import 'package:euclipse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignmentsList extends StatefulWidget {
  const AssignmentsList({this.type = SeeMoreType.ASSINGNMENT, Key? key})
      : super(key: key);
  final SeeMoreType type;

  @override
  State<AssignmentsList> createState() => _TaskListState();
}

class _TaskListState extends State<AssignmentsList> {
  late HomeCubit _homeCubit;
  List<AssignmentListDataModel> _currentTasks = [];
  bool isAscPriority = false;
  bool isAscEndTime = false;
  @override
  void initState() {
    super.initState();
    _homeCubit = BlocProvider.of<HomeCubit>(context, listen: false);
    loadCurrentTasks();
  }

  @override
  void didUpdateWidget(covariant AssignmentsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadCurrentTasks();
  }

  void loadCurrentTasks() {
    // var _sevenDays = DateTime.now().add(const Duration(days: 7)).day;
    _currentTasks = _homeCubit.assignmentsDataList
        .where((task) =>
            // task.deadline.day <= _sevenDays &&
            task.deadline.day >= DateTime.now().day)
        .toList();
  }

  void onNewTask() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18))),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return AssignmentFormDialog(
            preSelectedDate: DateTime.now(),
            lastIndex: _homeCubit.assignmentLastIndex,
          );
        }).then(
      (_) {
        loadCurrentTasks();
        _homeCubit.updateProgressData();
      },
    );
  }

  void onDeleteTask(int i) {
    var id = _homeCubit.assignmentsDataList
        .indexWhere((element) => element.taskId == i);
    _homeCubit.removeAssignment(id);
    loadCurrentTasks();
    _homeCubit.updateProgressData();
  }

  void onComplete(int i) {
    /*
    TODO post sort complete action reverts the list back to original
    */
    var id = _homeCubit.assignmentsDataList
        .indexWhere((element) => element.taskId == i);
    _homeCubit.assignmentsDataList[id].isComplete =
        !_homeCubit.assignmentsDataList[id].isComplete;
    _homeCubit.updateAssignmentData(id);
    _homeCubit.updateProgressData();
  }

  bool onRemindTask(int i) {
    // var id =
    //     _homeCubit.assignmentsDataList.indexWhere((element) => element.taskId == i);
    return true;
  }

  Widget sortPopUpMenu(BuildContext context) {
    var _style = Theme.of(context)
        .textTheme
        .headline1!
        .copyWith(fontSize: 12, fontWeight: FontWeight.normal);
    return PopupMenuButton<int>(
      icon: const Icon(Icons.sort),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(isAscPriority ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              Text(
                "Sort by priority",
                style: _style,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(isAscEndTime ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              Text(
                "Sort by time",
                style: _style,
              )
            ],
          ),
        ),
      ],
      offset: const Offset(0, 40),
      color: Colors.white,
      elevation: 2,
      onSelected: (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, snapshot) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          contentActionBar(context,
              selectedIndex: _homeCubit.selectedTaskIndex,
              title: taskTypeString(widget.type),
              onAdd: () => onNewTask(),
              showSeeMore: _currentTasks.isNotEmpty,
              onSeeMore: () => Navigate().navigate(
                  SeeMorePage(
                    type: widget.type,
                  ),
                  context),
              trailling: Row(
                children: [
                  addButton(),
                  // sortPopUpMenu(context),
                ],
              )),
          const SizedBox(
            height: 8,
          ),
          _currentTasks.isEmpty
              ? Container(
                  margin: const EdgeInsets.only(
                      left: 0, right: 0, top: 8, bottom: 30),
                  child: emptyDataContainer(context,
                      hPadding: 0,
                      title: 'No ${taskTypeString(widget.type)} remaining.',
                      width: MediaQuery.of(context).size.width),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _currentTasks
                        .asMap()
                        .map(
                          (index, _taskData) => MapEntry(
                            index,
                            assignmentContentCard(context, _taskData,
                                reminderActive:
                                    onRemindTask((_taskData).taskId),
                                onDelete: () =>
                                    onDeleteTask((_taskData).taskId),
                                onComplete: () =>
                                    onComplete((_taskData).taskId)),
                          ),
                        )
                        .values
                        .toList(),
                  ),
                )
        ],
      );
    });
  }
}
