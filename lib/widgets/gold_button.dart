import 'package:flutter/material.dart';
import 'package:bravebit_flutter/widgets/gold_loader.dart';

class GoldButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? variant; // 'secondary' for outline
  final String size; // 'login', 'xl', etc.

  const GoldButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.variant,
    this.size = 'default',
  });

  @override
  Widget build(BuildContext context) {
    final isSecondary = variant == 'secondary';
    final padding = size == 'login' ? const EdgeInsets.symmetric(horizontal: 48, vertical: 16) : const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: padding,
        decoration: BoxDecoration(
          color: isSecondary ? Colors.transparent : const Color(0xFFB28A2F),
          border: isSecondary ? Border.all(color: const Color(0xFFB28A2F)) : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!isSecondary) BoxShadow(color: const Color(0xFFB28A2F).withOpacity(0.3), blurRadius: 10, spreadRadius: 2),
          ],
        ),
        child: Center(
          child: isLoading
              ? const GoldLoader(size: 24)
              : Text(
                  text,
                  style: TextStyle(
                    color: isSecondary ? const Color(0xFFB28A2F) : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: size == 'xl' ? 18 : 16,
                  ),
                ),
        ),
      ),
    );
  }
}