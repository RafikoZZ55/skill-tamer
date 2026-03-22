import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:select_bottom_list/select_bottom_list.dart';
import 'package:skill_tamer/components/session_multiplyer_card.dart';
import 'package:skill_tamer/data/constant/app_durations.dart';
import 'package:skill_tamer/data/model/session/session.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';

class SessionTimerView extends ConsumerStatefulWidget {
  const SessionTimerView({super.key});

  @override
  ConsumerState<SessionTimerView> createState() => _SessionTimerViewState();
}

class _SessionTimerViewState extends ConsumerState<SessionTimerView> {
  String? firstSelectedSkillId;
  Timer? _timer;

  Duration _remaining = Duration.zero;
  Duration _total = Duration.zero;

  bool _showingAbandonDialog = false;
  DateTime? _abandonPopupStart;
  final ValueNotifier<Duration> _popupRemainingNotifier = ValueNotifier(
    Duration.zero,
  );

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

    _timer = Timer.periodic(AppDurations.oneSecond, (_) {
      final Session? session = ref.read(playerProvider).activeSession;

      if (session == null) {
        if (_remaining != Duration.zero || _total != Duration.zero) {
          setState(() {
            _remaining = Duration.zero;
            _total = Duration.zero;
          });
        }

        if (_showingAbandonDialog) {
          if (mounted) {
            Navigator.of(context, rootNavigator: true).maybePop();
          }

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
      final newRemaining = remainingMs <= 0
          ? Duration.zero
          : Duration(milliseconds: remainingMs);

      final now = DateTime.now();
      if (!_showingAbandonDialog &&
          nowMs - session.lastSessionCheck >
              AppDurations.sessionAbandonedCheckDuration.inMilliseconds) {
        _abandonPopupStart = now;
        _popupRemainingNotifier.value =
            AppDurations.sessionAbandonPopupDuration;
        _showAbandonDialog();
      } else if (_showingAbandonDialog && _abandonPopupStart != null) {
        final elapsedPopup = now.difference(_abandonPopupStart!);
        final remainingPopup =
            AppDurations.sessionAbandonPopupDuration - elapsedPopup;
        if (remainingPopup <= Duration.zero) {
          _popupRemainingNotifier.value = Duration.zero;
          _endAbandonSession();
        } else {
          _popupRemainingNotifier.value = remainingPopup;
        }
      }

      setState(() {
        _remaining = newRemaining;
      });
    });
  }

  String _format(Duration d) {
    final String minutes = max(d.inMinutes, 0).remainder(60).toString().padLeft(2, '0');
    final String seconds = max(d.inSeconds, 0).remainder(60).toString().padLeft(2, '0');
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
              'To keep users from spaming sessions while they sleep you need to interact with the app every ${AppDurations.sessionAbandonedCheckDuration.inMinutes} minutes your time windfow is ${AppDurations.sessionAbandonPopupDuration.inMinutes} minutes'
              'Tap "Continue" within ${_format(value)} to keep going, '
              'if you wont do it you will get smaller rewards',
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

    final Session? session = ref.watch(
      playerProvider.select((p) => p.activeSession),
    );

    final skills = ref.read(playerProvider).skills;
    final List<SelectItem> selectableSkills = [
      const SelectItem(id: "none", title: "Select Skill"),
      ...List.generate(
        skills.length,
        (index) => SelectItem(
          id: index.toString(),
          title: "${skills[index].type.icon}   ${skills[index].type.name}",
        ),
      ),
    ];

    firstSelectedSkillId ??= selectableSkills.first.id;

    String getTitle(String? id) {
      return selectableSkills
          .firstWhere((e) => e.id == id, orElse: () => selectableSkills.first)
          .title;
    }

    final progress = (_total.inSeconds == 0)
        ? 0.0
        : 1 - (_remaining.inSeconds / _total.inSeconds);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (session != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                '${session.sessionSkill.icon} ${session.sessionSkill.name.toUpperCase()}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: scheme.primary,
                ),
              ),
            ),
          ],
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                _format(_remaining),
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                  color: scheme.primary,
                ),
              ),
              SizedBox(
                width: 280,
                height: 280,
                child: CircularProgressIndicator(
                  value: progress.clamp(0, 1),
                  strokeWidth: 4,
                  color: scheme.primary,
                  backgroundColor: scheme.primary.withAlpha(26),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: (session == null &&
                            (firstSelectedSkillId == null || firstSelectedSkillId == 'none'))
                        ? null
                        : () {
                            if (session == null) {
                              final idx = int.tryParse(firstSelectedSkillId!);
                              if (idx != null && idx >= 0 && idx < skills.length) {
                                controller.createNewSession(
                                  skillType: skills[idx].type,
                                );
                              }
                            } else {controller.stopSession(manual: true);}
                          },
                    style: FilledButton.styleFrom(
                      backgroundColor: scheme.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      disabledBackgroundColor: scheme.primary.withAlpha(26),
                      disabledForegroundColor: scheme.primary.withAlpha(77),
                    ),
                    child: Text(
                      (session == null ? "START SESSION" : "TERMINATE SESSION").toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SelectBottomList(
                  titleTextStyle: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: scheme.primary.withAlpha(128)),
                  selectedTitleStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: scheme.primary),
                  data: selectableSkills,
                  selectedId: firstSelectedSkillId!,
                  selectedTitle: getTitle(firstSelectedSkillId).toUpperCase(),
                  onChange: (id, title) =>
                      setState(() => firstSelectedSkillId = id),
                  isDisable: session != null,
                ),
                const SizedBox(height: 16),
                if (session != null) SessionMultiplyerCard(),
                const SizedBox(height: 16),
                session != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () => controller.updateSessionCheck(),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: scheme.primary, width: 1),
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Text(
                                "VALIDATE CONTEXT",
                                style: TextStyle(color: scheme.primary, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              "NEXT VALIDATION IN: ${_format(Duration(milliseconds: (session.lastSessionCheck + AppDurations.sessionAbandonedCheckDuration.inMilliseconds) - DateTime.now().millisecondsSinceEpoch))}",
                              style: TextStyle(
                                fontSize: 10,
                                color: scheme.primary.withAlpha(102),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
