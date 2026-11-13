import 'dart:ui';

import 'package:material_ui/material_ui.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_bottomsheet.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_dialog.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_snackbar.dart';

/// Extension methods on [BuildContext] for easier access to SavePoints components
extension SavePointsContextExtension on BuildContext {
  /// Shows a success snackbar.
  ///
  /// Returns the snackbar's [ScaffoldFeatureController], so it can be closed
  /// early or awaited via `closed`. Ignore it if you don't need either.
  ///
  /// Example:
  /// ```dart
  /// context.showSuccessSnackbar(
  ///   title: 'Success!',
  ///   subtitle: 'Operation completed',
  /// );
  /// ```
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSuccessSnackbar({
    required String title,
    String? subtitle,
    Duration? duration,
    bool? showProgressIndicator,
    ContentDesignStyle? designStyle,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    return SavePointsSnackbar.showSuccess(
      this,
      title: title,
      subtitle: subtitle,
      duration: duration,
      showProgressIndicator: showProgressIndicator,
      designStyle: designStyle,
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
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showErrorSnackbar({
    required String title,
    String? subtitle,
    Duration? duration,
    bool? showProgressIndicator,
    ContentDesignStyle? designStyle,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    return SavePointsSnackbar.showError(
      this,
      title: title,
      subtitle: subtitle,
      duration: duration,
      showProgressIndicator: showProgressIndicator,
      designStyle: designStyle,
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
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showWarningSnackbar({
    required String title,
    String? subtitle,
    Duration? duration,
    bool? showProgressIndicator,
    ContentDesignStyle? designStyle,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    return SavePointsSnackbar.showWarning(
      this,
      title: title,
      subtitle: subtitle,
      duration: duration,
      showProgressIndicator: showProgressIndicator,
      designStyle: designStyle,
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
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showInfoSnackbar({
    required String title,
    String? subtitle,
    Duration? duration,
    bool? showProgressIndicator,
    ContentDesignStyle? designStyle,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    return SavePointsSnackbar.showInfo(
      this,
      title: title,
      subtitle: subtitle,
      duration: duration,
      showProgressIndicator: showProgressIndicator,
      designStyle: designStyle,
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
    ContentDesignStyle? designStyle,
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
      designStyle: designStyle,
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

    /// Defaults to the package's own info icon.
    IconData? icon,

    /// Defaults to the package's info accent, resolved for the ambient
    /// brightness. This was a hard-coded `Colors.blue`, which did not match
    /// the palette every other surface in the package draws from.
    Color? iconColor,
    ContentDesignStyle? designStyle,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    return SavePointsDialog.show(
      this,
      title: title,
      message: message,
      confirmText: confirmText,
      icon: icon ?? Icons.info_rounded,
      iconColor: iconColor ?? _intentAccent(SpIntent.info),
      designStyle: designStyle,
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

    /// Defaults to the package's own success icon.
    IconData? icon,

    /// Defaults to the package's success accent, resolved for the ambient
    /// brightness. This was a hard-coded `Colors.green`, which did not match
    /// the palette every other surface in the package draws from.
    Color? iconColor,
    ContentDesignStyle? designStyle,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    return SavePointsDialog.show(
      this,
      title: title,
      message: message,
      confirmText: confirmText,
      icon: icon ?? Icons.check_circle_rounded,
      iconColor: iconColor ?? _intentAccent(SpIntent.success),
      designStyle: designStyle,
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

    /// Defaults to the package's own error icon.
    IconData? icon,

    /// Defaults to the package's error accent, resolved for the ambient
    /// brightness. This was a hard-coded `Colors.red`, which did not match
    /// the palette every other surface in the package draws from.
    Color? iconColor,
    ContentDesignStyle? designStyle,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    return SavePointsDialog.show(
      this,
      title: title,
      message: message,
      confirmText: confirmText,
      icon: icon ?? Icons.error_rounded,
      iconColor: iconColor ?? _intentAccent(SpIntent.error),
      designStyle: designStyle,
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
    ContentDesignStyle? designStyle,
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
      designStyle: designStyle,
      blur: blur,
      backdropFilter: backdropFilter,
    );
  }

  /// Dismisses all currently visible snackbars
  void dismissAllSnackbars() {
    ScaffoldMessenger.of(this).clearSnackBars();
  }

  /// The package's own accent for [intent], resolved for the ambient
  /// brightness — the same colour its snackbars of that intent use.
  Color _intentAccent(SpIntent intent) =>
      SpPalette.of(intent, Theme.of(this).brightness == Brightness.dark).base;
}
