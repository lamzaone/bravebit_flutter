import 'package:bravebit_flutter/screens/mission_log_screen.dart';
import 'package:bravebit_flutter/screens/profile_screen.dart';
import 'package:bravebit_flutter/utils/haptics.dart';
import 'package:bravebit_flutter/widgets/glass_card.dart';
import 'package:bravebit_flutter/widgets/gold_button.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/LOGO2.png', width: 250, height: 250),
              const SizedBox(height: 40),
              if (user == null) ...[
                const Text('Welcome to BraveBit', style: TextStyle(color: Colors.grey, fontSize: 18)),
                const SizedBox(height: 16),
                const Text('Build your confidence one mission at a time', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 32),
                GoldButton(text: 'Log In', size: 'login', onPressed: () => Navigator.pushNamed(context, '/auth/login')),
                const SizedBox(height: 16),
                GoldButton(text: 'Join BraveBit', size: 'login', variant: 'secondary', onPressed: () => Navigator.pushNamed(context, '/auth/signup')),
              ] else ...[
                GlassCard(
                  child: Column(
                    children: [
                      const Text('Current Mission', style: TextStyle(color: Color(0xFFB28A2F), fontSize: 18)),
                      const SizedBox(height: 16),
                      const Text("Compliment a stranger's outfit", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 32),
                      GoldButton(
                        text: 'Begin Your Mission',
                        size: 'xl',
                        onPressed: () {
                          triggerHapticFeedback();
                          Navigator.pushNamed(context, '/mission/prep');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/mission-log'),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.book, color: Color(0xFFB28A2F), size: 16),
                      SizedBox(width: 8),
                      Text('View Mission Log', style: TextStyle(color: Color(0xFFB28A2F))),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFFB28A2F),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          triggerHapticFeedback();
          if (index == 1) Navigator.pushNamed(context, '/mission-log');
          if (index == 2) Navigator.pushNamed(context, '/profile');
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