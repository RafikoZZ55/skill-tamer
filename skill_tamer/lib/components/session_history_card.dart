import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/model/enum/session_status_type.dart';
import 'package:skill_tamer/data/model/session/session_history.dart';

class SessionHistoryCard extends ConsumerWidget {
  const SessionHistoryCard({ super.key, required this.sessionHistory });
  final SessionHistory sessionHistory;

  String _formatDuration(int durationMs) {
    final duration = Duration(milliseconds: durationMs);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return "${hours}h ${minutes}m";
    }
    if (minutes > 0) {
      return "${minutes}m ${seconds}s";
    }
    return "${seconds}s";
  }

  String _formatCompletedAt(int milliseconds) {
    final date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    final hh = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');

    return "$mm/$dd/${date.year} $hh:$min";
  }

  String _formatRatio(double ratio) {
    return "${(ratio * 100).clamp(0, 999).toStringAsFixed(0)}%";
  }

  double _completionRatio() {
    final recommendedMs =
        sessionHistory.skillType.recommendedSessionDuration.inMilliseconds;
    if (recommendedMs <= 0) return 0;
    return sessionHistory.duration / recommendedMs;
  }

  int _baseXpEstimate() {
    return sessionHistory.duration ~/ 1000;
  }

  _StatusUi _statusUi(SessionStatusType status) {
    switch (status) {
      case SessionStatusType.fullyCompleted:
        return const _StatusUi(label: "Fully completed", color: Colors.greenAccent);
      case SessionStatusType.completed:
        return const _StatusUi(label: "Completed", color: Colors.lightBlueAccent);
      case SessionStatusType.abandoned:
        return const _StatusUi(label: "Abandoned", color: Colors.orangeAccent);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusUi = _statusUi(sessionHistory.status);
    final completionRatio = _completionRatio();

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "${sessionHistory.skillType.icon} ${sessionHistory.skillType.name}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusUi.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: statusUi.color.withValues(alpha: 0.55)),
                  ),
                  child: Text(
                    statusUi.label,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: statusUi.color,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Duration: ${_formatDuration(sessionHistory.duration)}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoPill(
                  text:
                      "Target ${sessionHistory.skillType.recommendedSessionDuration.inMinutes}m",
                ),
                _InfoPill(text: "Completion ${_formatRatio(completionRatio)}"),
                _InfoPill(text: "Base XP ~${_baseXpEstimate()}"),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Finished: ${_formatCompletedAt(sessionHistory.completedAt)}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

class _StatusUi {
  const _StatusUi({required this.label, required this.color});

  final String label;
  final Color color;
}