import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/model/mission/mission.dart';

class MissionCard extends ConsumerStatefulWidget {
  const MissionCard({super.key, required this.mission});
  final Mission mission;

  @override
  createState() => _MissionCardState();
}

class _MissionCardState extends ConsumerState<MissionCard> {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.mission.type.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: scheme.onPrimaryContainer,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  height: 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        scheme.primary,
                        scheme.primary.withAlpha(40),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.mission.type.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: scheme.onPrimaryContainer.withAlpha(160),
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
