import 'package:euclipse/constants/layout_constants.dart';
import 'package:euclipse/utility/navigator.dart';
import 'package:euclipse/utility/utility.dart';
import 'package:euclipse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../bloc/home_cubit/home_cubit.dart';
import '../../constants/colors.dart';
import '../../models/toDoListData_Model.dart';

enum TaskPriority { high, medium, low }

class ToDoDialog extends StatefulWidget {
  const ToDoDialog(
      {this.type = 'todo',
      this.lastIndex = 0,
      required this.preSelectedDate,
      Key? key})
      : super(key: key);
  final String type;
  final int lastIndex;
  final DateTime preSelectedDate;
  @override
  State<ToDoDialog> createState() => _ToDoDialogDialogState();
}

class _ToDoDialogDialogState extends State<ToDoDialog> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDecsriptionController =
      TextEditingController();
  final TextEditingController _addedOnTextController = TextEditingController();
  final TextEditingController _startTimeController =
      TextEditingController(text: 'Tap to select');
  final TextEditingController _endTimeController =
      TextEditingController(text: 'Tap to select');
  late DateTime _addedOn;
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  TaskPriority _priority = TaskPriority.high;
  late HomeCubit _homeCubit;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _homeCubit = BlocProvider.of<HomeCubit>(context, listen: false);
    _addedOn = widget.preSelectedDate;
    _addedOnTextController.text = DateFormat('EEEE, MMMM dd').format(_addedOn) +
        getDayOfMonthSuffix(_addedOn.day);
  }

  void _onSave() {
    _homeCubit.addToDo(
        widget.lastIndex - 1,
        ToDoListModel(
            taskId: widget.lastIndex,
            task: _taskNameController.text.trim(),
            description: _taskDecsriptionController.text.trim(),
            taskPriority: mapPriorityToSimple(_priority),
            addedOn: _addedOn,
            startTime: _startTime,
            endTime: _endTime,
            isComplete: false));
    makeToast('new task added');
    Navigate().popView(context);
  }

  @override
  Widget build(BuildContext context) {
    var _style = Theme.of(context)
        .textTheme
        .headline1!
        .copyWith(fontSize: 12, color: white);
    var _mediaQuery = MediaQuery.of(context);
    InputDecoration _inputBorderDec = InputDecoration(
      fillColor: white,
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: white,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: white,
          width: 0.2,
        ),
      ),
    );
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(horizontalPadding) +
            EdgeInsets.only(bottom: _mediaQuery.viewInsets.bottom),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(13)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Create New task', style: _style.copyWith(fontSize: 24)),
                  Material(
                    color: Colors.transparent,
                    child: Container(
                      alignment: Alignment.centerRight,
                      // width: double.infinity,
                      child: Container(
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
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _onSave();
                              }
                            },
                            icon: Icon(
                              Icons.done,
                              color: primaryColor,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Text('Task Name',
                          style: _style.copyWith(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        validator: (e) {
                          if (e!.isEmpty) {
                            return 'Please enter task name';
                          }
                          if (e.length > 50) {
                            return 'Task name must be less than 50 characters';
                          }
                        },
                        autofocus: false,
                        cursorColor: white,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputBorderDec,
                        textInputAction: TextInputAction.next,
                        controller: _taskNameController,
                        keyboardType: TextInputType.streetAddress,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text('Description',
                          style: _style.copyWith(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        validator: (e) {
                          if (e!.length > 150) {
                            return 'Decription must be less than 150 characters';
                          }
                        },
                        autofocus: false,
                        cursorColor: white,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputBorderDec,
                        maxLines: 3,
                        textInputAction: TextInputAction.next,
                        controller: _taskDecsriptionController,
                        keyboardType: TextInputType.streetAddress,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text('Added On',
                          style: _style.copyWith(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        onTap: () async {
                          DateTime _selectedDate =
                              await selectDate(context, _addedOn);
                          _addedOnTextController.text =
                              DateFormat('EEEE, MMMM dd')
                                      .format(_selectedDate) +
                                  getDayOfMonthSuffix(_selectedDate.day);
                          _addedOn = _selectedDate;
                          Focus.of(context).unfocus();
                          _updateState();
                        },
                        child: IgnorePointer(
                          child: TextFormField(
                            autofocus: false,
                            cursorColor: white,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputBorderDec,
                            // readOnly: true,
                            controller: _addedOnTextController,
                            keyboardType: TextInputType.streetAddress,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Priority',
                              style: _style.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 12,
                          ),
                          DefaultTabController(
                            length: 3,
                            initialIndex: 0,
                            child: Material(
                              color: Colors.transparent,
                              child: SizedBox(
                                height: 30,
                                // width: MediaQuery.of(context).size.width * .70,
                                child: TabBar(
                                  onTap: (val) {
                                    _priority = val == 0
                                        ? TaskPriority.high
                                        : val == 1
                                            ? TaskPriority.medium
                                            : val == 2
                                                ? TaskPriority.low
                                                : TaskPriority.high;
                                    setState(() {});
                                  },
                                  tabs: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text('High'),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          height: 4,
                                          width: 4,
                                          color: priorityColorMapByCode[
                                                  mapPriorityToCode(
                                                      mapPriorityToSimple(
                                                          TaskPriority
                                                              .high))] ??
                                              Colors.black,
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text('Medium'),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          height: 4,
                                          width: 4,
                                          color: priorityColorMapByCode[
                                                  mapPriorityToCode(
                                                      mapPriorityToSimple(
                                                          TaskPriority
                                                              .medium))] ??
                                              Colors.black,
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text('Low'),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          height: 4,
                                          width: 4,
                                          color: priorityColorMapByCode[
                                                  mapPriorityToCode(
                                                      mapPriorityToSimple(
                                                          TaskPriority.low))] ??
                                              Colors.black,
                                        )
                                      ],
                                    ),
                                  ],
                                  labelColor: Colors.black,
                                  unselectedLabelColor: Colors.white,
                                  labelStyle: _style.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: black),
                                  indicator: RectangularIndicator(
                                      color: white,
                                      // priorityColorMapByCode[mapPriorityToCode(
                                      //         mapPriorityToSimple(_priority))] ??
                                      //     Colors.black,
                                      topLeftRadius: 12,
                                      topRightRadius: 12,
                                      bottomLeftRadius: 12,
                                      bottomRightRadius: 12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () async {
                          TimeOfDay time = await selectTime(context);
                          if (time != null) {
                            var timeFormatted = time.format(context);
                            _startTimeController.text = timeFormatted;
                            final now = DateTime.now();
                            _startTime = DateTime(now.year, now.month, now.day,
                                time.hour, time.minute);
                            _updateState();
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Time',
                              style: _style.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            IgnorePointer(
                              child: TextFormField(
                                validator: (e) {
                                  if (e!.toLowerCase() == 'tap to select') {
                                    return 'Please select start time';
                                  }
                                },
                                autofocus: false,
                                cursorColor: white,
                                style: const TextStyle(color: Colors.white),
                                decoration: _inputBorderDec,
                                readOnly: true,
                                controller: _startTimeController,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () async {
                          TimeOfDay time = await selectTime(context);
                          if (time != null) {
                            var timeFormatted = time.format(context);
                            _endTimeController.text = timeFormatted;
                            final now = DateTime.now();
                            _endTime = DateTime(now.year, now.month, now.day,
                                time.hour, time.minute);
                            _updateState();
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'End Time',
                              style: _style.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            IgnorePointer(
                              child: TextFormField(
                                validator: (e) {
                                  if (e!.toLowerCase() == 'tap to select') {
                                    return 'Please select end time';
                                  }
                                },
                                autofocus: false,
                                cursorColor: white,
                                style: const TextStyle(color: Colors.white),
                                decoration: _inputBorderDec,
                                readOnly: true,
                                controller: _endTimeController,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
