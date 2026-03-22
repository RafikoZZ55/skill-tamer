import 'package:flutter/material.dart';

class CompletedMissionInfo extends StatelessWidget {
const CompletedMissionInfo({ super.key });

  @override
  Widget build(BuildContext context){
    return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.check_box_outlined, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'MISSION COMPLETED – WAITING FOR REFRESH',
                        style: TextStyle(
                          color: Colors.white.withAlpha(230),
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }
}