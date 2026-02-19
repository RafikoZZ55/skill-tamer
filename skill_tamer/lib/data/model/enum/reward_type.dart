enum RewardType {
  temporaryAttributeBoost(
    description: "Boost your stats for short time",
    icon: "🥳",
    name: "Attribute Boost",
  ),
  redistributeAttributePoints(
    description: "Lets you redistribute points on a selected skill",
    icon: "🏆",
    name: "Redistribute Attribute POints",  
  ),
  sessionBoost(
    icon: "×",
    description: "multiplyes next session xp gain",
    name: "Session Boost"
  );

  final String name;
  final String description;
  final String icon;

  const RewardType({
    required this.name,
    required this.description,
    required this.icon
  });


  static RewardType get({required String rewardName}){
    return RewardType.values.singleWhere((e) => e.name == rewardName);
  }
}