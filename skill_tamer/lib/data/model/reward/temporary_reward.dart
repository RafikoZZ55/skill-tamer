import 'package:skill_tamer/data/model/reward/reward.dart';

abstract class TemporaryReward extends Reward {
  int duration;
  int? activationTime;


  TemporaryReward({
    required this.duration,
    this.activationTime,
    required super.description,
    required super.icon,
    required super.name,
    required super.isActive,
  });

  int calculateExparationTime(){
    if(activationTime != null ) {return activationTime! + duration;}
    else {return -1;}
  }


}