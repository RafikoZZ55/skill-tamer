import 'package:hive/hive.dart';

part 'generated/reward_state.g.dart';

@HiveType(typeId: 3)
class RewardState {
  @HiveField(0)
  String type;

  @HiveField(1)
  bool isActive;

  @HiveField(2)
  int? duration;

  @HiveField(3)
  int? activationTime;

  @HiveField(4)
  Map<String,int>? attributesBoostAmount;  

  @HiveField(5)
  double? sessionBoostMultiplyer;

  RewardState({
    required this.type,
    required this.isActive,
    this.activationTime,
    this.attributesBoostAmount,
    this.duration,
    this.sessionBoostMultiplyer,
  });
}