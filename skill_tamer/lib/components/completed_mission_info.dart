import 'package:flutter/material.dart';

class CompletedMissionInfo extends StatelessWidget {
const CompletedMissionInfo({ super.key });

  @override
  Widget build(BuildContext context){
    return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.green),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Mission completed – waiting for refresh.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }
}