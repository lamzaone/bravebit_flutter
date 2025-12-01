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
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://bfpjgdwcujusrcourxbl.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJmcGpnZHdjdWp1c3Jjb3VyeGJsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA2NDg3MTMsImV4cCI6MjA3NjIyNDcxM30.XTZm-qg_kzsdR7mI4Tb4g1hYBVDbCINt4aJKOAwreCI', // Full key from .env.local
  );

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('f91dd2f8-e3c8-4608-a073-6d3de28a8a43');
  OneSignal.Notifications.requestPermission(true);

  OneSignal.User.pushSubscription.addObserver((state) {
  final token = state.current.token;
  if (token != null) {
    Supabase.instance.client
      .from('user_devices')
      .upsert({
        'user_id': Supabase.instance.client.auth.currentUser!.id,
        'token': token,
      });
  }
});


  // ask for permissions (iOS)
  OneSignal.Notifications.requestPermission(true).then((accepted) {
    print('Accepted permission: $accepted');
  });

  // token observer — when device/player id is available, save it
  final token = OneSignal.User.pushSubscription.id;
  final user = Supabase.instance.client.auth.currentUser;
  if (token != null && user != null) {
    await Supabase.instance.client.from('user_devices').upsert({
      'user_id': user.id,
      'token': token,
      'provider': 'onesignal',
    });
  }

  // listener for changes (token update)
  OneSignal.User.pushSubscription.addObserver((state) async {
    final token = state.current.token;
    final user = Supabase.instance.client.auth.currentUser;
    if (token != null && user != null) {
      await Supabase.instance.client.from('user_devices').upsert({
        'user_id': user.id,
        'token': token,
        'provider': 'onesignal',
      });
    }
  });

  // when user taps a notification - handle navigation
  OneSignal.Notifications.addClickListener((event) {
    final payload = event.notification.additionalData;
    if (payload != null && payload.containsKey('screen')) {
      // Example: print or handle navigation based on payload['screen']
      print('Navigate to screen: ${payload['screen']}');
      // You can use a navigator key or other mechanism to navigate here
    }
  });
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