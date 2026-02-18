import 'package:skill_tamer/data/model/reward/reward.dart';

class SessionBoost extends Reward {
  double sessionBoostMultiplyer;

  SessionBoost({
    required this.sessionBoostMultiplyer,
    required super.isActive,
  }) : super(
    icon: "×",
    description: "multiplyes next session by ${sessionBoostMultiplyer * 100}%",
    name: "Session Boost"
  );


}