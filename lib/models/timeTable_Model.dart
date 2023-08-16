import 'package:euclipse/models/subjectDetail_Model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'timeTable_Model.g.dart';

@HiveType(typeId: 1)
class TimeTableModel {
  @HiveField(1)
  final String day;

  @HiveField(2)
  final List<SubjectDetailsModel>? subjectList;

  TimeTableModel({this.day = '', this.subjectList});
}
