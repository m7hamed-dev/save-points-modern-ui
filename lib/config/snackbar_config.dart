import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_enums.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/config/snackbar_type_config.dart';

/// Configuration for snackbar appearance and behavior
class SnackbarConfig {
  /// Default duration
  Duration defaultDuration = const Duration(seconds: 3);

  /// Default animation style
  SnackbarAnimation defaultAnimation = SnackbarAnimation.fadeSlide;

  /// Default position
  SnackbarPosition defaultPosition = SnackbarPosition.top;

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
  Map<SnackbarType, SnackbarTypeConfig> typeConfigs = {
    SnackbarType.success: SnackbarTypeConfig(
      backgroundColor: {
        Brightness.dark: const Color(0xFF1B5E20),
        Brightness.light: const Color(0xFF2E7D32),
      },
      iconColor: Colors.greenAccent,
      defaultIcon: Icons.check_circle,
    ),
    SnackbarType.error: SnackbarTypeConfig(
      backgroundColor: {
        Brightness.dark: const Color(0xFFB71C1C),
        Brightness.light: const Color(0xFFD32F2F),
      },
      iconColor: Colors.redAccent,
      defaultIcon: Icons.error,
    ),
    SnackbarType.warning: SnackbarTypeConfig(
      backgroundColor: {
        Brightness.dark: const Color(0xFFE65100),
        Brightness.light: const Color(0xFFF57C00),
      },
      iconColor: Colors.orangeAccent,
      defaultIcon: Icons.warning,
    ),
    SnackbarType.info: SnackbarTypeConfig(
      backgroundColor: {
        Brightness.dark: const Color(0xFF2C2C2C),
        Brightness.light: const Color(0xFF222222),
      },
      iconColor: Colors.white,
      defaultIcon: Icons.info,
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
