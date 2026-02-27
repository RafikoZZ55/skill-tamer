import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/model/mission/mission.dart';

class MissionCard extends ConsumerStatefulWidget {
  const MissionCard({ super.key, required this.mission });
  final Mission mission;

  @override
  createState() => _MissionCardState();
}

class _MissionCardState extends ConsumerState<MissionCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.mission.type.name,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),
              ),
              Divider(),
              Text(widget.mission.type.description,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}