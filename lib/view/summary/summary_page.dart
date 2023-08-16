import 'package:euclipse/bloc/class_summary/class_summary_cubit.dart';
import 'package:euclipse/bloc/home_cubit/home_cubit.dart';
import 'package:euclipse/models/classSummary_Model.dart';
import 'package:euclipse/widgets/class_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/colors.dart';
import '../../constants/layout_constants.dart';
import '../../widgets/widgets.dart';

class ClassSummary extends StatefulWidget {
  const ClassSummary({Key? key}) : super(key: key);

  @override
  State<ClassSummary> createState() => _ClassSummaryState();
}

class _ClassSummaryState extends State<ClassSummary> {
  late ClassSummaryDataModel _classSummaryDataModel;
  late HomeCubit _homeCubit;
  late ClassSummaryCubit _classSummaryCubit;

  void saveData() {}

  List<Widget> getCards(int subjectsLen) {
    List<ClassCard> _classCards = [];
    for (int i = 0; i < subjectsLen; i++) {
      _classCards.add(ClassCard(
        data: _classSummaryDataModel,
        cardIndex: i,
        isSummary: true,
        firstCard: i == 0,
      ));
    }
    return _classCards;
  }

  @override
  void initState() {
    super.initState();
    _homeCubit = BlocProvider.of<HomeCubit>(context, listen: false);
    _classSummaryCubit =
        BlocProvider.of<ClassSummaryCubit>(context, listen: false);
    _classSummaryCubit.setCalendarDate(DateTime.now());
    initializeClassSummary();
  }

  void initializeClassSummary() {
    if (_classSummaryCubit.classSummaryData != null) {
      _classSummaryDataModel = _classSummaryCubit.classSummaryData!;
    } else {
      if (!_homeCubit.isDayOff &&
          _homeCubit.subjectsOfToday.isNotEmpty &&
          _homeCubit.subjectsOfToday.first.subjectName.isNotEmpty) {
        Map<String, int> _attendenceMap = {};
        Map<String, List<String>> _notesMap = {};
        for (var sub in _homeCubit.subjectsOfToday) {
          _attendenceMap[sub.subjectID] = -1;
          _notesMap[sub.subjectID] = [];
        }
        _classSummaryDataModel = ClassSummaryDataModel(
            summaryOfDate: DateTime.now(),
            subjectsList: _homeCubit.subjectsOfToday,
            subjectAttendenceMap: _attendenceMap,
            subjectNotesPathMap: _notesMap);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var mediaQuery = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.only(top: mediaQuery.padding.top + 25),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.only(left: 4),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Summary of :',
                            style: textTheme.headline1!.copyWith(fontSize: 28),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          currentDateContainer(context, prefixText: '')
                        ],
                      ),
                    ),
                  ),
                  // if (!_homeCubit.isDayOff)
                  //   Expanded(
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         color: white,
                  //         shape: BoxShape.circle,
                  //         boxShadow: [
                  //           BoxShadow(
                  //               color: Colors.black.withOpacity(.2),
                  //               blurRadius: 4,
                  //               spreadRadius: .2)
                  //         ],
                  //       ),
                  //       child: IconButton(
                  //         onPressed: () => saveData(),
                  //         icon: Icon(
                  //           Icons.done,
                  //           color: primaryColor,
                  //         ),
                  //       ),
                  //     ),
                  //   )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<ClassSummaryCubit, ClassSummaryState>(
              builder: (context, state) {
                return Column(
                  children: getCards(_homeCubit.subjectsOfToday.length),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
