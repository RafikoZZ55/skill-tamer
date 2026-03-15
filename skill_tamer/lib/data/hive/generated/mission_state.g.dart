// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../mission_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MissionStateAdapter extends TypeAdapter<MissionState> {
  @override
  final int typeId = 2;

  @override
  MissionState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MissionState(
      attributeCheck: (fields[1] as Map).cast<String, int>(),
      type: fields[0] as String,
      isComplete: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MissionState obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.attributeCheck)
      ..writeByte(2)
      ..write(obj.isComplete);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MissionStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
