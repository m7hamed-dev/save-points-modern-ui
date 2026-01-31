import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_config.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_snackbar.dart';

/// Example usage of SavePointsConfig
///
/// This demonstrates how to configure and customize the default
/// behavior of snackbars and dialogs globally.
void configureSavePoints() {
  final config = SnackDiaBottomConfig();

  // Configure snackbar defaults
  config.snackbar.defaultDuration = const Duration(seconds: 4);
  config.snackbar.defaultAnimation = SnackbarAnimation.bounce;
  config.snackbar.defaultShowProgressIndicator = true;
  config.snackbar.defaultEnableHapticFeedback = false;
  config.snackbar.maxWidth = 400.0;
  config.snackbar.defaultBorderRadius = BorderRadius.circular(20.0);

  // Customize specific snackbar types
  config.snackbar.customizeType(
    SnackbarType.success,
    const SnackbarTypeConfig(
      backgroundColor: {
        Brightness.dark: Color(0xFF0D7377),
        Brightness.light: Color(0xFF14A085),
      },
      iconColor: Colors.tealAccent,
      defaultIcon: Icons.check_circle_outline,
    ),
  );

  // Configure dialog defaults
  config.dialog.defaultConfirmText = 'Confirm';
  config.dialog.defaultCancelText = 'Back';
  config.dialog.defaultBarrierDismissible = false;
  config.dialog.barrierColor = Colors.black.withValues(alpha: 0.7);
  config.dialog.transitionDuration = const Duration(milliseconds: 400);
  config.dialog.defaultConfirmButtonColor = Colors.blue;
}

/// Example: Using the configured defaults
void showConfiguredSnackbar(BuildContext context) {
  // This will use all the configured defaults
  SavePointsSnackbar.show(
    context,
    title: 'Success!',
    subtitle: 'This uses configured defaults',
  );

  // You can still override specific properties
  SavePointsSnackbar.show(
    context,
    title: 'Custom',
    subtitle: 'Overrides default duration',
    duration: const Duration(seconds: 5), // Overrides config
  );
}

/// Example: Applying theme-specific configurations
void applyThemeConfiguration(BuildContext context) {
  final config = SnackDiaBottomConfig();
  final brightness = Theme.of(context).brightness;

  // Apply theme-aware settings
  config.applyTheme(brightness);

  // Now all snackbars and dialogs will use theme-appropriate settings
}

/// Example: Resetting to defaults
void resetConfiguration() {
  final config = SnackDiaBottomConfig();
  config.reset(); // Restores all defaults
}
