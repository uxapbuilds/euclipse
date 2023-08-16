import 'dart:io';

import 'package:euclipse/bloc/class_summary/class_summary_cubit.dart';
import 'package:euclipse/constants/layout_constants.dart';
import 'package:euclipse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';

import '../constants/colors.dart';
import '../utility/navigator.dart';
import '../utility/utility.dart';

class ViewAllNotes extends StatelessWidget {
  const ViewAllNotes({this.subjectId = '', this.subjectName = '', Key? key})
      : super(key: key);
  final String subjectId;
  final String subjectName;

  void removeNotes(BuildContext context, String subjectId, String filePath,
      String fileNameWithExt, String notesPath, Function onDelete) {
    if (filePath != null &&
        filePath.isNotEmpty &&
        fileNameWithExt != null &&
        fileNameWithExt.isNotEmpty) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => removeNotesDiag(context,
            fileNameWithExt: fileNameWithExt,
            filePath: filePath,
            onDelete: onDelete),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var _classSummaryCubit =
        BlocProvider.of<ClassSummaryCubit>(context, listen: false);
    _classSummaryCubit.getClassNotesById(subjectId);
    var _textTheme = Theme.of(context).textTheme;
    var _style = _textTheme.headline1!.copyWith(fontSize: 24);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'All ',
                style: _style,
              ),
              ConstrainedBox(
                  constraints:
                      BoxConstraints(maxWidth: mediaQuery.size.width * .47),
                  child: Text(
                    // 'Data Structures & Algorithmns',
                    subjectName,
                    style: _style,
                  )),
              Text(
                ' Notes',
                style: _style,
              ),
              const SizedBox(
                width: 45,
              )
            ],
          ),
          backgroundColor: white,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigate().popView(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: black,
            ),
          )),
      body: _classSummaryCubit.allSubjectNotesPath.isNotEmpty
          ? SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: horizontalPadding) +
                        EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top +
                                (Platform.isAndroid ? 25 : 0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _classSummaryCubit.allSubjectNotesPath.entries
                      .map((notesMap) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat("- MMM dd yyyy -")
                                      .format(notesMap.key),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Wrap(
                                  children: notesMap.value.map((notesPath) {
                                    Map<String, String> fileProperties =
                                        getFileProperties(notesPath);
                                    return InkWell(
                                      onTap: () => OpenFile.open(notesPath),
                                      child: fileThumb(
                                          fileProperties,
                                          _textTheme,
                                          () => {},
                                          () => {
                                                Share.shareFiles([
                                                  fileProperties[
                                                          'completePath'] ??
                                                      ''
                                                ])
                                              },
                                          canRemove: false
                                          // context,
                                          //     widget
                                          //         .data
                                          //         .subjectsList[widget.cardIndex]
                                          //         .subjectID,
                                          //     fileProperties['completePath'] ?? '',
                                          //     fileProperties['fileNameWithExt'] ??
                                          //         '',
                                          //     notesPath,
                                          //     () async {
                                          //       List<String> _notesList =
                                          //           widget.data.subjectNotesPathMap[
                                          //               widget
                                          //                   .data
                                          //                   .subjectsList[
                                          //                       widget.cardIndex]
                                          //                   .subjectID]!;
                                          //       if (_notesList != null &&
                                          //           _notesList.isNotEmpty) {
                                          //         _notesList.remove(notesPath);
                                          //         if (await File(notesPath)
                                          //             .exists()) {
                                          //           File(notesPath).delete();
                                          //         }
                                          //         Map<String, List<String>>
                                          //             _allSubsNotes = widget
                                          //                 .data.subjectNotesPathMap;
                                          //         _allSubsNotes[widget
                                          //             .data
                                          //             .subjectsList[
                                          //                 widget.cardIndex]
                                          //             .subjectID] = _notesList;
                                          //         widget.data.subjectNotesPathMap =
                                          //             _allSubsNotes;
                                          //         _classSummaryCubit
                                          //             .modifyClassSummaryData(
                                          //                 widget.data);
                                          //         Navigator.pop(context);
                                          //         makeToast(
                                          //             '${fileProperties['fileNameWithExt'] ?? ''} deleted',
                                          //             doCapitalise: false);
                                          //       }
                                          //     }
                                          // )
                                          ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                hMargin(width: double.infinity),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            )
          : const Center(
              child: Text('No notes found.',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
    );
  }
}
