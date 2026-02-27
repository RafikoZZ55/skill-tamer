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

    if (mission == null) return const SizedBox();

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

    /// ---- COLLECTED ATTRIBUTE CALCULATION ----

    final Map<SkillAttributeType, int> collectedPoints = {
      for (final attr in SkillAttributeType.values) attr: 0,
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Text("  next mission: $_nextMissionRefreshTimer"),
          MissionCard(mission: mission),

      SizedBox(
  height: 300,
  child: SfCartesianChart(
    primaryXAxis: CategoryAxis(),
    primaryYAxis: NumericAxis(
      minimum: 0,
      maximum: 10,
      interval: 2,
    ),
    legend: Legend(isVisible: true),
    tooltipBehavior: TooltipBehavior(enable: true),
    series: <CartesianSeries>[
      LineSeries<AttributeChartData, String>(
        name: 'Collected',
        dataSource: chartData.where((d) => d.series == 'Collected').toList(),
        xValueMapper: (AttributeChartData data, _) => data.attribute,
        yValueMapper: (AttributeChartData data, _) => data.value,
        color: Colors.blue,
        width: 2,
        markerSettings: const MarkerSettings(isVisible: true),
      ),
      LineSeries<AttributeChartData, String>(
        name: 'Required',
        dataSource: chartData.where((d) => d.series == 'Required').toList(),
        xValueMapper: (AttributeChartData data, _) => data.attribute,
        yValueMapper: (AttributeChartData data, _) => data.value,
        color: Colors.red,
        width: 2,
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ],
  ),
),  

          const Divider(),

          SelectBottomList(
            titleTextStyle: const TextStyle(fontSize: 18),
            selectedTitleStyle: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold),
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

          SelectBottomList(
            titleTextStyle: const TextStyle(fontSize: 18),
            selectedTitleStyle: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold),
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