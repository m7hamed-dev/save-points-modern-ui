import 'package:flutter/material.dart';

/// Dialog message widget
class DialogMessage extends StatelessWidget {
  final String message;
  final bool isDark;

  const DialogMessage({super.key, required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: isDark ? Colors.grey[400] : Colors.grey[700],
        height: 1.5,
        letterSpacing: 0.1,
      ),
    );
  }
}
