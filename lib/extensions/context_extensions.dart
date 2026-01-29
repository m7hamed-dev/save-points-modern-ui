import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_bottomsheet.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_dialog.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_snackbar.dart';

/// Extension methods on [BuildContext] for easier access to SavePoints components
extension SavePointsContextExtension on BuildContext {
  /// Shows a success snackbar
  ///
  /// Example:
  /// ```dart
  /// context.showSuccessSnackbar(
  ///   title: 'Success!',
  ///   subtitle: 'Operation completed',
  /// );
  /// ```
  void showSuccessSnackbar({
    required String title,
    String? subtitle,
    Duration? duration,
    bool showProgressIndicator = false,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    SavePointsSnackbar.showSuccess(
      this,
      title: title,
      subtitle: subtitle,
      duration: duration,
      showProgressIndicator: showProgressIndicator,
      blur: blur,
      backdropFilter: backdropFilter,
    );
  }

  /// Shows an error snackbar
  ///
  /// Example:
  /// ```dart
  /// context.showErrorSnackbar(
  ///   title: 'Error',
  ///   subtitle: 'Something went wrong',
  /// );
  /// ```
  void showErrorSnackbar({
    required String title,
    String? subtitle,
    Duration? duration,
    bool showProgressIndicator = false,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    SavePointsSnackbar.showError(
      this,
      title: title,
      subtitle: subtitle,
      duration: duration,
      showProgressIndicator: showProgressIndicator,
      blur: blur,
      backdropFilter: backdropFilter,
    );
  }

  /// Shows a warning snackbar
  ///
  /// Example:
  /// ```dart
  /// context.showWarningSnackbar(
  ///   title: 'Warning',
  ///   subtitle: 'Please check your input',
  /// );
  /// ```
  void showWarningSnackbar({
    required String title,
    String? subtitle,
    Duration? duration,
    bool showProgressIndicator = false,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    SavePointsSnackbar.showWarning(
      this,
      title: title,
      subtitle: subtitle,
      duration: duration,
      showProgressIndicator: showProgressIndicator,
      blur: blur,
      backdropFilter: backdropFilter,
    );
  }

  /// Shows an info snackbar
  ///
  /// Example:
  /// ```dart
  /// context.showInfoSnackbar(
  ///   title: 'Info',
  ///   subtitle: 'New update available',
  /// );
  /// ```
  void showInfoSnackbar({
    required String title,
    String? subtitle,
    Duration? duration,
    bool showProgressIndicator = false,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    SavePointsSnackbar.show(
      this,
      title: title,
      subtitle: subtitle,
      type: SnackbarType.info,
      duration: duration,
      showProgressIndicator: showProgressIndicator,
      blur: blur,
      backdropFilter: backdropFilter,
    );
  }

  /// Shows a confirmation dialog
  ///
  /// Example:
  /// ```dart
  /// final confirmed = await context.showConfirmDialog(
  ///   title: 'Confirm',
  ///   message: 'Are you sure?',
  /// );
  /// if (confirmed == true) {
  ///   // User confirmed
  /// }
  /// ```
  Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData? icon,
    Color? iconColor,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    return SavePointsDialog.show(
      this,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      showCancelButton: true,
      icon: icon,
      iconColor: iconColor,
      blur: blur,
      backdropFilter: backdropFilter,
    );
  }

  /// Shows an info dialog
  ///
  /// Example:
  /// ```dart
  /// await context.showInfoDialog(
  ///   title: 'Information',
  ///   message: 'This is an informational message',
  /// );
  /// ```
  Future<bool?> showInfoDialog({
    required String title,
    required String message,
    String confirmText = 'OK',
    IconData icon = Icons.info,
    Color iconColor = Colors.blue,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    return SavePointsDialog.show(
      this,
      title: title,
      message: message,
      confirmText: confirmText,
      icon: icon,
      iconColor: iconColor,
      blur: blur,
      backdropFilter: backdropFilter,
    );
  }

  /// Shows a success dialog
  ///
  /// Example:
  /// ```dart
  /// await context.showSuccessDialog(
  ///   title: 'Success!',
  ///   message: 'Operation completed successfully',
  /// );
  /// ```
  Future<bool?> showSuccessDialog({
    required String title,
    required String message,
    String confirmText = 'OK',
    IconData icon = Icons.check_circle,
    Color iconColor = Colors.green,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    return SavePointsDialog.show(
      this,
      title: title,
      message: message,
      confirmText: confirmText,
      icon: icon,
      iconColor: iconColor,
      blur: blur,
      backdropFilter: backdropFilter,
    );
  }

  /// Shows an error dialog
  ///
  /// Example:
  /// ```dart
  /// await context.showErrorDialog(
  ///   title: 'Error',
  ///   message: 'Something went wrong',
  /// );
  /// ```
  Future<bool?> showErrorDialog({
    required String title,
    required String message,
    String confirmText = 'OK',
    IconData icon = Icons.error,
    Color iconColor = Colors.red,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    return SavePointsDialog.show(
      this,
      title: title,
      message: message,
      confirmText: confirmText,
      icon: icon,
      iconColor: iconColor,
      blur: blur,
      backdropFilter: backdropFilter,
    );
  }

  /// Shows a bottom sheet
  ///
  /// Example:
  /// ```dart
  /// await context.showBottomSheet(
  ///   title: 'Options',
  ///   child: YourContentWidget(),
  /// );
  /// ```
  Future<T?> showBottomSheet<T>({
    String? title,
    Widget? child,
    IconData? icon,
    bool isDismissible = true,
    bool enableDrag = true,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    return SavePointsBottomsheet.show<T>(
      context: this,
      title: title,
      child: child,
      icon: icon,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      blur: blur,
      backdropFilter: backdropFilter,
    );
  }

  /// Dismisses all currently visible snackbars
  void dismissAllSnackbars() {
    ScaffoldMessenger.of(this).clearSnackBars();
  }
}
