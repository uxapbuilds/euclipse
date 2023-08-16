// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subjectDetail_Model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubjectDetailsModelAdapter extends TypeAdapter<SubjectDetailsModel> {
  @override
  final int typeId = 2;

  @override
  SubjectDetailsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectDetailsModel(
      subjectID: fields[1] as String,
      subjectName: fields[2] as String,
      additionalDetails: fields[6] as String,
      endTime: fields[4] as String,
      lecturerName: fields[5] as String,
      startTime: fields[3] as String,
      isDayOff: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SubjectDetailsModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.subjectID)
      ..writeByte(2)
      ..write(obj.subjectName)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.lecturerName)
      ..writeByte(6)
      ..write(obj.additionalDetails)
      ..writeByte(7)
      ..write(obj.isDayOff);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectDetailsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
