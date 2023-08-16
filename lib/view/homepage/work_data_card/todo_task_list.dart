import 'package:euclipse/bloc/home_cubit/home_cubit.dart';
import 'package:euclipse/constants/colors.dart';
import 'package:euclipse/models/toDoListData_Model.dart';
import 'package:euclipse/utility/navigator.dart';
import 'package:euclipse/utility/utility.dart';
import 'package:euclipse/widgets/see_more.dart';
import 'package:euclipse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/form_diags/todo_form_dialog.dart';

class TaskList extends StatefulWidget {
  const TaskList({this.type = SeeMoreType.TASK, Key? key}) : super(key: key);
  final SeeMoreType type;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late HomeCubit _homeCubit;
  List<ToDoListModel> _currentDayTasks = [];
  bool isAscPriority = false;
  bool isAscEndTime = false;
  @override
  void initState() {
    super.initState();
    _homeCubit = BlocProvider.of<HomeCubit>(context, listen: false);
    loadCurrentTask();
  }

  @override
  void didUpdateWidget(covariant TaskList oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void loadCurrentTask() {
    var _currentday = DateTime.now().day;
    _currentDayTasks = _homeCubit.toDoDataList
        .where((task) => task.addedOn.day == _currentday)
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
          return ToDoDialog(
            preSelectedDate: DateTime.now(),
            lastIndex: _homeCubit.todoLastIndex,
          );
        }).then(
      (_) {
        loadCurrentTask();
        _homeCubit.updateProgressData();
      },
    );
  }

  void onDeleteTask(int i) {
    var id =
        _homeCubit.toDoDataList.indexWhere((element) => element.taskId == i);
    _homeCubit.removeTodo(id);
    _homeCubit.updateProgressData();
    loadCurrentTask();
  }

  void onComplete(int i) {
    /*
    TODO post sort complete action reverts the list back to original
    */
    var id =
        _homeCubit.toDoDataList.indexWhere((element) => element.taskId == i);
    _homeCubit.toDoDataList[id].isComplete =
        !_homeCubit.toDoDataList[id].isComplete;
    _homeCubit.updateTodoData(id);
    _homeCubit.updateProgressData();
  }

  bool onRemindTask(int i) {
    // var id =
    //     _homeCubit.toDoDataList.indexWhere((element) => element.taskId == i);
    return true;
  }

  Widget sortPopUpMenu(BuildContext context) {
    var _style = Theme.of(context)
        .textTheme
        .headline1!
        .copyWith(fontSize: 12, fontWeight: FontWeight.normal);
    return PopupMenuButton<int>(
      icon: Icon(
        Icons.sort,
        color: black,
      ),
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
      offset: const Offset(0, 00),
      color: Colors.white,
      elevation: 2,
      onSelected: (value) {
        if (value == 1) {
          if (isAscPriority) {
            _currentDayTasks.sort(((a, b) => mapPriorityToCode(a.taskPriority)
                .compareTo(mapPriorityToCode(b.taskPriority))));
            isAscPriority = !isAscPriority;
          } else {
            _currentDayTasks.sort(((a, b) => mapPriorityToCode(b.taskPriority)
                .compareTo(mapPriorityToCode(a.taskPriority))));
            isAscPriority = !isAscPriority;
          }
          _updateState();
        } else if (value == 2) {
          _currentDayTasks.sort(((a, b) => a.endTime.compareTo(b.endTime)));
          if (isAscEndTime) {
            _currentDayTasks.sort(((a, b) => a.endTime.compareTo(b.endTime)));
            isAscEndTime = !isAscEndTime;
          } else {
            _currentDayTasks.sort(((a, b) => b.endTime.compareTo(a.endTime)));
            isAscEndTime = !isAscEndTime;
          }
          _updateState();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, snapshot) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          contentActionBar(context,
              title: taskTypeString(widget.type),
              onAdd: () => onNewTask(),
              showSeeMore: _currentDayTasks.isNotEmpty,
              onSeeMore: () => Navigate().navigate(
                  SeeMorePage(
                    type: widget.type,
                  ),
                  context),
              trailling: Row(
                children: [
                  addButton(),
                  if (_currentDayTasks.isNotEmpty) sortPopUpMenu(context),
                ],
              )),
          const SizedBox(
            height: 8,
          ),
          _currentDayTasks.isEmpty
              ? Container(
                  margin: const EdgeInsets.only(
                      left: 0, right: 0, top: 8, bottom: 30),
                  child: emptyDataContainer(context,
                      hPadding: 0,
                      title:
                          'No ${taskTypeString(widget.type)} remaining\nfor today.',
                      width: MediaQuery.of(context).size.width),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _currentDayTasks
                        .asMap()
                        .map(
                          (index, _taskData) => MapEntry(
                            index,
                            todoContentCard(context, _taskData,
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
