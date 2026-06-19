import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_enums.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_constants.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/config/snackbar_type_config.dart';

/// Configuration for snackbar appearance and behavior
class SnackbarConfig {
  /// Default design style: solid (filled) or outlined (light bg + border).
  ContentDesignStyle defaultDesignStyle = ContentDesignStyle.solid;

  /// Default duration
  Duration defaultDuration = const Duration(seconds: 3);

  /// Default animation style
  SnackbarAnimation defaultAnimation = SnackbarAnimation.fadeSlide;

  /// Default position (snackbar shows at top by default)
  SnackbarPosition defaultPosition = SnackbarConstants.defaultPosition;

  /// Default type
  SnackbarType defaultType = SnackbarType.info;

  /// Show progress indicator by default
  bool defaultShowProgressIndicator = false;

  /// Enable haptic feedback by default
  bool defaultEnableHapticFeedback = true;

  /// Dismissible by default
  bool defaultDismissible = true;

  /// Dismiss on tap by default
  bool defaultDismissOnTap = false;

  /// Maximum width constraint
  double? maxWidth;

  /// Default margin (null = auto-calculate)
  EdgeInsets? defaultMargin;

  /// Default border radius
  BorderRadius? defaultBorderRadius;

  /// Default border width
  double defaultBorderWidth = 0;

  /// Default border color (null = auto-calculate based on type)
  Color? defaultBorderColor;

  /// Type-specific configurations
  /// Uses modern Material 3 rounded icons for a softer, contemporary look
  /// Vivid intent palette (matches the shared [SpPalette] tokens). Backgrounds
  /// are only used as a flat fallback — the bold default renders a gradient.
  Map<SnackbarType, SnackbarTypeConfig> typeConfigs = {
    SnackbarType.success: const SnackbarTypeConfig(
      backgroundColor: {
        Brightness.dark: Color(0xFF10B981),
        Brightness.light: Color(0xFF10B981),
      },
      iconColor: Color(0xFF10B981),
      defaultIcon: Icons.check_circle_rounded,
    ),
    SnackbarType.error: const SnackbarTypeConfig(
      backgroundColor: {
        Brightness.dark: Color(0xFFEF4444),
        Brightness.light: Color(0xFFEF4444),
      },
      iconColor: Color(0xFFEF4444),
      defaultIcon: Icons.error_rounded,
    ),
    SnackbarType.warning: const SnackbarTypeConfig(
      backgroundColor: {
        Brightness.dark: Color(0xFFF59E0B),
        Brightness.light: Color(0xFFF59E0B),
      },
      iconColor: Color(0xFFF59E0B),
      defaultIcon: Icons.warning_amber_rounded,
    ),
    SnackbarType.info: const SnackbarTypeConfig(
      backgroundColor: {
        Brightness.dark: Color(0xFF6366F1),
        Brightness.light: Color(0xFF6366F1),
      },
      iconColor: Color(0xFF6366F1),
      defaultIcon: Icons.info_rounded,
    ),
  };

  /// Apply theme settings
  void applyTheme(Brightness brightness) {
    // Can be extended for theme-specific overrides
  }

  /// Get background color for a type
  Color? getBackgroundColor(SnackbarType type, Brightness brightness) {
    return typeConfigs[type]?.backgroundColor[brightness];
  }

  /// Get icon color for a type
  Color? getIconColor(SnackbarType type) {
    return typeConfigs[type]?.iconColor;
  }

  /// Get default icon for a type
  IconData? getDefaultIcon(SnackbarType type) {
    return typeConfigs[type]?.defaultIcon;
  }

  /// Customize a specific type
  void customizeType(SnackbarType type, SnackbarTypeConfig config) {
    typeConfigs[type] = config;
  }
}
