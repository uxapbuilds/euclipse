// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeTable_Model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeTableModelAdapter extends TypeAdapter<TimeTableModel> {
  @override
  final int typeId = 1;

  @override
  TimeTableModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeTableModel(
      day: fields[1] as String,
      subjectList: (fields[2] as List?)?.cast<SubjectDetailsModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, TimeTableModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.day)
      ..writeByte(2)
      ..write(obj.subjectList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeTableModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
