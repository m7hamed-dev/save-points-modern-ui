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
  final Color headerColor;
  final Color buttonColor;
  final Color buttonTextColor;

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
       backgroundColor = _computeBackgroundColor(
         background: background,
         gradient: gradient,
         designStyle: designStyle ?? config.defaultDesignStyle,
         isDark: isDark,
         type: type,
         config: config,
       ),
       iconColor =
           iconColor ?? config.getIconColor(type) ?? _getIconColor(type),
       defaultIcon = config.getDefaultIcon(type) ?? _getDefaultIcon(type),
       titleColor = _computeTitleColor(
         designStyle: designStyle ?? config.defaultDesignStyle,
         isDark: isDark,
       ),
       subtitleColor = _computeSubtitleColor(
         designStyle: designStyle ?? config.defaultDesignStyle,
         isDark: isDark,
       ),
       borderColor =
           iconColor ?? config.getIconColor(type) ?? _getIconColor(type),
       headerColor = _computeHeaderColor(
         type: type,
         iconColor: iconColor ?? config.getIconColor(type) ?? _getIconColor(type),
       ),
       buttonColor = isDark ? Colors.grey[800]! : const Color(0xFF2D2D2D),
       buttonTextColor = Colors.white;

  static Color _computeBackgroundColor({
    required Color? background,
    required Gradient? gradient,
    required ContentDesignStyle designStyle,
    required bool isDark,
    required SnackbarType type,
    required SnackbarConfig config,
  }) {
    if (background != null) return background;
    if (gradient != null) return Colors.transparent;

    switch (designStyle) {
      case ContentDesignStyle.outlined:
      case ContentDesignStyle.colorHeader:
        return isDark ? Colors.grey[900]! : Colors.white;
      case ContentDesignStyle.solid:
        return config.getBackgroundColor(
              type,
              isDark ? Brightness.dark : Brightness.light,
            ) ??
            _getBackgroundColor(type, isDark);
    }
  }

  static Color _computeTitleColor({
    required ContentDesignStyle designStyle,
    required bool isDark,
  }) {
    switch (designStyle) {
      case ContentDesignStyle.outlined:
      case ContentDesignStyle.colorHeader:
        return isDark ? Colors.white : const Color(0xFF424242);
      case ContentDesignStyle.solid:
        return Colors.white;
    }
  }

  static Color _computeSubtitleColor({
    required ContentDesignStyle designStyle,
    required bool isDark,
  }) {
    switch (designStyle) {
      case ContentDesignStyle.outlined:
      case ContentDesignStyle.colorHeader:
        return isDark ? Colors.grey[400]! : const Color(0xFF616161);
      case ContentDesignStyle.solid:
        return Colors.white.withValues(alpha: 0.8);
    }
  }

  static Color _computeHeaderColor({
    required SnackbarType type,
    required Color iconColor,
  }) {
    // Return a lighter/pastel version of the icon color for the header gradient
    switch (type) {
      case SnackbarType.success:
        return const Color(0xFFE8F5E9); // Light green
      case SnackbarType.error:
        return const Color(0xFFFFEBEE); // Light red/coral
      case SnackbarType.warning:
        return const Color(0xFFFFF3E0); // Light orange
      case SnackbarType.info:
        return const Color(0xFFE3F2FD); // Light blue
    }
  }

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
