// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../session_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionStateAdapter extends TypeAdapter<SessionState> {
  @override
  final int typeId = 1;

  @override
  SessionState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionState(
      timeStarted: fields[0] as int,
      lastSessionCheck: fields[1] as int,
      sessionSkill: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SessionState obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.timeStarted)
      ..writeByte(1)
      ..write(obj.lastSessionCheck)
      ..writeByte(2)
      ..write(obj.sessionSkill);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
