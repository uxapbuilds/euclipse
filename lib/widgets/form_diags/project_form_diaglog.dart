// ignore_for_file: unused_field

import 'package:euclipse/constants/layout_constants.dart';
import 'package:euclipse/models/assignmentsListData_Model.dart';
import 'package:euclipse/models/projectListData_Model.dart';
import 'package:euclipse/utility/navigator.dart';
import 'package:euclipse/utility/utility.dart';
import 'package:euclipse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/home_cubit/home_cubit.dart';
import '../../constants/colors.dart';

enum TaskPriority { high, medium, low }

class ProjectFormDialog extends StatefulWidget {
  const ProjectFormDialog(
      {this.type = 'todo',
      this.lastIndex = 0,
      required this.preSelectedDate,
      Key? key})
      : super(key: key);
  final String type;
  final int lastIndex;
  final DateTime preSelectedDate;
  @override
  State<ProjectFormDialog> createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<ProjectFormDialog> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDecsriptionController =
      TextEditingController();
  final TextEditingController _addedOnTextController = TextEditingController();
  final TextEditingController _teamFieldTextController =
      TextEditingController();
  final TextEditingController _deadlineTextController =
      TextEditingController(text: 'Tap to select');
  late DateTime _addedOn;
  DateTime _deadline = DateTime.now();
  late HomeCubit _homeCubit;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<int, String> teamMembers = {};

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void showAddMemberDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(13)),
            margin: const EdgeInsets.symmetric(vertical: 350, horizontal: 60),
            child: Material(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Add Members',
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 18),
                        ),
                      ],
                    ),
                    TextField(controller: _teamFieldTextController),
                    InkWell(
                      onTap: () {
                        teamMembers[teamMembers.length + 1] =
                            _teamFieldTextController.text;
                        _teamFieldTextController.clear();
                        Navigate().popView(context);
                      },
                      child: const Icon(Icons.add),
                    )
                  ],
                ),
              ),
            ),
          );
        }).then((value) => _updateState());
  }

  @override
  void initState() {
    super.initState();
    _homeCubit = BlocProvider.of<HomeCubit>(context, listen: false);
    _deadline = widget.preSelectedDate;
    _deadlineTextController.text =
        DateFormat('EEEE, MMMM dd').format(_deadline) +
            getDayOfMonthSuffix(_deadline.day);
    _addedOn = widget.preSelectedDate;
    _addedOnTextController.text = DateFormat('EEEE, MMMM dd').format(_addedOn) +
        getDayOfMonthSuffix(_addedOn.day);
  }

  void _onSave() {
    _homeCubit.addProject(
        widget.lastIndex - 1,
        ProjecttListDataModel(
            taskId: widget.lastIndex,
            project: _taskNameController.text.trim(),
            description: _taskDecsriptionController.text.trim(),
            teamMembers: teamMembers,
            addedOn: _addedOn,
            deadline: _deadline,
            isComplete: false));
    makeToast('new project added');
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
                  Text('Create New Project',
                      style: _style.copyWith(fontSize: 24)),
                  Material(
                    color: Colors.transparent,
                    child: Container(
                      alignment: Alignment.centerRight,
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
                      Text('Project Name',
                          style: _style.copyWith(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        validator: (e) {
                          if (e!.isEmpty) {
                            return 'Please enter project name';
                          }
                          if (e.length > 50) {
                            return 'Project name must be less than 50 characters';
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
                          if (e!.length > 300) {
                            return 'Decription must be less than 300 characters';
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
                      Row(
                        children: [
                          Text('Team Members',
                              style: _style.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: black.withOpacity(.05),
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.all(10),
                              height: 50,
                              // width: MediaQuery.of(context).size.width * .4,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .42,
                                    child: TextFormField(
                                      cursorColor: white,
                                      decoration: _inputBorderDec,
                                      maxLines: 1,
                                      style: _style.copyWith(
                                          fontSize: 12, color: Colors.white),
                                      controller: _teamFieldTextController,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (_teamFieldTextController
                                          .text.isNotEmpty) {
                                        teamMembers[teamMembers.length + 1] =
                                            _teamFieldTextController.text;
                                        _teamFieldTextController.clear();
                                        _updateState();
                                      }
                                    },
                                    child: Text(
                                      '+',
                                      style: _style.copyWith(fontSize: 18),
                                    ),
                                  )
                                ],
                              )),
                          const Spacer(),
                        ],
                      ),
                      teamMembers.isNotEmpty
                          ? Wrap(
                              children: teamMembers.entries
                                  .map((e) => Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Chip(
                                          backgroundColor: white,
                                          deleteIcon: const Icon(
                                            Icons.delete,
                                            size: 16,
                                          ),
                                          onDeleted: () {
                                            teamMembers.removeWhere(
                                                (key, value) =>
                                                    value == e.value);
                                            _updateState();
                                          },
                                          label: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(e.value),
                                          ),
                                        ),
                                      ))
                                  .toList())
                          : const SizedBox(
                              height: 48,
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
                            controller: _addedOnTextController,
                            keyboardType: TextInputType.streetAddress,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text('Finish By',
                          style: _style.copyWith(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        onTap: () async {
                          DateTime _selectedDate =
                              await selectDate(context, _addedOn);
                          _deadlineTextController.text =
                              DateFormat('EEEE, MMMM dd')
                                      .format(_selectedDate) +
                                  getDayOfMonthSuffix(_selectedDate.day);
                          _deadline = _selectedDate;
                          _updateState();
                        },
                        child: IgnorePointer(
                          child: TextFormField(
                            autofocus: false,
                            cursorColor: white,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputBorderDec,
                            controller: _deadlineTextController,
                            keyboardType: TextInputType.streetAddress,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
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
