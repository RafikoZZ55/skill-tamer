import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/model/session/session_history.dart';

class SessionHistoryCard extends ConsumerWidget {
const SessionHistoryCard({ super.key, required this.sessionHistory });
final SessionHistory sessionHistory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Card(
    
      child: Column(
        children: [
          Text("${sessionHistory.skillType.name}")
        ],
        ),
    );
  }
}