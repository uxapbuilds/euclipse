// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toDoListData_Model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ToDoListModelAdapter extends TypeAdapter<ToDoListModel> {
  @override
  final int typeId = 3;

  @override
  ToDoListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ToDoListModel(
      taskId: fields[1] as int,
      task: fields[2] as String,
      description: fields[8] as String,
      taskPriority: fields[3] as String,
      addedOn: fields[4] as DateTime,
      isComplete: fields[7] as bool,
      startTime: fields[5] as DateTime,
      endTime: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ToDoListModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(1)
      ..write(obj.taskId)
      ..writeByte(2)
      ..write(obj.task)
      ..writeByte(3)
      ..write(obj.taskPriority)
      ..writeByte(4)
      ..write(obj.addedOn)
      ..writeByte(5)
      ..write(obj.startTime)
      ..writeByte(6)
      ..write(obj.endTime)
      ..writeByte(7)
      ..write(obj.isComplete)
      ..writeByte(8)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToDoListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
