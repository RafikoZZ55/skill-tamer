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
                      widget.mission.type.name.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            letterSpacing: 1.5,
                            color: scheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 1.0,
                color: scheme.primary.withAlpha(26),
              ),
              const SizedBox(height: 12),
              Text(
                widget.mission.type.description.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.primary.withAlpha(179),
                      height: 1.6,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
