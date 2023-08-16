// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';
import 'dart:io';
import 'package:euclipse/bloc/home_cubit/home_cubit.dart';
import 'package:euclipse/constants/strings.dart';
import 'package:euclipse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/timeTable_Model.dart';
import '../utility/utility.dart';

enum NotificationType { timeTable, simple }

class NotificationManager {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initializeLocalNotifications() async {
    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestPermission();
    } else {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions();
    }

    const androidSettings = AndroidInitializationSettings('app_icon');
    const iOSSettings = DarwinInitializationSettings();
    const initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);
    await flutterLocalNotificationsPlugin
        .initialize(initializationSettings); //onSelectNotification
  }

  void sampletest() async {
    var time = tz.TZDateTime.from(
      DateTime.now().add(Duration(seconds: 10)),
      tz.local,
    );
    // flutterLocalNotificationsPlugin.cancel(0);
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            icon: 'app_icon',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'English - I', // if subject ? subject name, if task task type
        'The class is about to start, you should reach on time.', //if subject this, if task task description+about to reach deadline
        time,
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        payload: 'item x');

    makeToast('scheduled notification');
  }

  void cancelScheduledNotification(
    BuildContext context,
    int notificationId,
    List<TimeTableModel> timeTableList, {
    NotificationType type = NotificationType.simple,
  }) {
    if (type == NotificationType.simple && notificationId != null) {
      flutterLocalNotificationsPlugin.cancel(notificationId);
    } else {
      if (timeTableList.isNotEmpty) {
        for (var timetable in timeTableList) {
          // log('k ');
          int? dayCode = notificationIdDayMap[
              mapDayCharToFullWord(timetable.day, addShortForm: false)
                  .trim()
                  .toLowerCase()];
          if (dayCode != null) {
            // log('1');
            if (timetable.subjectList!.isNotEmpty) {
              // log('2');
              for (int i = 0; i < timetable.subjectList!.length; i++) {
                if (timetable.subjectList![i].subjectName.isNotEmpty) {
                  log(timetable.subjectList![i].subjectName);
                  try {
                    int notificationCode = int.parse('$dayCode$i');
                    // log('CAN NOTI ID: $notificationCode : E_B : ${notificationCode + E_MINUTE_BEFORE_CODE} : E_E : ${notificationCode + E_MINUTE_END_CODE}');
                    if (notificationCode != null) {
                      // log('3');
                      flutterLocalNotificationsPlugin.cancel(notificationCode);
                      flutterLocalNotificationsPlugin
                          .cancel(notificationCode + E_MINUTE_BEFORE_CODE);
                      flutterLocalNotificationsPlugin
                          .cancel(notificationCode + E_MINUTE_END_CODE);
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
      // notificationIdDayMap.forEach(
      //   (key, dayCode) {
      //     if (subjectLength > 0) {
      //       for (int i = 0; i < subjectLength; i++) {
      //         try {
      //           int notificationCode = int.parse('$dayCode$i');
      //           if (notificationCode != null) {
      //             flutterLocalNotificationsPlugin.cancel(notificationCode);
      //           }
      //         } catch (e) {
      //           log(e.toString());
      //         }
      //       }
      //     }
      //   },
      // );

    }
  }

  void scheduleNotification(DateTime scheduleAt,
      {String title = '',
      String description = '',
      int notificationId = 0}) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
            'euclipse-noti-channel', 'euclipse-noti',
            icon: 'app_icon',
            channelDescription: 'euclipse-edu-stat-noti',
            importance: Importance.max,
            priority: Priority.high);
    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iOSPlatformChannelSpecifics);
    // switch (type) {
    //   case NotificationType
    //       .timeTable: // START NOTI-ID AS 1 + 1 TO 20 I.E. 115 IF 15 IS LAST SUBJECT NUM, PREFIX - [1 = MONDAY, 2 = TUES, 3 = WED, 4 = THURS, 5 = FRI, 6 = SAT]

    //     break;
    //   case NotificationType
    //       .simple: // START NOTI-ID FROM 10000 + T.O.D.O INDEX, 50000 + ASSIGNMENT INDEX, 100000 + PROJECT INDEX
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      description,
      tz.TZDateTime.from(
        scheduleAt,
        tz.local,
      ),
      notificationDetails,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    log('NOTI SCH: $notificationId @ ${scheduleAt.toString()} : $title : $description');
  }
}
