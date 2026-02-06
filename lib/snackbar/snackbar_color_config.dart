import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_config.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_enums.dart';

/// Snackbar color configuration
class SnackbarColorConfig {
  final Color backgroundColor;
  final Color iconColor;
  final IconData defaultIcon;
  final Gradient? gradient;
  final Color titleColor;
  final Color subtitleColor;
  final Color borderColor;
  final ContentDesignStyle designStyle;

  SnackbarColorConfig({
    required ThemeData theme,
    required bool isDark,
    Color? background,
    this.gradient,
    Color? iconColor,
    required SnackbarType type,
    required SnackbarConfig config,
    ContentDesignStyle? designStyle,
  }) : designStyle = designStyle ?? config.defaultDesignStyle,
       backgroundColor =
           background ??
           (gradient == null
               ? ((designStyle ?? config.defaultDesignStyle) ==
                         ContentDesignStyle.outlined
                     ? (isDark ? Colors.grey[900]! : Colors.white)
                     : (config.getBackgroundColor(
                             type,
                             isDark ? Brightness.dark : Brightness.light,
                           ) ??
                           _getBackgroundColor(type, isDark)))
               : Colors.transparent),
       iconColor =
           iconColor ?? config.getIconColor(type) ?? _getIconColor(type),
       defaultIcon = config.getDefaultIcon(type) ?? _getDefaultIcon(type),
       titleColor =
           (designStyle ?? config.defaultDesignStyle) ==
               ContentDesignStyle.outlined
           ? (isDark ? Colors.white : const Color(0xFF424242))
           : Colors.white,
       subtitleColor =
           (designStyle ?? config.defaultDesignStyle) ==
               ContentDesignStyle.outlined
           ? (isDark ? Colors.grey[400]! : const Color(0xFF616161))
           : Colors.white.withValues(alpha: 0.8),
       borderColor =
           iconColor ?? config.getIconColor(type) ?? _getIconColor(type);

  static Color _getBackgroundColor(SnackbarType type, bool isDark) {
    switch (type) {
      case .success:
        return isDark ? const Color(0xFF1B5E20) : const Color(0xFF2E7D32);
      case .error:
        return isDark ? const Color(0xFFB71C1C) : const Color(0xFFD32F2F);
      case .warning:
        return isDark ? const Color(0xFFE65100) : const Color(0xFFF57C00);
      case .info:
        return isDark ? const Color(0xFF2C2C2C) : const Color(0xFF222222);
    }
  }

  static Color _getIconColor(SnackbarType type) {
    switch (type) {
      case .success:
        return Colors.greenAccent;
      case .error:
        return Colors.redAccent;
      case .warning:
        return Colors.orangeAccent;
      case .info:
        return Colors.white;
    }
  }

  static IconData _getDefaultIcon(SnackbarType type) {
    switch (type) {
      case .success:
        return Icons.check_circle;
      case .error:
        return Icons.error;
      case .warning:
        return Icons.warning;
      case .info:
        return Icons.info;
    }
  }
}
