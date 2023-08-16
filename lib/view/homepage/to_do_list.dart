// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';
import 'package:euclipse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/home_cubit/home_cubit.dart';
import '../../constants/colors.dart';

/*

unused class


*/

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  int _currentSortColumn = 0;
  bool _isSortAsc = false;
  // List<bool> _selected = [];
  late HomeCubit _homeCubit;

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  List<DataColumn> _columns() {
    return [
      DataColumn(
        label: Text('ID'),
        onSort: (columnIndex, _) {
          _currentSortColumn = columnIndex;
          if (!_isSortAsc) {
            _homeCubit.toDoDataList
                .sort((a, b) => b.taskId.compareTo(a.taskId));
          } else {
            _homeCubit.toDoDataList
                .sort((a, b) => a.taskId.compareTo(b.taskId));
          }
          _isSortAsc = !_isSortAsc;
          _updateState();
        },
      ),
      DataColumn(label: Text('Todo..')),
      DataColumn(
        label: Text('Priority'),
        // onSort: (columnIndex, _) {
        //   _currentSortColumn = columnIndex;
        //   if (!_isSortAsc) {
        //     _homeCubit.toDoDataList
        //         .sort((a, b) => b.taskPriority.compareTo(a.taskPriority));
        //   } else {
        //     _homeCubit.toDoDataList
        //         .sort((a, b) => a.taskPriority.compareTo(b.taskPriority));
        //   }
        //   _isSortAsc = !_isSortAsc;
        //   _updateState();
        // },
      ),
      DataColumn(
          label: Text('Added On'),
          onSort: (columnIndex, _) {
            _currentSortColumn = columnIndex;
            if (!_isSortAsc) {
              _homeCubit.toDoDataList
                  .sort((a, b) => b.addedOn.compareTo(a.addedOn));
            } else {
              _homeCubit.toDoDataList
                  .sort((a, b) => a.addedOn.compareTo(b.addedOn));
            }
            _isSortAsc = !_isSortAsc;
            _updateState();
          }),
      DataColumn(label: Text('Remove'))
    ];
  }

  List<DataRow> _rows() {
    double _paddingH = 3;
    return _homeCubit.toDoDataList
        .asMap()
        .map((i, task) => MapEntry(
            i,
            DataRow(
                selected: _homeCubit.toDoDataList[i].isComplete,
                onSelectChanged: (b) => onUpdateStatus(i, b as bool),
                onLongPress: () {},
                cells: [
                  DataCell(Padding(
                    padding: EdgeInsets.symmetric(horizontal: _paddingH),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '#' + task.taskId.toString(),
                          style:
                              Theme.of(context).textTheme.headline2!.copyWith(
                                    fontSize: 15,
                                    color: black,
                                  ),
                        ),
                      ],
                    ),
                  )),
                  DataCell(Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: _paddingH, vertical: 5),
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 60, minWidth: 60),
                        child: Text(
                          task.task,
                          style:
                              Theme.of(context).textTheme.headline2!.copyWith(
                                    fontSize: 15,
                                    color: black,
                                  ),
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  )),
                  DataCell(
                    getPriorityWidget(task.taskPriority),
                  ),
                  DataCell(Padding(
                    padding: EdgeInsets.symmetric(horizontal: _paddingH),
                    child: Text(task.addedOn.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                              fontSize: 15,
                              color: black,
                            )),
                  )),
                  DataCell(Padding(
                    padding: EdgeInsets.symmetric(horizontal: _paddingH),
                    child: IconButton(
                        onPressed: () => onDeleteTask(i),
                        icon: Icon(
                          Icons.delete,
                          color: primaryColor,
                          size: 19,
                        )),
                  ))
                ])))
        .values
        .toList();
  }

  Widget getPriorityWidget(String priority) {
    Color? bcg = priorityColorMap[priority.toLowerCase()];
    return Center(
      child: Text(
        priority,
        style: Theme.of(context).textTheme.headline2!.copyWith(
            shadows: [Shadow(color: black, offset: Offset(0, -5))],
            decoration: TextDecoration.underline,
            decorationColor: bcg,
            decorationThickness: 2,
            decorationStyle: TextDecorationStyle.solid,
            color: Colors.transparent,
            fontSize: 15),
      ),
    );
  }

  void onUpdateStatus(int i, bool b) {
    _homeCubit.toDoDataList[i].isComplete =
        !_homeCubit.toDoDataList[i].isComplete;
    _homeCubit.updateTodoData(i);
    _updateState();
  }

  void onSelectAll(bool b) {
    _homeCubit.toDoDataList.asMap().forEach((index, task) {
      task.isComplete = b;
      _homeCubit.updateTodoData(index);
      _updateState();
    });
  }

  // void onNewTask() {
  //   showModalBottomSheet(
  //       shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(18), topRight: Radius.circular(18))),
  //       isScrollControlled: true,
  //       context: context,
  //       builder: (context) {
  //         return ToDoDialog(
  //           lastIndex: _homeCubit.lastIndex,
  //         );
  //       }).then((_) => _updateState());
  // }

  void onDeleteTask(int i) {
    _homeCubit.removeTodo(i);
    _updateState();
  }

  @override
  void initState() {
    super.initState();
    _homeCubit = BlocProvider.of<HomeCubit>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context).size;
    var _textTheme = Theme.of(context).textTheme;
    var _style = Theme.of(context)
        .textTheme
        .headline1!
        .copyWith(fontSize: 18, color: black);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  children: [
                    Text(
                      'Todo List',
                      style: _style,
                    ),
                    Container(
                      height: 30,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.2),
                              blurRadius: 4,
                              spreadRadius: .2)
                        ],
                      ),
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.add,
                            size: 14,
                          )),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: _homeCubit.toDoDataList.isEmpty
                    ? emptyDataContainer(
                        context,
                        height: 160,
                        hPadding: 0,
                        width: _mediaQuery.width,
                        libIcon: Icon(
                          Icons.book_outlined,
                          color: primaryColor,
                        ),
                        title: 'No Tasks\nRemaining.',
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Container(
                          height: 210,
                          color: black.withOpacity(.06),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: DataTable(
                                    // TODO : turn it card based later in future
                                    sortColumnIndex: _currentSortColumn,
                                    sortAscending: _isSortAsc,
                                    onSelectAll: (value) =>
                                        onSelectAll(value as bool),
                                    dataRowHeight: 60,
                                    showBottomBorder: true,
                                    headingTextStyle: _textTheme.headline2!
                                        .copyWith(
                                            fontSize: 15.0,
                                            color: black,
                                            fontWeight: FontWeight.bold),
                                    dataTextStyle:
                                        _textTheme.headline2!.copyWith(
                                      fontSize: 14.0,
                                      color: black,
                                    ),
                                    columnSpacing: 10,
                                    headingRowColor: MaterialStateProperty.all(
                                        black.withOpacity(.06)),
                                    columns: _columns(),
                                    rows: _rows()),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
