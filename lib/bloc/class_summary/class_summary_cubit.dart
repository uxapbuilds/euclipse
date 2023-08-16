import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:euclipse/models/classSummary_Model.dart';
import 'package:euclipse/utility/local_data.dart';

part 'class_summary_state.dart';

class ClassSummaryCubit extends Cubit<ClassSummaryState> {
  ClassSummaryCubit() : super(const ClassSummaryInitial());

  //VARS
  late DateTime _calendarSelectedDate;
  late ClassSummaryDataModel? _classSummaryData;
  late List<ClassSummaryDataModel> _allClassSummaryDataList = [];
  late Map<DateTime, List<String>> _allSubjectNotesPath = {};

  //GETTERS
  DateTime get calendarSelectedDate => _calendarSelectedDate;
  ClassSummaryDataModel? get classSummaryData => _classSummaryData;
  List<ClassSummaryDataModel> get allClassSummaryData =>
      _allClassSummaryDataList;
  Map<DateTime, List<String>> get allSubjectNotesPath => _allSubjectNotesPath;

  //METHODS
  String stringifyDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day} 00:00:00.000';
  }

  void setCalendarDate(DateTime date) {
    emit(const ClassSummarUpdating());
    _calendarSelectedDate = date;
    if (_calendarSelectedDate != null) {
      getClassSummaryDataByDate();
    }
    emit(const ClassSummaryUpdated());
  }

  void getClassSummaryDataByDate() {
    var _data =
        LocalData().getClassSummaryByDate(stringifyDate(_calendarSelectedDate));
    if (_data != null) {
      _classSummaryData = _data;
    } else {
      _classSummaryData = null;
    }
  }

  void getAllClassSummaryData() {
    var _data = LocalData().getAllClassSummary();
    if (_data != null) {
      _allClassSummaryDataList = _data;
    } else {
      _allClassSummaryDataList = [];
    }
  }

  void getClassNotesById(String subjectId) {
    _allSubjectNotesPath.clear();
    if (subjectId != null && subjectId.isNotEmpty) {
      if (_allClassSummaryDataList.isNotEmpty) {
        for (var summaryData in _allClassSummaryDataList) {
          if (summaryData.subjectNotesPathMap.containsKey(subjectId) &&
              summaryData.subjectNotesPathMap[subjectId]!.isNotEmpty) {
            _allSubjectNotesPath[summaryData.summaryOfDate] =
                summaryData.subjectNotesPathMap[subjectId] ?? [];
          }
        }
      }
    }
    print(_allSubjectNotesPath.toString());
  }

  bool saveClassSummaryData(
      {required ClassSummaryDataModel data, required DateTime date}) {
    if (data != null) {
      int res =
          LocalData().saveClassSummary(data: data, date: stringifyDate(date));
      if (res == 0) {
        print(5);
        return true;
      } else {
        print(6);
        return false;
      }
    }
    print(7);
    return false;
  }

  void modifyClassSummaryData(ClassSummaryDataModel data) {
    emit(const ClassSummarUpdating());
    if (data != null) {
      int res = LocalData().modifyClassSummaryDataByDate(
          data: data, date: stringifyDate(data.summaryOfDate));
      print('mod: $res');
    }
    emit(const ClassSummaryUpdated());
  }
}
