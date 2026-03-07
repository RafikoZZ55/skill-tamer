import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:select_bottom_list/select_bottom_list.dart';
import 'package:skill_tamer/components/mission_card.dart';
import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';
import 'package:skill_tamer/data/model/mission/mission.dart';
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
  late Timer _timer;
  String _nextMissionRefreshTimer = "";
  String? firstSelectedSkillId;
  String? secondSelectedSkillId;
  bool _showRequired = false; // only show required values after attempt
  Mission? _lastMission; // used to detect mission changes

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final nextMissionRefreshAt =
          ref.read(playerProvider).nextMissionRefreshAt;

      final difference = nextMissionRefreshAt - currentTime;

      if (!mounted) return;

      if (difference <= 0) {
        setState(() => _nextMissionRefreshTimer = "Refreshing...");
        return;
      }

      final hours = difference ~/ (1000 * 60 * 60);
      final minutes = (difference ~/ (1000 * 60)) % 60;
      final seconds = (difference ~/ 1000) % 60;

      setState(() {
        _nextMissionRefreshTimer = "${hours}h ${minutes}m ${seconds}s";
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Mission? mission =
        ref.watch(playerProvider.select((p) => p.currentMission));
    final List<Skill> skills =
        ref.watch(playerProvider.select((p) => p.skills));
    final Map<SkillAttributeType,int> totalBoost =
        ref.watch(playerProvider.select((p) => p.totalSkillBoost));

    if (mission == null) return const SizedBox();

    // if mission changed since last build, hide required values
    if (_showRequired && mission != _lastMission) {
      _showRequired = false;
    }
    _lastMission = mission;

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

    final Map<SkillAttributeType, int> collectedPoints = {
      for (final attr in SkillAttributeType.values) attr: 0,
    };

    final Map<SkillAttributeType, int> boostPoints = {
      for (final attr in SkillAttributeType.values) attr: totalBoost[attr] ?? 0,
    };

    void addSkillAttributes(String? skillId) {
      if (skillId == null || skillId == "none") return;

      final index = int.tryParse(skillId);
      if (index == null || index < 0 || index >= skills.length) return;

      final skill = skills[index];

      for (final attr in SkillAttributeType.values) {
        final currentValue = collectedPoints[attr] ?? 0;
        final skillValue = skill.attributes[attr] ?? 0;

        collectedPoints[attr] =
            (currentValue + skillValue).clamp(0, 10);
      }
    }

    addSkillAttributes(firstSelectedSkillId);
    addSkillAttributes(secondSelectedSkillId);


    final List<AttributeChartData> chartData = [];

    for (final entry in collectedPoints.entries) {
      chartData.add(AttributeChartData(entry.key.name, entry.value, series: 'Collected'));
    }

    // include boost values if any
    for (final entry in boostPoints.entries) {
      if (entry.value > 0) {
        chartData.add(AttributeChartData(entry.key.name, entry.value, series: 'Boost'));
      }
    }

    for (final attr in SkillAttributeType.values) {
      final requiredValue = mission.attributeCheck[attr] ?? 0;
      chartData.add(AttributeChartData(attr.name, requiredValue, series: 'Required'));
    }

    String getTitle(String? id) {
      return selectableSkills
          .firstWhere((e) => e.id == id,
              orElse: () => selectableSkills.first)
          .title;
    }

    Future<void> _attempt() async {
      // convert selected ids to skill types and perform mission
      if (firstSelectedSkillId == null || secondSelectedSkillId == null) return;
      if (firstSelectedSkillId == "none" || secondSelectedSkillId == "none") {
        // nothing chosen
        return;
      }
      final firstIndex = int.tryParse(firstSelectedSkillId!);
      final secondIndex = int.tryParse(secondSelectedSkillId!);
      if (firstIndex == null || secondIndex == null) return;
      if (firstIndex < 0 || firstIndex >= skills.length) return;
      if (secondIndex < 0 || secondIndex >= skills.length) return;

      final Skill skillA = skills[firstIndex];
      final Skill skillB = skills[secondIndex];
      // mark that we should render required values
      setState(() {
        _showRequired = true;
      });
      final outcome = ref.read(playerProvider.notifier)
          .attemptMission(a: skillA.type, b: skillB.type);
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text(outcome.success ? 'Mission Success' : 'Mission Failed'),
                content: Text(outcome.success
                    ? 'You earned xp and possibly a reward.'
                    : 'Try again later.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'))
                ],
              ));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          // Timer section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                const Text(
                  '⏱️',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Mission Ready In',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                      Text(
                        _nextMissionRefreshTimer,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Mission card
          MissionCard(mission: mission),
          // Boost info
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
                            color: Theme.of(context).colorScheme.onTertiaryContainer,
                          ),
                        ),
                        Text(
                          totalBoost.entries
                              .where((e) => e.value > 0)
                              .map((e) => '${e.key.name} +${e.value}')
                              .join(' • '),
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.onTertiaryContainer,
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
          // Attempt button
          Row(
            children: [
              Expanded(
                child: AnimatedOpacity(
                  opacity: mission != null ? 1.0 : 0.5,
                  duration: const Duration(milliseconds: 200),
                  child: FilledButton.icon(
                    onPressed: mission != null ? _attempt : null,
                    icon: const Text('⚔️', style: TextStyle(fontSize: 18)),
                    label: const Text(
                      'Attempt Mission',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      disabledBackgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Chart section with label
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Attribute Comparison',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 320,
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
                  legend: Legend(isVisible: true, position: LegendPosition.bottom),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries>[
                    LineSeries<AttributeChartData, String>(
                      name: 'Collected',
                      dataSource: chartData.where((d) => d.series == 'Collected').toList(),
                      xValueMapper: (AttributeChartData data, _) => data.attribute,
                      yValueMapper: (AttributeChartData data, _) => data.value,
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.5,
                      markerSettings: const MarkerSettings(isVisible: true, width: 6, height: 6),
                    ),
                    // always render boost series if boost exists
                    if (boostPoints.values.any((v) => v > 0))
                      LineSeries<AttributeChartData, String>(
                        name: 'Boost',
                        dataSource: chartData.where((d) => d.series == 'Boost').toList(),
                        xValueMapper: (AttributeChartData data, _) => data.attribute,
                        yValueMapper: (AttributeChartData data, _) => data.value,
                        color: Theme.of(context).colorScheme.tertiary,
                        width: 2.5,
                        markerSettings: const MarkerSettings(isVisible: true, width: 6, height: 6),
                      ),
                    if (_showRequired)
                      LineSeries<AttributeChartData, String>(
                        name: 'Required',
                        dataSource: chartData.where((d) => d.series == 'Required').toList(),
                        xValueMapper: (AttributeChartData data, _) => data.attribute,
                        yValueMapper: (AttributeChartData data, _) => data.value,
                        color: Theme.of(context).colorScheme.error,
                        width: 2.5,
                        markerSettings: const MarkerSettings(isVisible: true, width: 6, height: 6),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 24),
          // Skill selectors with better styling
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Select Skills',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SelectBottomList(
            titleTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            selectedTitleStyle: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary),
            data: selectableSkills,
            selectedId: firstSelectedSkillId!,
            selectedTitle: getTitle(firstSelectedSkillId),
            onChange: (id, title) {
              setState(() {
                firstSelectedSkillId = id;
              });
            },
            isDisable: false,
          ),
          const SizedBox(height: 12),
          SelectBottomList(
            titleTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            selectedTitleStyle: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary),
            data: selectableSkills,
            selectedId: secondSelectedSkillId!,
            selectedTitle: getTitle(secondSelectedSkillId),
            onChange: (id, title) {
              setState(() {
                secondSelectedSkillId = id;
              });
            },
            isDisable: false,
          ),
        ],
      ),
    );
  }
}