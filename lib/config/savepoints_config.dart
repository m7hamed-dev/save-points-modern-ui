import 'package:flutter/material.dart';
import 'package:save_points_modern_ui/config/snackbar_config.dart';
import 'package:save_points_modern_ui/config/dialog_config.dart';

/// Global configuration for SavePoints snackbars and dialogs
class SavePointsConfig {
  static final SavePointsConfig _instance = SavePointsConfig._internal();
  factory SavePointsConfig() => _instance;
  SavePointsConfig._internal();

  /// Snackbar configuration
  SnackbarConfig snackbar = SnackbarConfig();

  /// Dialog configuration
  DialogConfig dialog = DialogConfig();

  /// Apply theme-aware settings based on Brightness
  void applyTheme(Brightness brightness) {
    snackbar.applyTheme(brightness);
    dialog.applyTheme(brightness);
  }

  /// Reset all configurations to defaults
  void reset() {
    snackbar = SnackbarConfig();
    dialog = DialogConfig();
  }
}
