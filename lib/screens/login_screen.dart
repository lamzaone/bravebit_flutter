import 'package:bravebit_flutter/utils/haptics.dart';
import 'package:bravebit_flutter/widgets/glass_card.dart';
import 'package:bravebit_flutter/widgets/gold_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  Future<void> _login() async {
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
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (context.mounted) Navigator.pushReplacementNamed(context, '/welcome');
    } catch (e) {
      setState(() => _error = (e as AuthException).message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _magicLink() async {
    // Implement OTP sign in
    if (_isOffline) return;
    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.signInWithOtp(
        email: _emailController.text.trim(),
      );
      setState(() => _error = 'Magic link sent!');
    } catch (e) {
      setState(() => _error = e.toString());
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
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/auth/reset-password'),
                        child: const Text('Forgot password?', style: TextStyle(color: Color(0xFFB28A2F))),
                      ),
                    ),
                    if (_error != null) Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(_error!, style: const TextStyle(color: Colors.red)),
                    ),
                    const SizedBox(height: 32),
                    GoldButton(text: 'Log In', size: 'login', isLoading: _isLoading, onPressed: _login),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0x33B28A2F)),
                    const SizedBox(height: 16),
                    GoldButton(text: 'Login with Magic Link', size: 'login', variant: 'secondary', isLoading: _isLoading, onPressed: _magicLink),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/auth/signup'),
                    child: const Text('Join BraveBit', style: TextStyle(color: Color(0xFFB28A2F))),
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