import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'subjectDetail_Model.g.dart';

@HiveType(typeId: 2)
class SubjectDetailsModel {
  @HiveField(1)
  final String subjectID;

  @HiveField(2)
  final String subjectName;

  @HiveField(3)
  final String startTime;

  @HiveField(4)
  final String endTime;

  @HiveField(5)
  final String lecturerName;

  @HiveField(6)
  final String additionalDetails;

  @HiveField(7)
  final bool isDayOff;

  SubjectDetailsModel(
      {this.subjectID = '',
      this.subjectName = '',
      this.additionalDetails = '',
      this.endTime = '',
      this.lecturerName = '',
      this.startTime = '',
      this.isDayOff = false});

  @override
  String toString() {
    return jsonEncode({
      'id': subjectID,
      'subname': subjectName,
      'starttime': startTime,
      'endtime': endTime,
      'lecturer': lecturerName,
      'additionalDetails': additionalDetails,
      'isDayoff': isDayOff
    });
  }
}
