import 'package:flutter/material.dart';

/// Dialog color configuration
class DialogColorConfig {
  final Color iconColor;
  final Color backgroundColor;
  final Color confirmColor;
  final Color cancelColor;

  DialogColorConfig({
    required ThemeData theme,
    required bool isDark,
    Color? iconColor,
    Color? backgroundColor,
    Color? confirmButtonColor,
    Color? cancelButtonColor,
  }) : iconColor =
           iconColor ??
           (isDark ? Colors.blueAccent : theme.colorScheme.primary),
       backgroundColor =
           backgroundColor ??
           (isDark
               ? Colors.grey[900]!.withValues(alpha: 0.95)
               : Colors.white.withValues(alpha: 0.95)),
       confirmColor =
           confirmButtonColor ??
           (isDark ? Colors.blueAccent : theme.colorScheme.primary),
       cancelColor = cancelButtonColor ?? Colors.grey;
}
