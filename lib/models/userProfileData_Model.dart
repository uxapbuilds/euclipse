import 'dart:convert';

import 'package:euclipse/models/timeTable_Model.dart';
import 'package:hive/hive.dart';

part 'userProfileData_Model.g.dart';

@HiveType(typeId: 0)
class UserProfileData {
  @override
  final typeId = 0;

  @HiveField(0)
  late String pfpPath;

  @HiveField(1)
  late String firstName;

  @HiveField(2)
  late String lastName;

  @HiveField(3)
  late String userName;

  @HiveField(4)
  late String educationFacility;

  @HiveField(5)
  List<TimeTableModel> timeTableData;

  UserProfileData(this.pfpPath, this.firstName, this.lastName, this.userName,
      this.educationFacility, this.timeTableData);

  @override
  String toString() {
    return jsonEncode({
      'pfppath': pfpPath,
      'fname': firstName,
      'lname': lastName,
      'username': userName,
      'education': educationFacility,
      'timet': timeTableData[0].subjectList![0].subjectName
    });
  }
}
