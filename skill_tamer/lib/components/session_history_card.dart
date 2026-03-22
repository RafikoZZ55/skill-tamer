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

  _StatusUi _statusUi(SessionStatusType status, ColorScheme scheme) {
    switch (status) {
      case SessionStatusType.fullyCompleted:
        return _StatusUi(label: "FULLY COMPLETED", color: scheme.primary);
      case SessionStatusType.completed:
        return _StatusUi(label: "COMPLETED", color: scheme.primary.withAlpha(179));
      case SessionStatusType.abandoned:
        return _StatusUi(label: "ABANDONED", color: scheme.primary.withAlpha(102));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final statusUi = _statusUi(sessionHistory.status, scheme);
    final completionRatio = _completionRatio();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "${sessionHistory.skillType.icon} ${sessionHistory.skillType.name.toUpperCase()}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: scheme.primary,
                    letterSpacing: 1.1,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: statusUi.color.withAlpha(128)),
                  ),
                  child: Text(
                    statusUi.label,
                    style: TextStyle(
                      color: statusUi.color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "DURATION: ${_formatDuration(sessionHistory.duration).toUpperCase()}",
              style: TextStyle(
                fontSize: 12,
                color: scheme.primary.withAlpha(179),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoPill(
                  text:
                      "TARGET ${sessionHistory.skillType.recommendedSessionDuration.inMinutes}M",
                ),
                _InfoPill(text: "PROGRESS ${_formatRatio(completionRatio)}"),
                _InfoPill(text: "XP ~${_baseXpEstimate()}"),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "FINISHED: ${_formatCompletedAt(sessionHistory.completedAt)}",
              style: TextStyle(
                fontSize: 10,
                color: scheme.primary.withAlpha(102),
                letterSpacing: 0.5,
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
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.primary.withAlpha(13),
        border: Border.all(color: scheme.primary.withAlpha(26)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: scheme.primary.withAlpha(179),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _StatusUi {
  const _StatusUi({required this.label, required this.color});

  final String label;
  final Color color;
}