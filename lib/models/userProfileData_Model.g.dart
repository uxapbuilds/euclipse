// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userProfileData_Model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileDataAdapter extends TypeAdapter<UserProfileData> {
  @override
  final int typeId = 0;

  @override
  UserProfileData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfileData(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      (fields[5] as List).cast<TimeTableModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserProfileData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.pfpPath)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.userName)
      ..writeByte(4)
      ..write(obj.educationFacility)
      ..writeByte(5)
      ..write(obj.timeTableData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
