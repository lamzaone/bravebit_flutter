import 'package:flutter/material.dart';

class GoldLoader extends StatelessWidget {
  final double size;
  final bool fullScreen;

  const GoldLoader({super.key, this.size = 48, this.fullScreen = false});

  @override
  Widget build(BuildContext context) {
    final loader = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: const Color(0xFFB28A2F),
        strokeWidth: 4,
      ),
    );
    return fullScreen ? Scaffold(body: Center(child: loader)) : loader;
  }
}