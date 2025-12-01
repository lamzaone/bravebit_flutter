import 'package:bravebit_flutter/utils/haptics.dart';
import 'package:bravebit_flutter/widgets/glass_card.dart';
import 'package:bravebit_flutter/widgets/gold_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    Connectivity().checkConnectivity().then((result) {
      setState(() => _isOffline = result == ConnectivityResult.none);
    });
  }

  Future<void> _signup() async {
    if (_isOffline) {
      setState(() => _error = 'You appear to be offline. Please check your internet connection.');
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });
    triggerHapticFeedback();
    try {
      await Supabase.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signup successful! Check your email to confirm.')));
        Navigator.pushReplacementNamed(context, '/auth/login');
      }
    } catch (e) {
      setState(() => _error = (e as AuthException).message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/LOGO2.png', width: 120, height: 120),
              const SizedBox(height: 40),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    if (_error != null) Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(_error!, style: const TextStyle(color: Colors.red)),
                    ),
                    const SizedBox(height: 32),
                    GoldButton(text: 'Join BraveBit', size: 'login', isLoading: _isLoading, onPressed: _signup),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? '),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/auth/login'),
                    child: const Text('Log In', style: TextStyle(color: Color(0xFFB28A2F))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}