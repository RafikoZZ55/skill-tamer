import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SessionTimerView extends ConsumerStatefulWidget {
  const SessionTimerView({super.key});

  @override
  createState() => _SessionTimerViewState();
}

class _SessionTimerViewState extends ConsumerState<SessionTimerView> {
  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 30,
        children: [
          Stack(
            alignment: AlignmentGeometry.center,
            children: [
              Text("00:00",
              style: TextStyle(
                fontSize: 50,
              ),
              ),

              SizedBox(
                width: 300,
                height: 300,
                child: CircularProgressIndicator(
                  value: 0.95,
                  backgroundColor: scheme.onPrimary,
                  color: scheme.primary,
                  strokeWidth: 20,
                ),
              )
            ],
          ),

          SizedBox(
            width: 150,
            child: FilledButton(
              onPressed: () {},
              child: Text("Start")
            ),
          )
        ],
      ),
    );
  }
}