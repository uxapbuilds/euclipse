// ignore_for_file: prefer_const_constructors

import 'package:euclipse/bloc/home_cubit/home_cubit.dart';
import 'package:euclipse/constants/colors.dart';
import 'package:euclipse/constants/strings.dart';
import 'package:euclipse/view/homepage/classes_list.dart';
import 'package:euclipse/view/homepage/work_data_card/projects_task_list.dart';
import 'package:euclipse/view/homepage/work_data_card/todo_task_list.dart';
import 'package:euclipse/view/homepage/my_info_card.dart';
import 'package:euclipse/view/homepage/progress_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../../constants/layout_constants.dart';
import 'work_data_card/assignments_task_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit _homeCubit;
  late int initialTaskTabIndex = 0;

  Widget _taskCard() {
    var _textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Work To Do',
              style: _textTheme.headline1!.copyWith(fontSize: 28),
            ),
            const SizedBox(
              width: 8,
            ),
            Icon(
              Icons.work,
              size: 28,
            )
          ],
        ),
        const SizedBox(height: 10),
        DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Material(
            color: white,
            child: SizedBox(
              height: 40,
              child: TabBar(
                onTap: (value) {
                  initialTaskTabIndex = value;
                  _homeCubit.updateTaskIndex(value);
                  setState(() {});
                },
                tabs: _tasktabs,
                labelColor: black,
                unselectedLabelColor: Colors.black,
                labelStyle: _textTheme.headline1!.copyWith(
                    fontSize: 12, fontWeight: FontWeight.bold, color: black),
                indicator: RectangularIndicator(
                  color: black.withOpacity(.03),
                  topLeftRadius: 12,
                  topRightRadius: 12,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 250, child: _taskwidget()),
      ],
    );
  }

  final List<Widget> _tasktabs = [
    Tab(
      text: "Tasks",
    ),
    Tab(
      text: "Assignments",
    ),
    Tab(
      text: "Projects",
    )
  ];

  Widget _taskwidget() {
    switch (initialTaskTabIndex) {
      case 0:
        return TaskList();
      case 1:
        return AssignmentsList();
      case 2:
        return ProjectsList();
      default:
        return Container();
    }
  }

  @override
  void initState() {
    super.initState();
    _homeCubit = BlocProvider.of<HomeCubit>(context, listen: false);
    _homeCubit.retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    return Stack(
      children: [
        SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalPadding) +
              EdgeInsets.only(
                top: _mediaQuery.padding.top + 20,
              ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              MyInfoCard(),
              const SizedBox(height: 20),
              ProgressCard(),
              const SizedBox(height: 25),
              ClassesList(),
              const SizedBox(height: 25),
              BlocBuilder<HomeCubit, HomeState>(builder: (context, snapshot) {
                return _taskCard();
              }),
            ],
          ),
        )),
      ],
      // );
      // },
    );
  }
}
