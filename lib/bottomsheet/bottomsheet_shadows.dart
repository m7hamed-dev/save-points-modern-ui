import 'package:flutter/material.dart';

/// Bottom sheet shadows
class BottomsheetShadows {
  const BottomsheetShadows();
  static List<BoxShadow> getShadows(bool isDark, {bool isOutlined = false}) {
    if (isOutlined) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, -4),
        ),
      ];
    }
    if (isDark) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.5),
          blurRadius: 20,
          offset: const Offset(0, -4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ];
    } else {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, -4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ];
    }
  }
}
