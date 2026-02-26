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
  bool _hadSession = false;
  Timer? _timer;

  Duration _remaining = Duration.zero;
  Duration _total = Duration.zero;

  bool _showingAbandonDialog = false;
  DateTime? _abandonPopupStart;
  final ValueNotifier<Duration> _popupRemainingNotifier =
      ValueNotifier(Duration.zero);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _popupRemainingNotifier.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final Session? session = ref.read(playerProvider).activeSession;

      if (session == null) {
        if (_remaining != Duration.zero || _total != Duration.zero) {
          setState(() {
            _remaining = Duration.zero;
            _total = Duration.zero;
          });
        }

        if (_showingAbandonDialog) {
          if (mounted) {Navigator.of(context, rootNavigator: true).maybePop();}
          
          setState(() {
            _showingAbandonDialog = false;
            _abandonPopupStart = null;
          });
        }
        return;
      }

      if (_total != session.sessionSkill.recommendedSessionDuration) {
        _total = session.sessionSkill.recommendedSessionDuration;
      }

      final nowMs = DateTime.now().millisecondsSinceEpoch;
      final elapsed = nowMs - session.timeStarted;
      final remainingMs = _total.inMilliseconds - elapsed;
      final newRemaining = remainingMs <= 0 ? Duration.zero : Duration(milliseconds: remainingMs);

      final now = DateTime.now();
      if (!_showingAbandonDialog && nowMs - session.lastSessionCheck > const Duration(minutes: 15).inMilliseconds) {

        _abandonPopupStart = now;
        _popupRemainingNotifier.value = const Duration(minutes: 5);
        _showAbandonDialog();
      } else if (_showingAbandonDialog && _abandonPopupStart != null) {
        final elapsedPopup = now.difference(_abandonPopupStart!);
        final remainingPopup = const Duration(minutes: 5) - elapsedPopup;
        if (remainingPopup <= Duration.zero) {
          _popupRemainingNotifier.value = Duration.zero;
          _endAbandonSession();
        } else {
          _popupRemainingNotifier.value = remainingPopup;
        }
      }

      setState(() {_remaining = newRemaining;});
    });
  }

  String _format(Duration d) {
    final minutes =
        d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void _showAbandonDialog() {
    _showingAbandonDialog = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Still there?'),
        content: ValueListenableBuilder<Duration>(
          valueListenable: _popupRemainingNotifier,
          builder: (context, value, _) {
            return Text(
              'To keep users from spaming sessions while they sleep you need to interact with the app every 15 minutes your time windfow is 5 minutes'
              'Tap "Continue" within ${_format(value)} to keep going, '
              'if you wont do it you will get smaller rewards'
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (mounted) {
                ref.read(playerProvider.notifier).updateSessionCheck();
                setState(() {
                  _showingAbandonDialog = false;
                  _abandonPopupStart = null;
                });
              }
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    ).then((_) {
      if (mounted) {
        setState(() {
          _showingAbandonDialog = false;
          _abandonPopupStart = null;
        });
      }
    });
  }

  void _endAbandonSession() {
    ref.read(playerProvider.notifier).stopSession(manual: false);
    if (_showingAbandonDialog && mounted) {
      Navigator.of(context, rootNavigator: true).maybePop();
    }
    setState(() {
      _showingAbandonDialog = false;
      _abandonPopupStart = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final controller = ref.read(playerProvider.notifier);

    final Session? session = ref.watch(playerProvider.select((p) => p.activeSession));
    if (session != null && skillType == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {skillType = session.sessionSkill;});
      });
    }

    if (_hadSession && session == null && skillType != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => skillType = null ));
    }
    _hadSession = session != null;

    final progress = (_total.inSeconds == 0) ? 0.0 : 1 - (_remaining.inSeconds / _total.inSeconds);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (session != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                '${session.sessionSkill.icon} ${session.sessionSkill.name}',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          ],
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
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: (session == null && skillType == null)
                        ? null
                        : () {
                            if (session == null) {
                              controller.createNewSession(
                                  skillType: skillType!);
                            } else {
                              controller.stopSession(manual: true);
                            }
                          },
                    child:
                        Text(session == null ? "Start" : "Stop"),
                  ),
                ),

                const SizedBox(height: 12),

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

                const SizedBox(height: 12),

                session != null ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => controller.updateSessionCheck(), 
                        child: Text("Check Session")
                      ),
                    ),
                    Text("  next check at : ${
                    _format(Duration(milliseconds: (session.lastSessionCheck + Duration(minutes: 15).inMilliseconds) - DateTime.now().millisecondsSinceEpoch))
                  }")
                  ],
                )
                : SizedBox(),


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
            const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Skill",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 5),
          const Divider(),
          const SizedBox(height: 5),
          Expanded(
            child: GridView.builder(
              itemCount: SkillType.values.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 4.5,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text(
                          skill.name,
                          textAlign:TextAlign.center,
                          style: const TextStyle(fontWeight:FontWeight.bold, fontSize: 24),
                        ),
                        Text(
                          skill.icon,
                          style: const TextStyle(fontSize: 36),
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