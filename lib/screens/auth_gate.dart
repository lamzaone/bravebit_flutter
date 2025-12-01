import 'package:bravebit_flutter/screens/home_screen.dart';
import 'package:bravebit_flutter/screens/login_screen.dart';
import 'package:bravebit_flutter/widgets/gold_loader.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      setState(() => _user = data.session?.user);
    });
  }

  Future<void> _checkSession() async {
    final session = Supabase.instance.client.auth.currentSession;
    setState(() {
      _user = session?.user;
      _isLoading = false;
    });
    if (_user != null) {
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: GoldLoader()));
    }
    return _user == null ? const LoginScreen() : const HomeScreen();
  }
}