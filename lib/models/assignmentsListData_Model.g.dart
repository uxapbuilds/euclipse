// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignmentsListData_Model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssignmentListDataModelAdapter
    extends TypeAdapter<AssignmentListDataModel> {
  @override
  final int typeId = 4;

  @override
  AssignmentListDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssignmentListDataModel(
      taskId: fields[1] as int,
      assignment: fields[2] as String,
      description: fields[6] as String,
      addedOn: fields[3] as DateTime,
      deadline: fields[4] as DateTime,
      isComplete: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AssignmentListDataModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.taskId)
      ..writeByte(2)
      ..write(obj.assignment)
      ..writeByte(3)
      ..write(obj.addedOn)
      ..writeByte(4)
      ..write(obj.deadline)
      ..writeByte(5)
      ..write(obj.isComplete)
      ..writeByte(6)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssignmentListDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
