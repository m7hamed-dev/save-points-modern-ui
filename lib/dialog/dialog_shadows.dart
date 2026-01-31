import 'package:flutter/material.dart';

/// Dialog shadows configuration
class DialogShadows {
  static List<BoxShadow> getShadows(bool isDark, {bool isOutlined = false}) {
    if (isOutlined) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
    }
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.2),
        blurRadius: 30,
        offset: const Offset(0, 15),
        spreadRadius: -5,
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ];
  }
}
