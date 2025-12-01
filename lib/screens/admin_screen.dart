
import 'package:bravebit_flutter/widgets/gold_button.dart';
import 'package:bravebit_flutter/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) { // TODO: Add real admin check from user metadata
      return const Scaffold(body: Center(child: Text('Access Denied')));
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text('Admin Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              GlassCard(child: const Text('Supabase URL: https://bfpjgdwcujusrcourxbl.supabase.co')), // Mock env
              const SizedBox(height: 16),
              GoldButton(text: 'Return to App', variant: 'secondary', onPressed: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}