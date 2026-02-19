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
    );
  }

  @override
  void write(BinaryWriter writer, MissionState obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.attributeCheck);
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
