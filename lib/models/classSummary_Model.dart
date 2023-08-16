import 'package:euclipse/models/subjectDetail_Model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'classSummary_Model.g.dart';

@HiveType(typeId: 6)
class ClassSummaryDataModel extends HiveObject {
  @HiveField(1)
  DateTime summaryOfDate;

  @HiveField(2)
  List<SubjectDetailsModel> subjectsList;

  @HiveField(3)
  Map<String, int> subjectAttendenceMap;

  @HiveField(4)
  Map<String, List<String>> subjectNotesPathMap;

  ClassSummaryDataModel({
    required this.summaryOfDate,
    required this.subjectsList,
    required this.subjectAttendenceMap,
    required this.subjectNotesPathMap,
  });
}
