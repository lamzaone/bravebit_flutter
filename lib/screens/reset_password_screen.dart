import 'package:bravebit_flutter/utils/haptics.dart';
import 'package:bravebit_flutter/widgets/glass_card.dart';
import 'package:bravebit_flutter/widgets/gold_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _message;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    Connectivity().checkConnectivity().then((result) {
      setState(() => _isOffline = result == ConnectivityResult.none);
    });
  }

  Future<void> _resetPassword() async {
    if (_isOffline) {
      setState(() => _message = 'You appear to be offline. Please check your internet connection.');
      return;
    }
    setState(() {
      _isLoading = true;
      _message = null;
    });
    triggerHapticFeedback();
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(_emailController.text.trim());
      setState(() => _message = 'Password reset link sent! Check your email.');
    } catch (e) {
      setState(() => _message = (e as AuthException).message);
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
              Image.asset('assets/LOGO2.png', width: 250, height: 250),
              const SizedBox(height: 40),
              const Text('Reset Password', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    if (_message != null) Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(_message!, style: TextStyle(color: _message!.contains('sent') ? Colors.green : Colors.red)),
                    ),
                    const SizedBox(height: 32),
                    GoldButton(text: 'Send Reset Link', size: 'login', isLoading: _isLoading, onPressed: _resetPassword),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text('Back to Login', style: TextStyle(color: Color(0xFFB28A2F))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}