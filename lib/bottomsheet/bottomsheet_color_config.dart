import 'package:flutter/material.dart';

/// Bottom sheet color configuration
class BottomsheetColorConfig {
  final Color backgroundColor;
  final Color handleColor;
  final Color textColor;
  final Color iconColor;

  BottomsheetColorConfig({
    required ThemeData theme,
    required bool isDark,
    Color? background,
    Color? handle,
    Color? text,
    Color? icon,
  }) : backgroundColor =
           background ??
           (isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF)),
       handleColor =
           handle ??
           (isDark
               ? Colors.white.withValues(alpha: 0.3)
               : Colors.black.withValues(alpha: 0.2)),
       textColor = text ?? (isDark ? Colors.white : Colors.black87),
       iconColor = icon ?? (isDark ? Colors.white70 : Colors.black54);
}
