import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/model/enum/skill_type.dart';
import 'package:skill_tamer/data/model/session/session.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';

class SessionTimerView extends ConsumerStatefulWidget {
  const SessionTimerView({super.key});

  @override
  ConsumerState<SessionTimerView> createState() =>
      _SessionTimerViewState();
}

class _SessionTimerViewState
    extends ConsumerState<SessionTimerView> {
  SkillType? skillType;
  Timer? _timer;

  Duration _remaining = Duration.zero;
  Duration _total = Duration.zero;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(Session session) {
    _timer?.cancel();

    _total = session.sessionSkill.recommendedSessionDuration;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final elapsed = now - session.timeStarted;

      final remainingMs =
          _total.inMilliseconds - elapsed;

      if (remainingMs <= 0) {
        setState(() {
          _remaining = Duration.zero;
        });
      } else {
        setState(() {
          _remaining =
              Duration(milliseconds: remainingMs);
        });
      }
    });
  }

  String _format(Duration d) {
    final minutes =
        d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final controller =
        ref.read(playerProvider.notifier);

    final Session? session =
        ref.watch(playerProvider.select((p) => p.activeSession));

    if (session != null && _timer == null) {
      _startTimer(session);
    }

    if (session == null) {
      _timer?.cancel();
      _timer = null;
      _remaining = Duration.zero;
      _total = Duration.zero;
    }

    final progress = (_total.inSeconds == 0)
        ? 0.0
        : 1 - (_remaining.inSeconds / _total.inSeconds);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          /// TIMER
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                _format(_remaining),
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 280,
                height: 280,
                child: CircularProgressIndicator(
                  value: progress.clamp(0, 1),
                  strokeWidth: 18,
                  color: scheme.primary,
                  backgroundColor:
                      scheme.surfaceContainerHighest,
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              children: [

                /// START / STOP
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: skillType == null
                        ? null
                        : () {
                            if (session == null) {
                              controller.createNewSession(
                                  skillType: skillType!);
                            } else {
                              controller.stopSession();
                            }
                          },
                    child:
                        Text(session == null ? "Start" : "Stop"),
                  ),
                ),

                const SizedBox(height: 12),

                /// SELECT SKILL
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: session != null
                        ? null
                        : () async {
                            final selected =
                                await showModalBottomSheet<
                                    SkillType>(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) =>
                                  const _SkillSelectionSheet(),
                            );

                            if (selected != null) {
                              setState(() {
                                skillType = selected;
                              });
                            }
                          },
                    child: skillType == null
                        ? const Text("Select Skill")
                        : Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                skillType!.icon,
                                style: const TextStyle(
                                    fontSize: 20),
                              ),
                              const SizedBox(width: 8),
                              Text(skillType!.name),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillSelectionSheet extends StatelessWidget {
  const _SkillSelectionSheet();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const Text(
            "Select Skill",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              itemCount: SkillType.values.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final skill = SkillType.values[index];

                return InkWell(
                  borderRadius:
                      BorderRadius.circular(16),
                  onTap: () =>
                      Navigator.pop(context, skill),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          scheme.primaryContainer,
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    padding:
                        const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          skill.icon,
                          style: const TextStyle(
                              fontSize: 36),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          skill.name,
                          textAlign:
                              TextAlign.center,
                          style: const TextStyle(
                              fontWeight:
                                  FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}