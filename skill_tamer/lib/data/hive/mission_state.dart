import 'package:hive/hive.dart';

part 'generated/mission_state.g.dart';

@HiveType(typeId: 2)
class MissionState {
  @HiveField(0)
  String type;

  @HiveField(1)
  Map<String,int> attributeCheck;

  MissionState({
    required this.attributeCheck,
    required this.type,
  });
}