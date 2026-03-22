import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:select_bottom_list/select_bottom_list.dart';
import 'package:skill_tamer/components/session_history_card.dart';
import 'package:skill_tamer/data/model/enum/skill_type.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';

class SessionHistoryView extends ConsumerStatefulWidget {
  const SessionHistoryView({super.key});

  @override
  ConsumerState<SessionHistoryView> createState() =>
      _SessionHistoryViewState();
}

class _SessionHistoryViewState
    extends ConsumerState<SessionHistoryView> {

  String selectedSkillId = "all";

  @override
  Widget build(BuildContext context) {
    final sessionsHistory =
        ref.watch(playerProvider.select((p) => p.sessionsHistory));

    final skills =
        ref.watch(playerProvider.select((p) => p.skills));

    final List<SelectItem> selectableSkills = [
      const SelectItem(id: "all", title: "all"),
      ...skills.map(
        (e) => SelectItem(
          id: e.type.name,
          title: "${e.type.icon}  ${e.type.name}",
        ),
      )
    ];

    String getTitle(String id) {
      final item = selectableSkills.firstWhere(
        (e) => e.id == id,
        orElse: () => selectableSkills.first,
      );
      return item.title;
    }

    // Wyliczamy SkillType dynamicznie
    SkillType? selectedSkillType =
        selectedSkillId == "all"
            ? null
            : SkillType.values.firstWhere(
                (e) => e.name == selectedSkillId,
                orElse: () => SkillType.values.first,
              );

    final filteredSessions = selectedSkillType == null
        ? sessionsHistory
        : sessionsHistory
            .where(
              (session) =>
                  session.skillType == selectedSkillType,
            )
            .toList();

    filteredSessions.sort(
      (a, b) => b.completedAt.compareTo(a.completedAt),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Expanded(
            child: filteredSessions.isEmpty
                ? Center(
                    child: Text(
                      selectedSkillType == null
                          ? "No session history yet."
                          : "No sessions for ${selectedSkillType.name} yet.",
                    ),
                  )
                : ListView.separated(
                    itemCount: filteredSessions.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) =>
                        SessionHistoryCard(
                      sessionHistory:
                          filteredSessions[index],
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              "FILTER BY SKILL",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary.withAlpha(128),
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 4),
          SelectBottomList(
            titleTextStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary.withAlpha(128),
              letterSpacing: 1.0,
            ),
            selectedTitleStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 1.2,
            ),
            data: selectableSkills,
            selectedId: selectedSkillId,
            selectedTitle: getTitle(selectedSkillId).toUpperCase(),
            onChange: (id, title) {
              setState(() {
                selectedSkillId = id == "ALL" ? "all" : id;
              });
            },
            isDisable: false,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}