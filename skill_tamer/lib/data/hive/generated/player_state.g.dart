// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../player_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerStateAdapter extends TypeAdapter<PlayerState> {
  @override
  final int typeId = 4;

  @override
  PlayerState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerState(
      xpGained: fields[0] as int,
      skills: (fields[1] as List).cast<SkillState>(),
      rewards: (fields[2] as List).cast<RewardState>(),
      lastRefreshAt: fields[3] as int,
      currentMissionRefreshAt: fields[5] as int,
      currentMission: fields[4] as MissionState?,
      activeSession: fields[6] as SessionState?,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerState obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.xpGained)
      ..writeByte(1)
      ..write(obj.skills)
      ..writeByte(2)
      ..write(obj.rewards)
      ..writeByte(3)
      ..write(obj.lastRefreshAt)
      ..writeByte(4)
      ..write(obj.currentMission)
      ..writeByte(5)
      ..write(obj.currentMissionRefreshAt)
      ..writeByte(6)
      ..write(obj.activeSession);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
