// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../reward_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RewardStateAdapter extends TypeAdapter<RewardState> {
  @override
  final int typeId = 3;

  @override
  RewardState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RewardState(
      type: fields[0] as String,
      isActive: fields[1] as bool,
      activationTime: fields[3] as int?,
      attributesBoostAmount: (fields[4] as Map?)?.cast<String, int>(),
      duration: fields[2] as int?,
      sessionBoostMultiplyer: fields[5] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, RewardState obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.isActive)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.activationTime)
      ..writeByte(4)
      ..write(obj.attributesBoostAmount)
      ..writeByte(5)
      ..write(obj.sessionBoostMultiplyer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RewardStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
