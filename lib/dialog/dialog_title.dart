import 'package:flutter/material.dart';

/// Dialog title widget
class DialogTitle extends StatelessWidget {
  final String title;
  final bool isDark;

  const DialogTitle({super.key, required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : Colors.grey[900],
        letterSpacing: -0.5,
        height: 1.2,
      ),
    );
  }
}
