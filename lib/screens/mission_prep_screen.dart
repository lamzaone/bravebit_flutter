import 'package:bravebit_flutter/widgets/glass_card.dart';
import 'package:bravebit_flutter/widgets/gold_button.dart';
import 'package:flutter/material.dart';

class MissionPrepScreen extends StatelessWidget {
  const MissionPrepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mission Prep')),
      body: Center(
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Prepare for: Compliment a stranger\'s outfit', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 16),
              const Text('Tips: Be sincere, smile, keep it brief.'),
              const SizedBox(height: 32),
              GoldButton(text: 'Start Mission', onPressed: () {
                // Navigate to log or complete
              }),
            ],
          ),
        ),
      ),
    );
  }
}