import 'dart:developer';
import 'dart:io';

import 'package:euclipse/widgets/all_subjects_notes.dart';
import 'package:euclipse/widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../bloc/class_summary/class_summary_cubit.dart';
import '../constants/colors.dart';
import '../constants/layout_constants.dart';
import '../models/classSummary_Model.dart';
import '../utility/navigator.dart';
import '../utility/utility.dart';

class ClassCard extends StatefulWidget {
  const ClassCard(
      {this.firstCard = false,
      this.cardIndex = 0,
      this.isSummary = false,
      required this.data,
      Key? key})
      : super(key: key);
  final bool firstCard;
  final int cardIndex;
  final bool isSummary;
  final ClassSummaryDataModel data;

  @override
  State<ClassCard> createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> {
  XFile? imageXfile;
  late ClassSummaryCubit _classSummaryCubit;

  bool getCheckBoxVal(bool isYes) {
    int? stat = widget.data.subjectAttendenceMap[
        widget.data.subjectsList[widget.cardIndex].subjectID];
    if (stat != null) {
      if (stat == -1) {
        return false;
      }
      if (stat == 0 && isYes) {
        return true;
      }
      if (stat == 1 && !isYes) {
        return true;
      }
    }
    return false;
  }

  void addNotes(String subjectId) {
    print('Adding notes');
    showImageSelectionSheet(subjectId);
    //   /*
    //   OPEN BOOTOMSHHET
    //   ASK CAM OR FILE
    //   IF CAM OPEN - PDF MAKER
    //   IF FILE OPEN FILES
    //   THEN
    //   ADD PATH STRAIGHT TO DB
    //   */
  }

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

  void shareNotes(String filePath, String subjectName) {
    Share.shareFiles([filePath]);
  }

  void openNotes(String filePath) {
    // print('opening note: $filePath');
    OpenFile.open(filePath);
  }

  void viewAllNotes(String subjectId, String subjectName) {
    print('opening all notes: ${subjectId}');
    Navigate().navigate(
        ViewAllNotes(
          subjectId: subjectId,
          subjectName: subjectName,
        ),
        context);
    /*
    CHECK IF SUBJECT HAS A UNIQUE ID, USE IT IF IT DOES
    MAKE A SEPERATE PAGE WITH ALL NOTES SO FAR WITH THAT UNIQUE ID
    */
  }

  Future<Directory?> handleDirectoryPermission(
      ImageSource source, List<String> subjectDetails) async {
    Directory? directory;
    if (Platform.isAndroid) {
      if (await requestPermission(Permission.manageExternalStorage)) {
        if (await requestPermission(source == ImageSource.gallery
            ? Permission.storage
            : Permission.camera)) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          List<String> paths = directory!.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath +
              "/euclipse/mynotes/${subjectDetails[1]}_${subjectDetails[0]}/";
          directory = Directory(newPath);
        }
      }
    } else {
      //TODO: check on ios
      if (await requestPermission(Permission.photos)) {
        directory = await getTemporaryDirectory();
      }
    }
    return directory;
  }

  void getFile(String subjectId, ImageSource source,
      {bool otherFile = false}) async {
    Directory? directory;
    var _subDetailSplit = subjectId.split('/');
    try {
      directory = await handleDirectoryPermission(source, _subDetailSplit);
      if (directory != null) {
        //IF DIRECTORY DOESN'T EXISTS
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        //IF IT DOES
        if (await directory.exists()) {
          List<String> _notesList = [];

          //IF GALLERY
          if (source == ImageSource.gallery && !otherFile) {
            imageXfile =
                await ImagePicker().pickImage(source: source, imageQuality: 70);
            if (imageXfile != null &&
                imageXfile!.path.isNotEmpty &&
                widget.data.subjectNotesPathMap
                    .containsKey(_subDetailSplit[0])) {
              Map<String, String> fileProperties =
                  getFileProperties(imageXfile!.path);
              var _newPath = directory.path +
                  '/${_subDetailSplit[1]}_${const Uuid().v1()}.${fileProperties['ext']}';
              try {
                File(imageXfile!.path).copy(_newPath);
                _notesList.add(_newPath);
              } catch (e) {
                log(e.toString());
              }
            }

            //IF FILE
          } else if (otherFile) {
            log('1');
            FilePickerResult? result = await FilePicker.platform.pickFiles(
                allowMultiple: true,
                type: FileType.custom,
                allowedExtensions: ['pdf', 'doc']);
            if (result != null) {
              List<File> files =
                  result.paths.map((path) => File(path!)).toList();
              files.forEach((file) {
                if (file.path != null && file.path.isNotEmpty) {
                  Map<String, String> fileProperties =
                      getFileProperties(file.path);
                  var _newPath = directory!.path +
                      '/${_subDetailSplit[1]}_${const Uuid().v1()}.${fileProperties['ext']}';
                  try {
                    File(file.path).copy(_newPath);
                    _notesList.add(_newPath);
                  } catch (e) {
                    log(e.toString());
                  }
                }
              });
            }
          }
          if (_notesList.isNotEmpty) {
            widget.data.subjectNotesPathMap[_subDetailSplit[0]]
                ?.addAll(_notesList);
            _classSummaryCubit.modifyClassSummaryData(widget.data);
            makeToast('file uploaded');
            Navigate().popView(context);
          }
        }
      } else {
        makeToast('Couldn\'t upload file. Please try again');
      }
    } catch (e) {
      log(e.toString());
      makeToast('a disparu un problème. Please try again');
    }
  }

  void showImageSelectionSheet(String subjectId) {
    showCustomBottomSheet(context, bottomFileSelection(subjectId));
  }

  Widget bottomFileSelection(String subjectId) {
    return SizedBox(
      height: 115,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TODO: NEXT VERSION IMPLEMENTATION
          // imageSelectButton(
          //     context,
          //     Icon(
          //       Icons.camera_alt,
          //       size: 26,
          //       color: primaryColor,
          //     ),
          //     'Camera',
          //     () => getFile(subjectId, ImageSource.camera)),
          // const SizedBox(
          //   width: 30,
          // ),
          // vMargin(height: 40, color: white),
          // const SizedBox(
          //   width: 30,
          // ),
          imageSelectButton(
              context,
              Icon(Icons.image_outlined, size: 26, color: primaryColor),
              'Image',
              () => getFile(subjectId, ImageSource.gallery)),
          const SizedBox(
            width: 60,
          ),
          vMargin(height: 40, color: white),
          const SizedBox(
            width: 60,
          ),
          imageSelectButton(
              context,
              Icon(Icons.image_outlined, size: 26, color: primaryColor),
              'File',
              () => getFile(subjectId, ImageSource.gallery, otherFile: true))
          // const Spacer(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _classSummaryCubit =
        BlocProvider.of<ClassSummaryCubit>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    var _textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: white, //black.withOpacity(.03),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      margin: const EdgeInsets.symmetric(
              horizontal: horizontalPadding - 10, vertical: 5) +
          EdgeInsets.only(top: widget.firstCard ? 6 : 0),
      width: double.infinity,
      child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: horizontalPadding - 12),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.data.subjectsList[widget.cardIndex].subjectName.trim(),
                style: _textTheme.headline1!.copyWith(fontSize: 18),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                  'by: ${widget.data.subjectsList[widget.cardIndex].lecturerName}',
                  style: _textTheme.headline1!
                      .copyWith(fontSize: 10, fontWeight: FontWeight.normal)),
              const SizedBox(
                height: 2,
              ),
              Text(
                  '${widget.data.subjectsList[widget.cardIndex].startTime} - ${widget.data.subjectsList[widget.cardIndex].endTime}',
                  style: _textTheme.headline1!
                      .copyWith(fontSize: 10, fontWeight: FontWeight.normal))
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                  ) +
                  const EdgeInsets.only(top: 0, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      hMargin(width: _mediaQuery.size.width * .76),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        '\u2022 Attended?',
                        style: _textTheme.headline1!.copyWith(fontSize: 14),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: getCheckBoxVal(true),
                                onChanged: (v) {
                                  if (widget.isSummary) {
                                    widget.data.subjectAttendenceMap[widget
                                        .data
                                        .subjectsList[widget.cardIndex]
                                        .subjectID] = 0;
                                    _classSummaryCubit
                                        .modifyClassSummaryData(widget.data);
                                  } else {
                                    makeToast('Can\'t change the past',
                                        doCapitalise: false);
                                  }
                                },
                                activeColor: black,
                              ),
                              const Text('Yes')
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  activeColor: black,
                                  value: getCheckBoxVal(false),
                                  onChanged: (v) {
                                    if (widget.isSummary) {
                                      widget.data.subjectAttendenceMap[widget
                                          .data
                                          .subjectsList[widget.cardIndex]
                                          .subjectID] = 1;
                                      _classSummaryCubit
                                          .modifyClassSummaryData(widget.data);
                                    } else {
                                      makeToast('Can\'t change the past',
                                          doCapitalise: false);
                                    }
                                  }),
                              const Text('No')
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      SizedBox(
                        width: _mediaQuery.size.width * .82,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\u2022 Notes',
                              style:
                                  _textTheme.headline1!.copyWith(fontSize: 14),
                            ),
                            if (!widget.isSummary)
                              InkWell(
                                onTap: () => viewAllNotes(
                                    widget.data.subjectsList[widget.cardIndex]
                                        .subjectID,
                                    widget.data.subjectsList[widget.cardIndex]
                                        .subjectName),
                                child: SizedBox(
                                  height: 20,
                                  // width: 80,
                                  child: Text(
                                    'View all',
                                    style: _textTheme.headline1!.copyWith(
                                        decoration: TextDecoration.underline,
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () => addNotes(widget.data
                                    .subjectsList[widget.cardIndex].subjectID +
                                '/' +
                                widget.data.subjectsList[widget.cardIndex]
                                    .subjectName),
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 9, bottom: 8, right: 10),
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: black.withOpacity(.03)),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      size: 24,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Add Notes',
                                      style: _textTheme.headline1!.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: _mediaQuery.size.width * .58,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: widget
                                    .data
                                    .subjectNotesPathMap[widget
                                        .data
                                        .subjectsList[widget.cardIndex]
                                        .subjectID]!
                                    .map(
                                  (notesPath) {
                                    Map<String, String> fileProperties =
                                        getFileProperties(notesPath);
                                    return InkWell(
                                        onTap: () => openNotes(
                                            fileProperties['completePath'] ??
                                                ''),
                                        child: fileThumb(
                                            fileProperties,
                                            _textTheme,
                                            () => removeNotes(
                                                  context,
                                                  widget
                                                      .data
                                                      .subjectsList[
                                                          widget.cardIndex]
                                                      .subjectID,
                                                  fileProperties[
                                                          'completePath'] ??
                                                      '',
                                                  fileProperties[
                                                          'fileNameWithExt'] ??
                                                      '',
                                                  notesPath,
                                                  () async {
                                                    List<
                                                        String> _notesList = widget
                                                            .data
                                                            .subjectNotesPathMap[
                                                        widget
                                                            .data
                                                            .subjectsList[widget
                                                                .cardIndex]
                                                            .subjectID]!;
                                                    if (_notesList != null &&
                                                        _notesList.isNotEmpty) {
                                                      _notesList
                                                          .remove(notesPath);
                                                      if (await File(notesPath)
                                                          .exists()) {
                                                        File(notesPath)
                                                            .delete();
                                                      }
                                                      Map<String, List<String>>
                                                          _allSubsNotes = widget
                                                              .data
                                                              .subjectNotesPathMap;
                                                      _allSubsNotes[widget
                                                              .data
                                                              .subjectsList[widget
                                                                  .cardIndex]
                                                              .subjectID] =
                                                          _notesList;
                                                      widget.data
                                                              .subjectNotesPathMap =
                                                          _allSubsNotes;
                                                      _classSummaryCubit
                                                          .modifyClassSummaryData(
                                                              widget.data);
                                                      Navigator.pop(context);
                                                      makeToast(
                                                          '${fileProperties['fileNameWithExt'] ?? ''} deleted',
                                                          doCapitalise: false);
                                                    }
                                                  },
                                                ),
                                            () => shareNotes(
                                                  fileProperties[
                                                          'completePath'] ??
                                                      '',
                                                  widget
                                                      .data
                                                      .subjectsList[
                                                          widget.cardIndex]
                                                      .subjectName,
                                                )));
                                  },
                                ).toList(),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
