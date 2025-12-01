import 'package:bravebit_flutter/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bravebit_flutter/utils/haptics.dart';

class MissionLogScreen extends StatefulWidget {
  const MissionLogScreen({super.key});

  @override
  State<MissionLogScreen> createState() => _MissionLogScreenState();
}

class _MissionLogScreenState extends State<MissionLogScreen> {
  List<Map<String, dynamic>> _logs = [];

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    final response = await Supabase.instance.client
        .from('missions_log')
        .select()
        .eq('user_id', Supabase.instance.client.auth.currentUser?.id ?? '');
    setState(() => _logs = response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text('Mission Log', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    final log = _logs[index];
                    return GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Text('${log['mission_type']}: ${log['status']} on ${log['created_at']}'),
                    );
                  },
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
        currentIndex: 1,
        onTap: (index) {
          triggerHapticFeedback();
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 2) Navigator.pushReplacementNamed(context, '/profile');
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