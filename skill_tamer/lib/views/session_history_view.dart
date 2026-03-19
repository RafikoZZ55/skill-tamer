import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/components/session_history_card.dart';
import 'package:skill_tamer/data/model/session/session_history.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';

class SessionHistoryView extends ConsumerWidget {
const SessionHistoryView({ super.key });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<SessionHistory> sessionsHistory = ref.watch(playerProvider.select((p) => p.sessionsHistory));
    
    return Column(
      children: sessionsHistory.map((e) => SessionHistoryCard(sessionHistory: e)).toList(),
    );
  }
}