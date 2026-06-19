import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/config/dialog_config.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/config/snackbar_config.dart';

/// Global configuration for SavePoints snackbars and dialogs
class SnackDiaBottomConfig {
  static final _instance = SnackDiaBottomConfig._internal();
  factory SnackDiaBottomConfig() => _instance;
  SnackDiaBottomConfig._internal();

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
