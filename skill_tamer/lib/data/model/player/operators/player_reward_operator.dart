part of '../player.dart';

extension PlayerRewardOperator on Player{

  Player useReward({required int rewardIndex, int? skillIndex}){
    Reward reward = rewards[rewardIndex];
    return reward.activate(player: this, skillIndex: skillIndex);
  }



}