import 'package:flutter/material.dart';
import 'package:save_points_modern_ui/savepoints_config.dart';
import 'package:save_points_modern_ui/snackbar/snackbar_enums.dart';

/// Snackbar color configuration
class SnackbarColorConfig {
  final Color backgroundColor;
  final Color iconColor;
  final IconData defaultIcon;
  final Gradient? gradient;

  SnackbarColorConfig({
    required ThemeData theme,
    required bool isDark,
    Color? background,
    Gradient? gradient,
    Color? iconColor,
    required SnackbarType type,
    required SnackbarConfig config,
  }) : gradient = gradient,
       backgroundColor =
           background ??
           (gradient == null
               ? config.getBackgroundColor(
                       type,
                       isDark ? Brightness.dark : Brightness.light,
                     ) ??
                     _getBackgroundColor(type, isDark)
               : Colors.transparent),
       iconColor =
           iconColor ?? config.getIconColor(type) ?? _getIconColor(type),
       defaultIcon = config.getDefaultIcon(type) ?? _getDefaultIcon(type);

  static Color _getBackgroundColor(SnackbarType type, bool isDark) {
    switch (type) {
      case SnackbarType.success:
        return isDark ? const Color(0xFF1B5E20) : const Color(0xFF2E7D32);
      case SnackbarType.error:
        return isDark ? const Color(0xFFB71C1C) : const Color(0xFFD32F2F);
      case SnackbarType.warning:
        return isDark ? const Color(0xFFE65100) : const Color(0xFFF57C00);
      case SnackbarType.info:
        return isDark ? const Color(0xFF2C2C2C) : const Color(0xFF222222);
    }
  }

  static Color _getIconColor(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return Colors.greenAccent;
      case SnackbarType.error:
        return Colors.redAccent;
      case SnackbarType.warning:
        return Colors.orangeAccent;
      case SnackbarType.info:
        return Colors.white;
    }
  }

  static IconData _getDefaultIcon(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return Icons.check_circle;
      case SnackbarType.error:
        return Icons.error;
      case SnackbarType.warning:
        return Icons.warning;
      case SnackbarType.info:
        return Icons.info;
    }
  }
}
