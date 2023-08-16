import 'package:euclipse/bloc/class_summary/class_summary_cubit.dart';
import 'package:euclipse/bloc/home_cubit/home_cubit.dart';
import 'package:euclipse/constants/colors.dart';
import 'package:euclipse/models/classSummary_Model.dart';
import 'package:euclipse/widgets/calendar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../widgets/class_card.dart';

class CalendarHome extends StatefulWidget {
  const CalendarHome({Key? key}) : super(key: key);

  @override
  State<CalendarHome> createState() => _CalendarHomeState();
}

class _CalendarHomeState extends State<CalendarHome> {
  late ClassSummaryCubit _classSummaryCubit;
  // late HomeCubit _homeCubit;
  @override
  void initState() {
    super.initState();
    _classSummaryCubit =
        BlocProvider.of<ClassSummaryCubit>(context, listen: false);
    _classSummaryCubit.getAllClassSummaryData();
    // _homeCubit = BlocProvider.of<HomeCubit>(context, listen: false);

    //dummy
    // Map<String, int> attendenceDat = {};
    // Map<String, List<String>> notesPath = {};
    // for (var element in _homeCubit.subjectsOfToday) {
    //   attendenceDat[element.subjectID] = -1;
    //   notesPath[element.subjectID] = [
    //     'device/path/a.pdf',
    //     'device/path/b.jpeg',
    //     'device/path/c.jpeg'
    //   ];
    // }
    // ClassSummaryDataModel data = ClassSummaryDataModel(
    //     summaryOfDate: DateTime.now(),
    //     subjectsList: _homeCubit.subjectsOfToday,
    //     subjectAttendenceMap: attendenceDat,
    //     subjectNotesPathMap: notesPath);
    //---------
    // _classSummaryCubit.saveClassSummaryData(data: data, date: DateTime.now());
    _classSummaryCubit.setCalendarDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: CalendarAppBar(
        white: Colors.black,
        black: white,
        accent: white,
        backButton: false,
        onDateChanged: (value) {
          _classSummaryCubit.setCalendarDate(value);
        },
        fullCalendar: true,
        selectedDate: DateTime.now(),
        lastDate: DateTime.now(),
      ),
      body: BlocBuilder<ClassSummaryCubit, ClassSummaryState>(
        builder: (context, snapshot) {
          if (_classSummaryCubit.classSummaryData != null &&
              _classSummaryCubit.classSummaryData!.subjectsList.isNotEmpty) {
            List<ClassCard> _classList = [];
            _classSummaryCubit.classSummaryData!.subjectsList.asMap().forEach(
              (i, value) {
                _classList.add(
                  ClassCard(
                    data: _classSummaryCubit.classSummaryData!,
                    cardIndex: i,
                    firstCard: i == 0,
                  ),
                );
              },
            );
            return SingleChildScrollView(
              child: Column(
                children: _classList,
              ),
            );
          }
          return Center(
            child: Text(
              'No class summary found for\n${DateFormat('MMMM dd').format(_classSummaryCubit.calendarSelectedDate)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
