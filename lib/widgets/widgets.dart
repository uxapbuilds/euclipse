import 'dart:developer';
import 'dart:ui';

// import 'package:analog_clock/analog_clock.dart';
import 'package:euclipse/constants/colors.dart';
import 'package:euclipse/constants/layout_constants.dart';
import 'package:euclipse/models/assignmentsListData_Model.dart';
import 'package:euclipse/models/projectListData_Model.dart';
import 'package:euclipse/models/subjectDetail_Model.dart';
import 'package:euclipse/models/toDoListData_Model.dart';
import 'package:euclipse/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/strings.dart';

void makeToast(String message, {int duration = 2, bool doCapitalise = true}) {
  showToast(
      doCapitalise ? Utility().captialiseEachWord(message) : message + '.',
      duration: Duration(seconds: duration),
      position: const ToastPosition(align: Alignment(0, .9)),
      textPadding: const EdgeInsets.symmetric(horizontal: 19, vertical: 12));
}

Widget hMargin({double height = .1, double width = 90}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: horizontalPadding - 10),
    height: height,
    width: width,
    color: black,
  );
}

Widget vMargin({double height = 10, Color color = Colors.black}) {
  return Container(
    height: height,
    width: 1,
    decoration: BoxDecoration(
        border: Border.all(width: .08, color: white), color: color),
  );
}

Widget imageSelectButton(
    BuildContext context, Icon? icon, String? title, Function action,
    {bool isDisabled = false}) {
  var style = Theme.of(context)
      .textTheme
      .headline2!
      .copyWith(fontSize: 14, color: white, fontWeight: FontWeight.bold);
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      InkWell(
        highlightColor: Colors.transparent,
        onTap: () {
          action();
        },
        child: Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(330)),
          elevation: 2,
          child: SizedBox(height: 52, width: 52, child: icon),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        title!,
        style: style,
      )
    ],
  );
}

Widget emptyDataContainer(BuildContext context,
    {String title = '',
    String decription = '',
    double height = 150,
    double width = 180,
    String iconPath = '',
    Icon? libIcon,
    double hPadding = horizontalPadding - 8}) {
  return Container(
    height: height,
    width: width,
    margin: const EdgeInsets.only(bottom: 0, top: 0),
    padding: EdgeInsets.symmetric(horizontal: hPadding),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          color: black.withOpacity(.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconPath.isNotEmpty
                  ? Image.asset(
                      iconPath,
                      height: 50,
                      width: 50,
                    )
                  : libIcon ?? const SizedBox.shrink(),
              if (iconPath.isNotEmpty)
                const SizedBox(
                  height: 5,
                ),
              Text(title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 13, color: black)),
              const SizedBox(
                height: 5,
              ),
              Text(decription,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(fontSize: 18, color: black))
            ],
          ),
        ),
      ),
    ),
  );
}

Widget currentDateContainer(BuildContext context,
    {bool normalFormat = false, String prefixText = 'It\'s '}) {
  String dateNow = DateFormat(normalFormat ? 'MMMM dd\nhh:mm aa' : 'MMMM dd')
      .format(DateTime.now());
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
    decoration: BoxDecoration(
      color: white,
      border: Border.all(width: 1.2, color: white),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(.2),
            blurRadius: 4,
            spreadRadius: .2)
      ],
    ),
    child: Text(
        normalFormat
            ? dateNow
            : prefixText + dateNow + getDayOfMonthSuffix(DateTime.now().day),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline1!.copyWith(
            fontSize: 12, color: black, fontWeight: FontWeight.normal)),
  );
}

// Widget analogClock() {
//   return Card(
//     elevation: 3,
//     shape: const CircleBorder(),
//     child: Container(
//       // decoration: BoxDecoration(color: white, shape: BoxShape.circle),
//       padding: const EdgeInsets.all(1),
//       height: 120,
//       width: 120,
//       child: AnalogClock(
//         decoration: BoxDecoration(
//             border: Border.all(width: .5, color: Colors.transparent),
//             color: Colors.transparent,
//             shape: BoxShape.circle),
//         isLive: true,
//         hourHandColor: primaryColor,
//         minuteHandColor: secondaryColor,
//         secondHandColor: primaryColor,
//         showSecondHand: true,
//         numberColor: primaryColor,
//         showNumbers: true,
//         showAllNumbers: true,
//         textScaleFactor: 1.1,
//         showTicks: true,
//         showDigitalClock: false,
//         datetime: DateTime.now(),
//       ),
//     ),
//   );
// }

Widget contentActionBar(BuildContext context,
    {String? title,
    Function? onAdd,
    Function? onSeeMore,
    Widget? trailling,
    bool showSeeMore = true,
    int selectedIndex = 0}) {
  var _mediaQuery = MediaQuery.of(context).size;
  return Container(
    decoration: BoxDecoration(
        color: black.withOpacity(.03),
        // border: Border.all(color: black),
        borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(12),
            bottomRight: const Radius.circular(12),
            topLeft: selectedIndex == 0
                ? const Radius.circular(0)
                : const Radius.circular(12),
            topRight: selectedIndex == 2
                ? const Radius.circular(0)
                : const Radius.circular(12))),
    padding: EdgeInsets.symmetric(
        vertical: !showSeeMore || title != 'Tasks' ? 11 : 2, horizontal: 12),
    width: _mediaQuery.width,
    child: Row(
      children: [
        InkWell(
          onTap: () => onAdd!(),
          child: trailling,
        ),
        const Spacer(),
        if (showSeeMore)
          InkWell(
            onTap: () => onSeeMore!(),
            child: Text('View All',
                style: Theme.of(context).textTheme.headline1!.copyWith(
                    fontSize: 13, color: black, fontWeight: FontWeight.normal)),
          )
      ],
    ),
  );
}

Widget todoContentCard(BuildContext context, ToDoListModel _taskData,
    {Function? onDelete, Function? onComplete, bool reminderActive = false}) {
  var _textTheme = Theme.of(context).textTheme;
  var _style = _textTheme.headline1!;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    margin: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 5),
    child: Material(
      borderRadius: BorderRadius.circular(8),
      elevation: 6,
      color: white,
      child: SizedBox(
        height: 160,
        width: 200,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: priorityColorMapByCode[
                              mapPriorityToCode(_taskData.taskPriority)]),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      _taskData.task,
                      maxLines: 1,
                      style: _style.copyWith(fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: SingleChildScrollView(
                          child: Text(_taskData.description))),
                  const SizedBox(
                    height: 7,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => onDelete!(),
                        child: Icon(
                          Icons.delete_outline_outlined,
                          size: 20,
                          color: black.withOpacity(.6),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () => onComplete!(),
                        child: Icon(
                          Icons.done,
                          color: _taskData.isComplete
                              ? Colors.green
                              : black.withOpacity(.3),
                          size: 20,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 30,
                        width: 80,
                        decoration: BoxDecoration(
                            color: black,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                topLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8))),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.notifications_active,
                              //   color:
                              //       !reminderActive ? Colors.grey[700] : white,
                              //   size: 16,
                              // ),
                              Icon(
                                Icons.timelapse_outlined,
                                color: white,
                                size: 16,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                DateFormat("h:mm a").format(_taskData.endTime),
                                style:
                                    _style.copyWith(color: white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget assignmentContentCard(
    BuildContext context, AssignmentListDataModel _taskData,
    {Function? onDelete,
    Function? onComplete,
    bool reminderActive = false,
    bool usePadding = true}) {
  var _textTheme = Theme.of(context).textTheme;
  var _style = _textTheme.headline1!;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    margin: usePadding
        ? const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 20)
        : const EdgeInsets.only(bottom: 10),
    child: Material(
      borderRadius: BorderRadius.circular(8),
      elevation: 6,
      color: white,
      child: SizedBox(
        height: 160,
        width: 200,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      _taskData.assignment,
                      maxLines: 1,
                      style: _style.copyWith(fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  SizedBox(
                      height: 80,
                      child: SingleChildScrollView(
                          child: Text(_taskData.description))),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => onDelete!(),
                        child: Icon(
                          Icons.delete_outline_outlined,
                          size: 20,
                          color: black.withOpacity(.6),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () => onComplete!(),
                        child: Icon(
                          Icons.done,
                          color: _taskData.isComplete
                              ? Colors.green
                              : black.withOpacity(.3),
                          size: 20,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 30,
                        width: 115,
                        decoration: BoxDecoration(
                            color: black,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                topLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8))),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.notifications_active,
                              //   color:
                              //       !reminderActive ? Colors.grey[700] : white,
                              //   size: 16,
                              // ),
                              Icon(
                                Icons.timelapse_outlined,
                                color: white,
                                size: 16,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                DateFormat("dd/MM/yy")
                                    .format(_taskData.deadline),
                                style:
                                    _style.copyWith(color: white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget projectContentCard(BuildContext context, ProjecttListDataModel _taskData,
    {Function? onDelete,
    Function? onComplete,
    Widget? teamPopUp,
    bool usePadding = true}) {
  var _textTheme = Theme.of(context).textTheme;
  var _style = _textTheme.headline1!;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    margin: usePadding
        ? const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 20)
        : const EdgeInsets.only(bottom: 10),
    child: Material(
      borderRadius: BorderRadius.circular(8),
      elevation: 6,
      color: white,
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 160,
        width: MediaQuery.of(context).size.width * .85,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                          // height: 80,
                          width: MediaQuery.of(context).size.width * .45,
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                _taskData.project,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: _style.copyWith(fontSize: 18),
                              ))),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    SizedBox(
                        height: 80,
                        width: MediaQuery.of(context).size.width * .45,
                        child: SingleChildScrollView(
                            child: Text(_taskData.description))),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => onDelete!(),
                          child: Icon(
                            Icons.delete_outline_outlined,
                            size: 20,
                            color: black.withOpacity(.6),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        InkWell(
                          onTap: () => onComplete!(),
                          child: Icon(
                            Icons.done,
                            color: _taskData.isComplete
                                ? Colors.green
                                : black.withOpacity(.3),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                teamPopUp!,
                Container(
                  height: 30,
                  width: 115,
                  decoration: BoxDecoration(
                      color: black,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                          topLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timelapse_outlined,
                          color: white,
                          size: 16,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          DateFormat("dd/MM/yy").format(_taskData.deadline),
                          style: _style.copyWith(color: white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget addButton(
    {double height = 30, double width = 90, Color color = Colors.black}) {
  return Container(
    height: height,
    width: width,
    padding: const EdgeInsets.all(3),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add,
          color: black,
          size: 14,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          'Add New',
          style: TextStyle(color: black, fontSize: 12),
        )
      ],
    ),
  );
}

Widget classCard(context, SubjectDetailsModel subject,
    {bool inSession = false,
    bool upcoming = false,
    bool dayEnded = false,
    int endsIn = 0,
    bool hasClass = true,
    int nextSubStartsIn = 0}) {
  var _textTheme = Theme.of(context).textTheme;
  DateTime _now = DateTime.now();
  DateTime _subjectStartTime = _now;
  int _remainingMinutes = 0;
  if (subject.subjectName.isNotEmpty) {
    var _startTimeSplit = subject.startTime.split(' ');
    var _isStartBeforeTwelve =
        _startTimeSplit[1].toLowerCase() == 'am' ? true : false;
    List _timeSplit = _startTimeSplit[0].split(':');
    _subjectStartTime = DateTime(
        _now.year,
        _now.month,
        _now.day,
        int.parse(_timeSplit[0]) +
            (_isStartBeforeTwelve || int.parse(_timeSplit[0]) == 12 ? 0 : 12),
        int.parse(_timeSplit[1]));
    _remainingMinutes = _subjectStartTime.difference(_now).inMinutes;
  }
  return Container(
    height: inSession || upcoming ? 140 : 115,
    width: MediaQuery.of(context).size.width * .43,
    margin: const EdgeInsets.only(top: 10),
    child: Card(
      color: inSession || upcoming ? white : black.withOpacity(.03),
      elevation: inSession || upcoming ? 5 : 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: subject.subjectName.isNotEmpty
            ? (inSession || upcoming)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          if (inSession)
                            Text('In Session',
                                style: _textTheme.headline1!.copyWith(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                          if (upcoming)
                            Text('Up Next',
                                style: _textTheme.headline1!.copyWith(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                          const Spacer()
                        ],
                      ),
                      if (inSession || upcoming)
                        const SizedBox(
                          height: 3,
                        ),
                      if (inSession || upcoming)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.alarm,
                              size: 9,
                            ),
                            Text(
                                inSession
                                    ? timeFormat(endsIn)
                                    : timeFormat(nextSubStartsIn),
                                style: _textTheme.headline1!.copyWith(
                                    fontSize: 9, fontWeight: FontWeight.normal))
                          ],
                        ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(subject.subjectName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: _textTheme.headline1!.copyWith(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 6,
                      ),
                      Text('by: ' + subject.lecturerName,
                          style: _textTheme.headline1!.copyWith(
                              fontSize: 9, fontWeight: FontWeight.normal)),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.alarm,
                              size: 12,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                                _remainingMinutes <= 0
                                    ? 'Ended'
                                    : timeFormat(_remainingMinutes),
                                style: _textTheme.headline1!.copyWith(
                                    fontSize: 9,
                                    fontWeight: _remainingMinutes <= 0
                                        ? FontWeight.bold
                                        : FontWeight.normal)),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .3,
                              child: Text(subject.subjectName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  style: _textTheme.headline1!.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   height: 3,
                        // ),
                        const Spacer(),
                        Text(
                            'by: ' +
                                subject.lecturerName +
                                ' @ ' +
                                subject.startTime,
                            style: _textTheme.headline1!.copyWith(
                                fontSize: 9, fontWeight: FontWeight.normal)),
                        // const Spacer()
                      ],
                    ),
                  )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      hasClass
                          ? inSession
                              ? 'No subject\nin session'
                              : !dayEnded
                                  ? 'Final class in\nsession'
                                  : 'No upcoming\nclass'
                          : 'No class\ntoday',
                      textAlign: TextAlign.center,
                      style: _textTheme.headline1!
                          .copyWith(fontSize: 12, fontWeight: FontWeight.bold))
                ],
              ),
      ),
    ),
  );
}

Widget companyInfoHeader(BuildContext context) {
  var _textTheme = Theme.of(context).textTheme;
  return SizedBox(
    // decoration: BoxDecoration(
    //     gradient: LinearGradient(
    //         stops: [0, 0],
    //         begin: Alignment.center,
    //         end: Alignment.bottomRight,
    //         colors: [
    //           black.withOpacity(.05),
    //           white,
    //         ])),
    height: 150,
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Built by',
                style: _textTheme.headline1!.copyWith(
                    fontWeight: FontWeight.normal, fontSize: 13, color: white),
              ),
              const SizedBox(
                height: 3,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'U X',
                      style: _textTheme.headline1!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: white),
                    ),
                    TextSpan(
                      text: ' A P',
                      style: _textTheme.headline1!
                          .copyWith(fontSize: 18, color: white),
                    )
                  ],
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () async {
              Uri _gitUrl = Uri.parse(myGitUrl);
              if (await canLaunchUrl(_gitUrl)) {
                await launchUrl(_gitUrl,
                    mode: LaunchMode.externalApplication,
                    webOnlyWindowName: 'GIT');
              } else {
                throw "Could not launch $_gitUrl";
              }
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: white.withOpacity(.2)),
              child: Text(
                myGitUrl,
                style:
                    _textTheme.headline2!.copyWith(fontSize: 10, color: white),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('v$appVersion',
                  style: _textTheme.headline1!
                      .copyWith(fontSize: 10, color: white)),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget fileThumb(Map<String, String> fileProperties, TextTheme _textTheme,
    Function removeNotes, Function shareNotes,
    {bool canRemove = true}) {
  return Stack(
    children: [
      Container(
        margin: const EdgeInsets.only(top: 9, bottom: 8, right: 10),
        height: 90,
        width: 90,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: black.withOpacity(.03)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.file_copy,
                size: 24,
              ),
              const SizedBox(
                height: 8,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      '${fileProperties['fileName']}',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: _textTheme.headline1!.copyWith(
                          fontSize: 10, fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      '.${fileProperties['ext']}',
                      overflow: TextOverflow.ellipsis,
                      style: _textTheme.headline1!.copyWith(
                          fontSize: 10, fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        left: canRemove ? 5 : null,
        right: canRemove ? null : 15,
        child: InkWell(
          onTap: () => shareNotes(),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 209, 209, 209),
                shape: BoxShape.circle),
            child: const Icon(
              Icons.share,
              size: 16,
            ),
          ),
        ),
      ),
      if (canRemove)
        Positioned(
          bottom: 0,
          right: 15,
          child: InkWell(
            onTap: () => removeNotes(),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 209, 209, 209),
                  shape: BoxShape.circle),
              child: const Icon(
                Icons.delete,
                size: 16,
              ),
            ),
          ),
        )
    ],
  );
}
