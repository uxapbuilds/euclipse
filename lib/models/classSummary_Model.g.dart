// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classSummary_Model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassSummaryDataModelAdapter extends TypeAdapter<ClassSummaryDataModel> {
  @override
  final int typeId = 6;

  @override
  ClassSummaryDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassSummaryDataModel(
      summaryOfDate: fields[1] as DateTime,
      subjectsList: (fields[2] as List).cast<SubjectDetailsModel>(),
      subjectAttendenceMap: (fields[3] as Map).cast<String, int>(),
      subjectNotesPathMap: (fields[4] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<String>())),
    );
  }

  @override
  void write(BinaryWriter writer, ClassSummaryDataModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.summaryOfDate)
      ..writeByte(2)
      ..write(obj.subjectsList)
      ..writeByte(3)
      ..write(obj.subjectAttendenceMap)
      ..writeByte(4)
      ..write(obj.subjectNotesPathMap);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassSummaryDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
