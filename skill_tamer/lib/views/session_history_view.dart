import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/components/session_history_card.dart';
import 'package:skill_tamer/data/model/enum/skill_type.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';

class SessionHistoryView extends ConsumerStatefulWidget {
  const SessionHistoryView({ super.key });

  @override
  ConsumerState<SessionHistoryView> createState() => _SessionHistoryViewState();
}

class _SessionHistoryViewState extends ConsumerState<SessionHistoryView> {
  SkillType? _selectedSkillType;

  @override
  Widget build(BuildContext context) {
    final sessionsHistory = ref.watch(
      playerProvider.select((p) => p.sessionsHistory),
    );

    final filteredSessions = _selectedSkillType == null
        ? sessionsHistory
        : sessionsHistory
            .where((session) => session.skillType == _selectedSkillType)
            .toList();

    filteredSessions.sort((a, b) => b.completedAt.compareTo(a.completedAt));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Filter by skill",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: const Text("All"),
                    selected: _selectedSkillType == null,
                    onSelected: (_) => setState(() => _selectedSkillType = null),
                  ),
                ),
                ...SkillType.values.map(
                  (skillType) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text("${skillType.icon} ${skillType.name}"),
                      selected: _selectedSkillType == skillType,
                      onSelected: (_) =>
                          setState(() => _selectedSkillType = skillType),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filteredSessions.isEmpty
                ? Center(
                    child: Text(
                      _selectedSkillType == null
                          ? "No session history yet."
                          : "No sessions for ${_selectedSkillType!.name} yet.",
                    ),
                  )
                : ListView.separated(
                    itemCount: filteredSessions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => SessionHistoryCard(
                      sessionHistory: filteredSessions[index],
                    ),
                  ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}