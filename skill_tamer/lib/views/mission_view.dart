import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:select_bottom_list/select_bottom_list.dart';
import 'package:skill_tamer/components/completed_mission_info.dart';
import 'package:skill_tamer/components/mission_card.dart';
import 'package:skill_tamer/components/next_mission_counter_card.dart';
import 'package:skill_tamer/data/constant/app_durations.dart';
import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';
import 'package:skill_tamer/data/model/mission/mission.dart';
import 'package:skill_tamer/data/model/player/player.dart';
import 'package:skill_tamer/data/model/skill/skill.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AttributeChartData {
  final String attribute;
  final int value;
  final String? series;

  AttributeChartData(this.attribute, this.value, {this.series});
}

class MissionView extends ConsumerStatefulWidget {
  const MissionView({super.key});

  @override
  ConsumerState<MissionView> createState() => _MissionViewState();
}

class _MissionViewState extends ConsumerState<MissionView> {
  String? firstSelectedSkillId;
  String? secondSelectedSkillId;
  bool _showRequired = false;
  Mission? _lastMission;
  List<AttributeChartData> _chartData = [];
  Map<SkillAttributeType, int> _collectedPoints = {};
  int _lastSkillsHash = 0;
  int _lastMissionHash = 0;
  String? _lastFirstSkill;
  String? _lastSecondSkill;

  @override
  void dispose() {
    super.dispose();
  }

  void _updateChartData(Mission? mission, List<Skill> skills,
      Map<SkillAttributeType, int> totalBoost) {
    if (mission == null) {
      _chartData = [];
      _collectedPoints = {};
      return;
    }

    final skillsHash = skills.length;
    final missionHash = mission.hashCode;
    final firstSkillChanged = _lastFirstSkill != firstSelectedSkillId;
    final secondSkillChanged = _lastSecondSkill != secondSelectedSkillId;

    if (skillsHash == _lastSkillsHash &&
        missionHash == _lastMissionHash &&
        !firstSkillChanged &&
        !secondSkillChanged) {
      return;
    }

    _lastSkillsHash = skillsHash;
    _lastMissionHash = missionHash;
    _lastFirstSkill = firstSelectedSkillId;
    _lastSecondSkill = secondSelectedSkillId;

    _collectedPoints = {
      for (final attr in SkillAttributeType.values) attr: 0,
    };

    void addSkillAttributes(String? skillId) {
      if (skillId == null || skillId == "none") return;

      final index = int.tryParse(skillId);
      if (index == null || index < 0 || index >= skills.length) return;

      final skill = skills[index];

      for (final attr in SkillAttributeType.values) {
        final currentValue = _collectedPoints[attr] ?? 0;
        final skillValue = skill.attributes[attr] ?? 0;

        _collectedPoints[attr] = (currentValue + skillValue).clamp(0, 10);
      }
    }

    addSkillAttributes(firstSelectedSkillId);
    addSkillAttributes(secondSelectedSkillId);

    _chartData = [];

    for (final attr in SkillAttributeType.values) {
      final collectedValue = _collectedPoints[attr] ?? 0;
      final boostValue = totalBoost[attr] ?? 0;
      final totalValue = (collectedValue + boostValue).clamp(0, 10);
      _chartData
          .add(AttributeChartData(attr.name, totalValue, series: 'Collected'));
    }

    for (final attr in SkillAttributeType.values) {
      final requiredValue = mission.attributeCheck[attr] ?? 0;
      _chartData.add(
          AttributeChartData(attr.name, requiredValue, series: 'Required'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(playerProvider);
    final Mission? mission = player.currentMission;
    final List<Skill> skills = player.skills;
    final totalBoost = player.calculateSkillAttributeBoost();

    if (mission == null) return const SizedBox();
    if (_showRequired && mission != _lastMission) _showRequired = false;

    _lastMission = mission;

    _updateChartData(mission, skills, totalBoost);

    final bool isAttemptDisabled = mission.isComplete;

    final List<SelectItem> selectableSkills = [
      const SelectItem(id: "none", title: "Select Skill"),
      ...List.generate(
        skills.length,
        (index) => SelectItem(
          id: index.toString(),
          title: "${skills[index].type.icon}   ${skills[index].type.name}",
        ),
      ),
    ];

    firstSelectedSkillId ??= selectableSkills.first.id;
    secondSelectedSkillId ??= selectableSkills.first.id;

    String getTitle(String? id) {
      return selectableSkills
          .firstWhere((e) => e.id == id, orElse: () => selectableSkills.first)
          .title;
    }

    Future<void> attempt() async {
      if (mission.isComplete) return;

      if (firstSelectedSkillId == null || secondSelectedSkillId == null) return;
      if (firstSelectedSkillId == "none" || secondSelectedSkillId == "none") {
        return;
      }

      final firstIndex = int.tryParse(firstSelectedSkillId!);
      final secondIndex = int.tryParse(secondSelectedSkillId!);
      if (firstIndex == null || secondIndex == null) return;
      if (firstIndex < 0 || firstIndex >= skills.length) return;
      if (secondIndex < 0 || secondIndex >= skills.length) return;

      final Skill skillA = skills[firstIndex];
      final Skill skillB = skills[secondIndex];

      setState(() => _showRequired = true);
      final outcome = ref
          .read(playerProvider.notifier)
          .attemptMission(a: skillA.type, b: skillB.type);
      await Future.delayed(AppDurations.oneSecond);
      if (!mounted) return;

      showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (_) => AlertDialog(
                title: Text(
                    outcome.success ? 'Mission Success' : 'Mission Failed'),
                content: Text(outcome.success
                    ? 'You earned xp ${outcome.reward?.type.name}.'
                    : 'Try again later.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'))
                ],
              ));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            NextMissionCounterCard(),
            MissionCard(mission: mission),
            if (mission.isComplete) CompletedMissionInfo(),
            if (totalBoost.values.any((v) => v > 0))
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.tertiary,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '✨',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active Boosts',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onTertiaryContainer,
                            ),
                          ),
                          Text(
                            totalBoost.entries
                                .where((e) => e.value > 0)
                                .map((e) => '${e.key.name} +${e.value}')
                                .join(' • '),
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onTertiaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(
              height: 335,
              child: Card(
                elevation: 2,
                child: SingleChildScrollView(
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: 10,
                      interval: 2,
                    ),
                    legend: Legend(
                        isVisible: true, position: LegendPosition.bottom),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CartesianSeries>[
                      LineSeries<AttributeChartData, String>(
                        name: 'Collected',
                        dataSource: _chartData
                            .where((d) => d.series == 'Collected')
                            .toList(),
                        xValueMapper: (AttributeChartData data, _) =>
                            data.attribute,
                        yValueMapper: (AttributeChartData data, _) =>
                            data.value,
                        color: Theme.of(context).colorScheme.primary,
                        width: 2.5,
                        markerSettings: const MarkerSettings(
                            isVisible: true, width: 6, height: 6),
                      ),
                      if (_showRequired || mission.isComplete)
                        LineSeries<AttributeChartData, String>(
                          name: 'Required',
                          dataSource: _chartData
                              .where((d) => d.series == 'Required')
                              .toList(),
                          xValueMapper: (AttributeChartData data, _) =>
                              data.attribute,
                          yValueMapper: (AttributeChartData data, _) =>
                              data.value,
                          color: Theme.of(context).colorScheme.error,
                          width: 2.5,
                          markerSettings: const MarkerSettings(
                              isVisible: true, width: 6, height: 6),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isAttemptDisabled ? null : attempt,
                label: const Text(
                  'Attempt Mission',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  disabledBackgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
              ),
            ),
            SelectBottomList(
              titleTextStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              selectedTitleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary),
              data: selectableSkills,
              selectedId: firstSelectedSkillId!,
              selectedTitle: getTitle(firstSelectedSkillId),
              onChange: (id, title) {
                if (isAttemptDisabled) return;
                setState(() => firstSelectedSkillId = id);
              },
              isDisable: isAttemptDisabled,
            ),
            SelectBottomList(
              titleTextStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              selectedTitleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary),
              data: selectableSkills,
              selectedId: secondSelectedSkillId!,
              selectedTitle: getTitle(secondSelectedSkillId),
              onChange: (id, title) {
                if (isAttemptDisabled) return;
                setState(() => secondSelectedSkillId = id);
              },
              isDisable: isAttemptDisabled,
            ),
          ],
        ),
      ),
    );
  }
}
