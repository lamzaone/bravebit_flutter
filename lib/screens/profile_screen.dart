import 'package:bravebit_flutter/utils/haptics.dart';
import 'package:bravebit_flutter/widgets/glass_card.dart';
import 'package:bravebit_flutter/widgets/gold_button.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    triggerHapticFeedback();
    await Supabase.instance.client.auth.signOut();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/auth/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final email = user?.email ?? 'Unknown';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              GlassCard(
                child: Column(
                  children: [
                    const Icon(Icons.person, size: 80, color: Color(0xFFB28A2F)),
                    const SizedBox(height: 16),
                    Text('Email: $email', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 32),
                    // Add stats if available, e.g., missions completed
                    const Text('Missions Completed: 5', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 32),
                    GoldButton(
                      text: 'Logout',
                      onPressed: () => _logout(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFFB28A2F),
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        onTap: (index) {
          triggerHapticFeedback();
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 1) Navigator.pushReplacementNamed(context, '/mission-log');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Log'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}