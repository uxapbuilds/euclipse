import 'dart:io';

import 'package:euclipse/bloc/class_summary/class_summary_cubit.dart';
import 'package:euclipse/bloc/home_cubit/home_cubit.dart';
import 'package:euclipse/bloc/user_register_bloc/user_register_bloc.dart';
import 'package:euclipse/constants/colors.dart';
import 'package:euclipse/constants/local_data_constants.dart';
import 'package:euclipse/local_notification/local_notification_manager.dart';
import 'package:euclipse/models/assignmentsListData_Model.dart';
import 'package:euclipse/models/classSummary_Model.dart';
import 'package:euclipse/models/projectListData_Model.dart';
import 'package:euclipse/models/subjectDetail_Model.dart';
import 'package:euclipse/models/timeTable_Model.dart';
import 'package:euclipse/models/toDoListData_Model.dart';
import 'package:euclipse/models/userProfileData_Model.dart';
import 'package:euclipse/start_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initializeLocalNotifications();
  tz.initializeTimeZones();
  NotificationManager().initializeLocalNotifications();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Hive.initFlutter();
  registerHiveAdapters();
  await openHiveBoxes();
  runApp(const MyApp());
}

void registerHiveAdapters() {
  Hive.registerAdapter<UserProfileData>(UserProfileDataAdapter());
  Hive.registerAdapter<ClassSummaryDataModel>(ClassSummaryDataModelAdapter());
  Hive.registerAdapter<TimeTableModel>(TimeTableModelAdapter());
  Hive.registerAdapter<SubjectDetailsModel>(SubjectDetailsModelAdapter());
  Hive.registerAdapter<ToDoListModel>(ToDoListModelAdapter());
  Hive.registerAdapter<AssignmentListDataModel>(
      AssignmentListDataModelAdapter());
  Hive.registerAdapter<ProjecttListDataModel>(ProjecttListDataModelAdapter());
}

Future<void> openHiveBoxes() async {
  await Hive.openBox<String>(
      initUserStatusKey); //dispose this box after user reaches homepage
  await Hive.openBox<UserProfileData>(userProfileData);
  await Hive.openBox<ToDoListModel>(toDoListData);
  await Hive.openBox<AssignmentListDataModel>(assignmentsListData);
  await Hive.openBox<ProjecttListDataModel>(projectListData);
  await Hive.openBox<ClassSummaryDataModel>(classSummaryData);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<int, Color> color = {
      50: Colors.black,
      100: Colors.black,
      200: Colors.black,
      300: Colors.black,
      400: Colors.black,
      500: Colors.black,
      600: Colors.black,
      700: Colors.black,
      800: Colors.black,
      900: Colors.black,
    };
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserRegisterBloc>(create: (context) => UserRegisterBloc()),
        BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
        BlocProvider<ClassSummaryCubit>(
            create: (context) => ClassSummaryCubit())
      ],
      child: OKToast(
        child: MaterialApp(
          debugShowCheckedModeBanner: true,
          title: 'euclipse',
          theme: ThemeData(
              splashColor: Colors.transparent,
              dividerColor: Colors.transparent,
              primarySwatch: MaterialColor(0xFF000000, color),
              fontFamily: 'CenturyGothic',
              textTheme: TextTheme(
                  headline1: TextStyle(
                      fontSize: 70,
                      fontFamily: 'CenturyGothic',
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withOpacity(.8)),
                  headline2: const TextStyle(
                      fontSize: 24, fontFamily: 'CenturyGothic'),
                  headline3:
                      const TextStyle(fontSize: 24, fontFamily: 'PTSerif'))),
          home: const MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: StartNavigation());
  }
}
