import 'dart:io';

import 'package:euclipse/utility/local_data.dart';
import 'package:euclipse/view/homepage/homepage.dart';
import 'package:euclipse/view/onboarding/onboarding.dart';
import 'package:euclipse/widgets/form_diags/todo_form_dialog.dart';
import 'package:euclipse/widgets/see_more.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/colors.dart';
import '../view/home.dart';
import '../view/signup/signup_page.dart';
import '../view/time_table_gen/generate_time_table.dart';

class Utility {
  Widget getFirstPageNavigation() {
    var status = LocalData().checkInitUserStatus();
    switch (status) {
      case null:
        return const Onboarder();
      case 'signup':
        return const SignupPage();
      case 'gen_time_table':
        return const TimeTableGen();
      case 'homepage':
        return const Home();
      default:
        return Container(
          child: Center(child: Text('null1')),
        );
    }
  }

  String captialiseEachWord(String text) {
    if (text == null) {
      return '';
    }
    if (text.length <= 1) {
      return text.toUpperCase();
    }
    final words = text.split(' ');
    final capitalized = words.map((word) {
      String rest = '';
      String first = '';
      final l = word.length;
      if (word.isNotEmpty) {
        first = word.substring(0, 1).toUpperCase();
      }
      if (l > 1) {
        rest = word.substring(1);
      }
      return '$first$rest';
    });
    return capitalized.join(' ');
  }
}

String getDayOfMonthSuffix(int dayNum) {
  if (!(dayNum >= 1 && dayNum <= 31)) {
    throw Exception('Invalid day of month');
  }

  if (dayNum >= 11 && dayNum <= 13) {
    return 'th';
  }
  switch (dayNum % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

String getGreeting() {
  var _hour = DateTime.now().hour;
  print(_hour);
  if (_hour < 12) {
    return 'Good Morning';
  } else if (_hour >= 12 && _hour <= 16) {
    return 'Good Afternoon';
  } else if (_hour > 16) {
    return 'Good Evening';
  } else {
    return 'Hi';
  }
}

void showCustomBottomSheet(BuildContext context, Widget child) {
  showModalBottomSheet(
      backgroundColor: Colors.black,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return child;
      },
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18))));
}

Future<TimeOfDay> selectTime(BuildContext context) async {
  var timeOfDay = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    initialEntryMode: TimePickerEntryMode.dial,
  );

  if (timeOfDay != null && timeOfDay != TimeOfDay.now()) {
    return timeOfDay;
  } else {
    return Future.value(TimeOfDay.now());
  }
}

String taskTypeString(SeeMoreType type) {
  switch (type) {
    case SeeMoreType.TASK:
      return 'Tasks';
    case SeeMoreType.ASSINGNMENT:
      return 'Assignments';
    case SeeMoreType.PROJECTS:
      return 'Projects';
  }
}

Future<DateTime> selectDate(BuildContext context, DateTime selectedDate) async {
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101));
  if (picked != null && picked != selectedDate) {
    return selectedDate = picked;
  } else {
    return DateTime.now();
  }
}

String mapDayCharToFullWord(String char, {bool addShortForm = true}) {
  switch (char) {
    case 'M':
      return 'Monday${addShortForm ? '(M)' : ''}';
    case 'T':
      return 'Tuesday${addShortForm ? '(T)' : ''}';
    case 'W':
      return 'Wednesday${addShortForm ? '(W)' : ''}';
    case 'TH':
      return 'Thursday${addShortForm ? '(TH)' : ''}';
    case 'F':
      return 'Friday${addShortForm ? '(F)' : ''}';
    case 'S':
      return 'Saturday${addShortForm ? '(S)' : ''}';
    default:
      return '';
  }
}

int timeToInt(TimeOfDay myTime) => (myTime.hour + myTime.minute / 60.0).toInt();

double timeToDouble(TimeOfDay myTime) => myTime.hour + myTime.minute + 0.0;

String mapPriorityToSimple(TaskPriority val) {
  switch (val) {
    case TaskPriority.high:
      return 'High';
    case TaskPriority.medium:
      return 'Medium';
    case TaskPriority.low:
      return 'Low';
    default:
      return '';
  }
}

String mapPriorityToCode(String priority) {
  switch (priority) {
    case 'High':
      return 'L1';
    case 'Medium':
      return 'L2';
    case 'Low':
      return 'L3';
    default:
      return '';
  }
}

String timeFormat(int minutes) {
  double inHour = 0.0;
  if (minutes > 60) {
    inHour = minutes / 60;
    var split = inHour.toStringAsFixed(2).split('.');
    var min = (double.parse('.' + split[1]) * 60).toStringAsFixed(0);
    return '${split[0]}h ${min}m';
  } else {
    return '${minutes}min';
  }
}

Map<String, String> getFileProperties(String path) {
  //device/path/a.pdf
  var fileNameWithExt = path.split('/').last;
  List<String> file = fileNameWithExt.split('.');
  return {
    'fileNameWithExt': fileNameWithExt,
    'fileName': file.first,
    'ext': file.last,
    'completePath': path
  };
}

Dialog removeNotesDiag(BuildContext context,
    {String filePath = '',
    String fileNameWithExt = '',
    required Function onDelete}) {
  var _style = Theme.of(context).textTheme.headline1!;
  return Dialog(
    insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * .12,
        vertical: MediaQuery.of(context).size.height * .368),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Remove Notes',
              style: _style.copyWith(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
                'Are you sure?\n\'$fileNameWithExt\' will be permanently deleted.',
                textAlign: TextAlign.center,
                style: _style.copyWith(
                    fontSize: 13, fontWeight: FontWeight.normal)),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      onDelete();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 18),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(width: .8),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('Delete',
                          style: _style.copyWith(fontSize: 13, color: white)),
                    )),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .08,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                    decoration: BoxDecoration(
                        border: Border.all(width: .8),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text('Cancel', style: _style.copyWith(fontSize: 13)),
                  ),
                )
              ],
            )
          ]),
    ),
  );
}

Future<bool> requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
}

Future<bool> processFile(Permission permission) async {
  // Directory? directory;
  // try {
  //   if (Platform.isAndroid) {
  //     if (await requestPermission(permission)) {
  //       directory = await getExternalStorageDirectory();
  //       String newPath = "";
  //       print(directory);
  //       List<String> paths = directory!.path.split("/");
  //       for (int x = 1; x < paths.length; x++) {
  //         String folder = paths[x];
  //         if (folder != "Android") {
  //           newPath += "/" + folder;
  //         } else {
  //           break;
  //         }
  //       }
  //       newPath = newPath + "/èuclipse";
  //       directory = Directory(newPath);
  //     } else {
  //       return false;
  //     }
  //   } else {
  //     //TODO: check on ios
  //     if (await requestPermission(Permission.photos)) {
  //       directory = await getTemporaryDirectory();
  //     } else {
  //       return false;
  //     }
  //   }

  //   if (!await directory.exists()) {
  //     await directory.create(recursive: true);
  //   }
  //   if (await directory.exists()) {
  //     // File saveFile = File(directory.path + "/$fileName");
  //     // await dio.download(url, saveFile.path,
  //     //     onReceiveProgress: (value1, value2) {
  //     //       setState(() {
  //     //         progress = value1 / value2;
  //     //       });
  //     //     });
  //     // if (Platform.isIOS) {
  //     //   await ImageGallerySaver.saveFile(saveFile.path,
  //     //       isReturnPathOfIOS: true);
  //     // }
  //     // return true;
  //   }
  // } catch (e) {
  //   print(e);
  // }
  return false;
}
