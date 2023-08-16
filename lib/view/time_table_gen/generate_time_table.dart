// ignore_for_file: unnecessary_null_comparison
import 'dart:developer';
import 'dart:ui';
import 'package:euclipse/bloc/home_cubit/home_cubit.dart';
import 'package:euclipse/constants/layout_constants.dart';
import 'package:euclipse/local_notification/local_notification_manager.dart';
import 'package:euclipse/utility/utility.dart';
import 'package:euclipse/view/home.dart';
import 'package:euclipse/widgets/customtextfield.dart';
import 'package:euclipse/widgets/day_box.dart';
import 'package:euclipse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../models/subjectDetail_Model.dart';
import '../../models/timeTable_Model.dart';
import '../../models/userProfileData_Model.dart';
import '../../utility/local_data.dart';
import '../../utility/navigator.dart';

class TimeTableGen extends StatefulWidget {
  const TimeTableGen({this.isUpdate = false, Key? key}) : super(key: key);
  final bool isUpdate;
  @override
  State<TimeTableGen> createState() => _TimeTableGenState();
}

class _TimeTableGenState extends State<TimeTableGen> {
  var _selectedDay = oneCharaterDays[0];
  var numLectures = {};
  Map<String, bool> isDayOffMap = {};
  List<TimeTableModel> _timeTableList = [];
  late HomeCubit _homeCubit;
  final NotificationManager _notificationManager = NotificationManager();
  late Uuid uuid;
  Map<String, Map<String, List<TextEditingController>>> _lectureDataMap = {};

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget _headingWidget(String title,
      {bool hasTrailing = false, String numLecture = '', Function? action}) {
    return Row(
      children: [
        Container(
          width: 210,
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(fontSize: 13, color: black)),
        ),
        if (hasTrailing) const Spacer(),
        if (hasTrailing)
          IconButton(
              onPressed: () {
                action!();
              },
              icon: Icon(
                Icons.delete,
                color: primaryColor,
              ))
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _homeCubit = BlocProvider.of<HomeCubit>(context, listen: false);
    _timeTableList = _homeCubit.timeTableDataList;
    uuid = const Uuid();
    // log(_timeTableList.length.toString());
    if (_timeTableList != null && _timeTableList.isNotEmpty) {
      preloadTimeTableData();
    } else {
      initializeTextControllers();
    }
  }

  void preloadTimeTableData() {
    for (var day in oneCharaterDays) {
      List<TimeTableModel> _timeTableListFltrd = _timeTableList
          .where((element) => element.day.toLowerCase() == day.toLowerCase())
          .toList();
      // TimeTableModel _timeTable;
      if (_timeTableListFltrd.isNotEmpty) {
        TimeTableModel _timeTable = _timeTableListFltrd.first;
        // List<SubjectDetailsModel>? _timeTableSubjects = _timeTable.subjectList;
        if (_timeTable.subjectList != null &&
            _timeTable.subjectList!.isNotEmpty) {
          numLectures[day] = _timeTable.subjectList!.length;
          isDayOffMap[day] = _timeTable.subjectList!.first.isDayOff;
          Map<String, List<TextEditingController>> _lectures = {};
          for (int i = 1; i <= numLectures[day]; i++) {
            SubjectDetailsModel _subject = _timeTable.subjectList![i - 1];
            List<TextEditingController> _textControllers = [];
            timeTableDataFields.asMap().forEach((fieldIdx, value) {
              if (fieldIdx == 0) {
                _textControllers
                    .add(TextEditingController(text: _subject.subjectName));
              }
              if (fieldIdx == 1) {
                _textControllers
                    .add(TextEditingController(text: _subject.startTime));
              }
              if (fieldIdx == 2) {
                _textControllers
                    .add(TextEditingController(text: _subject.endTime));
              }
              if (fieldIdx == 3) {
                _textControllers
                    .add(TextEditingController(text: _subject.lecturerName));
              }
              if (fieldIdx == 4) {
                _textControllers.add(
                    TextEditingController(text: _subject.additionalDetails));
              }
            });
            _lectures[i.toString()] = _textControllers;
          }
          _lectureDataMap[day] = _lectures;
        }
      } else {
        initializeTextControllers();
      }
    }
  }

  void initializeTextControllers() {
    for (var day in oneCharaterDays) {
      isDayOffMap[day] = false;
      numLectures[day] = 1;
      Map<String, List<TextEditingController>> _lectures = {};
      for (int i = 1; i <= numLectures[day]; i++) {
        List<TextEditingController> _textControllers =
            timeTableDataFields.map((e) => TextEditingController()).toList();
        _lectures[i.toString()] = _textControllers;
      }
      _lectureDataMap[day] = _lectures;
    }
  }

  void addSubject() {
    var newLectureNum = numLectures[_selectedDay] + 1;
    Map<String, List<TextEditingController>> _lectures = {};
    List<TextEditingController> _textControllers =
        timeTableDataFields.map((e) => TextEditingController()).toList();
    _lectures[newLectureNum.toString()] = _textControllers;
    _lectureDataMap[_selectedDay]!.addAll(_lectures);
    numLectures[_selectedDay] = newLectureNum;
    _updateState();
  }

  void removeSubject(String numLecture) {
    _lectureDataMap[_selectedDay]!
        .removeWhere((key, value) => key == numLecture);
    numLectures[_selectedDay] -= 1;
    _updateState();
  }

  void saveData(
      Map<String, Map<String, List<TextEditingController>>> _lectureDataMap,
      BuildContext context,
      Map<String, bool> isDayOffList) {
    if (doValidate()!) {
      notificationCancel();
      List<TimeTableModel> _timeTableDataList = [];
      _lectureDataMap.forEach((day, value) {
        // log('TT day: $day');
        List<SubjectDetailsModel> _subjectDataList = [];
        value.forEach((key, value) {
          var _subjectData = SubjectDetailsModel(
              subjectID: uuid.v4(),
              subjectName: value[0].text,
              startTime: value[1].text,
              endTime: value[2].text,
              lecturerName: value[3].text,
              additionalDetails: value[4].text,
              isDayOff: isDayOffList[day] as bool);
          // log('TT sub: ${_subjectData.toString()}');
          _subjectDataList.add(_subjectData);
        });
        var _timeTableData =
            TimeTableModel(day: day, subjectList: _subjectDataList);
        _timeTableDataList.add(_timeTableData);
      });
      if (_timeTableDataList.isNotEmpty) {
        notificationScheduler(_timeTableDataList);
      }
      UserProfileData _userData = LocalData().getUserProfileData()!;
      if (_userData != null) {
        _userData.timeTableData = _timeTableDataList;
        int res = LocalData().saveUserProfileData(_userData);
        if (res == 0) {
          makeToast('saved');
          if (!widget.isUpdate) {
            LocalData().updateInitUserStatus(status: 'homepage');
            Navigate()
                .navigateAndRemoveUntil(const Home(), context); // remove until
          } else {
            _homeCubit.getClasses(DateTime.now());
          }
        } else {
          makeToast('ERROR');
        }
      }
    }
  }

  void notificationScheduler(List<TimeTableModel> dataList) {
    log('schduling....');
    DateTime _now = DateTime.now();
    for (var timetable in dataList) {
      log(mapDayCharToFullWord(timetable.day, addShortForm: false).trim());
      int? dayCode = notificationIdDayMap[
          mapDayCharToFullWord(timetable.day, addShortForm: false)
              .trim()
              .toLowerCase()];
      if (dayCode != null) {
        if (timetable.subjectList!.isNotEmpty) {
          for (int i = 0; i < timetable.subjectList!.length; i++) {
            if (timetable.subjectList![i].subjectName.isNotEmpty) {
              try {
                int notificationCode = int.parse('$dayCode$i');
                if (notificationCode != null) {
                  setupNotification(
                      _now, timetable.subjectList![i], notificationCode);
                }
              } catch (e) {
                log(e.toString());
              }
            }
          }
        }
      }
    }
  }

  void setupNotification(
      DateTime _now, SubjectDetailsModel _subjectData, int notificationCode) {
    var _startTimeSplit = _subjectData.startTime.trim().split(' ');
    var _endTimeSplit = _subjectData.endTime.trim().split(' ');
    var _isStartBeforeTwelve =
        _startTimeSplit[1].toLowerCase() == 'am' ? true : false;
    var _isEndBeforeTwelve =
        _endTimeSplit[1].toLowerCase() == 'am' ? true : false;
    var _startTimeSplitA = _startTimeSplit[0].split(':');
    var _endTimeSplitA = _endTimeSplit[0].split(':');
    DateTime _subjectStartTime = DateTime(
        _now.year,
        _now.month,
        _now.day,
        (int.parse(_startTimeSplitA[0]) +
            (_isStartBeforeTwelve || int.parse(_startTimeSplitA[0]) == 12
                ? 0
                : 12)),
        int.parse(_startTimeSplitA[1]));

    DateTime _subjectEndTime = DateTime(
        _now.year,
        _now.month,
        _now.day,
        (int.parse(_endTimeSplitA[0]) +
            (_isEndBeforeTwelve || int.parse(_endTimeSplitA[0]) == 12
                ? 0
                : 12)),
        int.parse(_endTimeSplitA[1]));

    if (_subjectStartTime.isBefore(DateTime.now())) {
      _subjectStartTime.add(const Duration(days: 1));
      _subjectEndTime.add(const Duration(days: 1));
    }

    // SETUP NOTI AT 15 MINUTES EARLY
    _notificationManager.scheduleNotification(
      _subjectStartTime.add(const Duration(minutes: -15)).toLocal(),
      title: _subjectData.subjectName,
      description: 'The class is about to start in 15 minutes.',
      notificationId: notificationCode + E_MINUTE_BEFORE_CODE,
    );

    //SETUP NOTI AT EXACT TIME
    _notificationManager.scheduleNotification(
      _subjectStartTime,
      title: _subjectData.subjectName,
      description: 'The class has started.',
      notificationId: notificationCode,
    );

    //SETUP NOTI AT END OF LECTURE
    _notificationManager.scheduleNotification(
      _subjectEndTime,
      title: _subjectData.subjectName,
      description: 'The class has ended.',
      notificationId: notificationCode + E_MINUTE_END_CODE,
    );
  }

  void notificationCancel() {
    log('cancelling notis....');
    _notificationManager.cancelScheduledNotification(
        context, 0, _homeCubit.timeTableDataList,
        type: NotificationType.timeTable);
  }

  bool? doValidate() {
    List<String> _errorIndexList = [];
    if (!isDayOffMap.entries
        .map((entry) => entry.value)
        .toList()
        .every((element) => element == true)) {
      _lectureDataMap.forEach((day, value) {
        if (!(isDayOffMap[day] as bool)) {
          value.forEach((subjectIdx, value) {
            value.asMap().forEach((key, controller) {
              if (key != 4) {
                if (controller.text.isEmpty) {
                  _errorIndexList.add('$day-$key-$subjectIdx');
                }
              }
            });
          });
        }
      });
      if (_errorIndexList.isNotEmpty) {
        List<String> error = _errorIndexList[0].split('-');
        makeToast(
            'please enter \'${timeTableDataFields[int.parse(error[1])]}\' in Subject ${error[2]} of ${mapDayCharToFullWord(error[0])}',
            duration: 3);
        return false;
      } else {
        return true;
      }
    }
    makeToast('Must add atleast one lecture.');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: white,
      body: Container(
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 20, bottom: 10),
        child: Stack(
          children: [
            // SvgPicture.asset(
            //   BACKGROUND_A2,
            //   fit: BoxFit.cover,
            // ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   height: mediaQuery.size.height * .06,
                  // ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: horizontalPadding),
                          padding: widget.isUpdate
                              ? null
                              : const EdgeInsets.only(left: 4),
                          width: double.infinity,
                          child: Text(
                            widget.isUpdate
                                ? 'Time Table'
                                : 'Now let\'s create\nthe time table.',
                            style: textTheme.headline1!.copyWith(fontSize: 28),
                          ),
                        ),
                      ),
                      Expanded(
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
                              onPressed: () => saveData(
                                  _lectureDataMap, context, isDayOffMap),
                              icon: Icon(
                                Icons.done,
                                color: primaryColor,
                              )),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: widget.isUpdate ? 15 : 25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: horizontalPadding),
                        child: Text(
                            widget.isUpdate ? 'Day Selected' : 'Select the day',
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(fontSize: 13, color: black)),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: mediaQuery.size.width,
                        height: 70,
                        margin: const EdgeInsets.symmetric(
                            horizontal: horizontalPadding),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: oneCharaterDays
                              .map(
                                (day) => InkWell(
                                  onTap: () {
                                    _selectedDay = day;
                                    _updateState();
                                  },
                                  child: DayBox(
                                    title: day,
                                    isSelected: _selectedDay == day,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: horizontalPadding, right: 13),
                    height: 30,
                    child: Row(
                      children: [
                        Text('Is ${mapDayCharToFullWord(_selectedDay)} off?',
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(fontSize: 13, color: black)),
                        const Spacer(),
                        Switch.adaptive(
                            activeColor: primaryColor,
                            value: isDayOffMap[_selectedDay] as bool,
                            onChanged: (b) {
                              if (isDayOffMap.containsKey(_selectedDay)) {
                                isDayOffMap[_selectedDay] = b;
                                _updateState();
                              }
                            }),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  !(isDayOffMap[_selectedDay] as bool)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // hMargin(
                            //     width: MediaQuery.of(context).size.width - 90,
                            //     height: .5),
                            // const SizedBox(
                            //   height: 11,
                            // ),
                            // Container(
                            //     width: MediaQuery.of(context).size.width,
                            //     margin: const EdgeInsets.symmetric(
                            //         horizontal: horizontalPadding),
                            //     child: Text('Add Details',
                            //         style: Theme.of(context)
                            //             .textTheme
                            //             .headline1!
                            //             .copyWith(fontSize: 13, color: black))),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            ..._lectureDataMap[_selectedDay]!.entries.map((e) {
                              String _lectureNum = e.key;
                              List<TextEditingController> _textControllers =
                                  e.value;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: horizontalPadding),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                    child: ExpansionTile(
                                      backgroundColor: black.withOpacity(.03),
                                      collapsedBackgroundColor:
                                          black.withOpacity(.03),
                                      iconColor: primaryColor,
                                      initiallyExpanded:
                                          // !widget.isUpdate
                                          //     ?
                                          _lectureNum == '1' ? true : false,
                                      // : false,
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      title: _headingWidget(
                                          'Subject'
                                          ' ${e.value[0].text.isNotEmpty ? '- ${e.value[0].text.trim()}' : ''}',
                                          hasTrailing: _lectureNum == '1'
                                              ? false
                                              : _lectureNum ==
                                                      numLectures[_selectedDay]
                                                          .toString()
                                                  ? true
                                                  : false,
                                          numLecture: _lectureNum,
                                          action: () =>
                                              removeSubject(_lectureNum)),
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 18,
                                                right: 18,
                                                bottom: 18),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                CustomTextField(
                                                    textController:
                                                        _textControllers[0],
                                                    labelText:
                                                        timeTableDataFields[0],
                                                    prefixIcon: const Icon(
                                                        Icons.menu_book)),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: CustomTextField(
                                                          onTap: () async {
                                                            TimeOfDay time =
                                                                await selectTime(
                                                                    context);
                                                            if (time != null) {
                                                              var timeFormatted =
                                                                  time.format(
                                                                      context);
                                                              _textControllers[
                                                                          1]
                                                                      .text =
                                                                  timeFormatted;
                                                              _updateState();
                                                            }
                                                          },
                                                          readOnly: true,
                                                          textController:
                                                              _textControllers[
                                                                  1],
                                                          labelText:
                                                              timeTableDataFields[
                                                                  1],
                                                          prefixIcon:
                                                              const Icon(Icons
                                                                  .watch_later_outlined)),
                                                    ),
                                                    const SizedBox(width: 9),
                                                    Expanded(
                                                      child: CustomTextField(
                                                          // maxLines: 2,
                                                          onTap: () async {
                                                            TimeOfDay time =
                                                                await selectTime(
                                                                    context);
                                                            if (time != null) {
                                                              var timeFormatted =
                                                                  time.format(
                                                                      context);
                                                              _textControllers[
                                                                          2]
                                                                      .text =
                                                                  timeFormatted;
                                                              _updateState();
                                                            }
                                                          },
                                                          readOnly: true,
                                                          textController:
                                                              _textControllers[
                                                                  2],
                                                          labelText:
                                                              timeTableDataFields[
                                                                  2],
                                                          prefixIcon:
                                                              const Icon(Icons
                                                                  .watch_later_outlined)),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                CustomTextField(
                                                    textController:
                                                        _textControllers[3],
                                                    labelText:
                                                        timeTableDataFields[3],
                                                    prefixIcon:
                                                        const Icon(Icons.person)
                                                    // const SizedBox(
                                                    //   height: 12,
                                                    // ),
                                                    // CustomTextField(
                                                    //   maxLines: 3,
                                                    //   textController:
                                                    //       _textControllers[4],
                                                    //   labelText:
                                                    //       timeTableDataFields[4],
                                                    //   prefixIcon: const Icon(
                                                    //       Icons.subject_rounded),
                                                    ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            InkWell(
                              onTap: () => addSubject(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: horizontalPadding,
                                          vertical: 8),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: white,
                                        border: Border.all(
                                            width: 1.2, color: white),
                                        borderRadius: BorderRadius.circular(9),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(.2),
                                              blurRadius: 4,
                                              spreadRadius: .2)
                                        ],
                                      ),
                                      child: Text('+ Add New Subject',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1!
                                              .copyWith(
                                                  fontSize: 13, color: black))),
                                ],
                              ),
                            ),
                          ],
                        )
                      : emptyDataContainer(
                          context,
                          width: mediaQuery.size.width,
                          // iconPath: DAY_OFF,
                          title: 'It\'s a day off.',
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
