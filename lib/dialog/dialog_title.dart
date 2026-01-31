import 'package:flutter/material.dart';

/// Dialog title widget
class DialogTitle extends StatelessWidget {
  final String title;
  final bool isDark;
  final Color? color;

  const DialogTitle({
    super.key,
    required this.title,
    required this.isDark,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? (isDark ? Colors.white : Colors.grey[900]);
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: effectiveColor,
        letterSpacing: -0.5,
        height: 1.2,
      ),
    );
  }
}
