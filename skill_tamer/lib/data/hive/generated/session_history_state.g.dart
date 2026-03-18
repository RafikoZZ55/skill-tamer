// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../session_history_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionHistoryStateAdapter extends TypeAdapter<SessionHistoryState> {
  @override
  final int typeId = 5;

  @override
  SessionHistoryState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionHistoryState(
      status: fields[3] as String,
      completedAt: fields[2] as int,
      duration: fields[0] as int,
      skillType: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SessionHistoryState obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.duration)
      ..writeByte(1)
      ..write(obj.skillType)
      ..writeByte(2)
      ..write(obj.completedAt)
      ..writeByte(3)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionHistoryStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
