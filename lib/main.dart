// lib/main.dart
import 'package:bravebit_flutter/screens/auth_gate.dart';
import 'package:bravebit_flutter/screens/home_screen.dart';
import 'package:bravebit_flutter/screens/login_screen.dart';
import 'package:bravebit_flutter/screens/mission_prep_screen.dart';
import 'package:bravebit_flutter/screens/mission_log_screen.dart';
import 'package:bravebit_flutter/screens/reset_password_screen.dart';
import 'package:bravebit_flutter/screens/signup_screen.dart';
import 'package:bravebit_flutter/screens/admin_screen.dart';
import 'package:bravebit_flutter/screens/welcome_screen.dart';
import 'package:bravebit_flutter/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://bfpjgdwcujusrcourxbl.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJmcGpnZHdjdWp1c3Jjb3VyeGJsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA2NDg3MTMsImV4cCI6MjA3NjIyNDcxM30.XTZm-qg_kzsdR7mI4Tb4g1hYBVDbCINt4aJKOAwreCI', // Full key from .env.local
  );
  runApp(const BraveBitApp());
}

class BraveBitApp extends StatelessWidget {
  const BraveBitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BraveBit',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFB28A2F), // Gold
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Satoshi',
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Color(0xFFB28A2F)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Color(0xFFB28A2F), width: 2),
          ),
        ),
      ),
      home: const AuthGate(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/auth/login': (context) => const LoginScreen(),
        '/auth/signup': (context) => const SignupScreen(),
        '/auth/reset-password': (context) => const ResetPasswordScreen(),
        '/mission/prep': (context) => const MissionPrepScreen(),
        '/mission-log': (context) => const MissionLogScreen(),
        '/admin': (context) => const AdminScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/welcome': (context) => const WelcomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}