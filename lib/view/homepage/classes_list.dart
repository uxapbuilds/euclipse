// ignore_for_file: must_be_immutable, unnecessary_null_comparison
import 'dart:async';
import 'dart:developer';

import 'package:euclipse/bloc/home_cubit/home_cubit.dart';
import 'package:euclipse/models/subjectDetail_Model.dart';
import 'package:euclipse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassesList extends StatefulWidget {
  const ClassesList({Key? key}) : super(key: key);

  @override
  State<ClassesList> createState() => _ClassesListState();
}

class _ClassesListState extends State<ClassesList> {
  late HomeCubit _homeCubit;
  late SubjectDetailsModel _ongoingSub;
  late SubjectDetailsModel _upcomingSub;
  late List<SubjectDetailsModel> _subjects;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _homeCubit = BlocProvider.of<HomeCubit>(context, listen: false);
    init();
    _timer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (mounted) {
        init();
        _homeCubit.update();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void init() {
    _homeCubit.getOngoingClassData();
    _ongoingSub = _homeCubit.ongoingSubject;
    _upcomingSub = _homeCubit.upcomingSubject;
    _subjects = _homeCubit.subjectsOfToday;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, snapshot) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Classes',
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(fontSize: 28),
              ),
              const SizedBox(
                width: 8,
              ),
              const Icon(
                Icons.class_,
                size: 28,
              )
            ],
          ),
          _homeCubit.isDayOff
              ? emptyDataContainer(context,
                  height: 130,
                  hPadding: 0,
                  title: 'You have no classes\ntoday',
                  width: MediaQuery.of(context).size.width)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        classCard(context, _ongoingSub,
                            dayEnded: _homeCubit.showClassSummary,
                            endsIn: _homeCubit.subjectEndIn,
                            inSession: true),
                        classCard(context, _upcomingSub,
                            dayEnded: _homeCubit.showClassSummary,
                            nextSubStartsIn: _homeCubit.nextSubStartsIn,
                            upcoming: true)
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: _subjects.asMap().entries.map((element) {
                        if (element.value.subjectName.toLowerCase() !=
                                _ongoingSub.subjectName.toLowerCase() &&
                            element.value.subjectName.toLowerCase() !=
                                _upcomingSub.subjectName.toLowerCase()) {
                          return classCard(context, element.value);
                        } else {
                          return Container();
                        }
                      }).toList()),
                    ),
                  ],
                ),
        ],
      );
    });
  }
}
