import 'package:flutter/material.dart';

/// Dialog message widget
class DialogMessage extends StatelessWidget {
  final String message;
  final bool isDark;
  final Color? color;

  const DialogMessage({
    super.key,
    required this.message,
    required this.isDark,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        color ?? (isDark ? Colors.grey[400] : Colors.grey[700]);
    return Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: effectiveColor,
        height: 1.5,
        letterSpacing: 0.1,
      ),
    );
  }
}
