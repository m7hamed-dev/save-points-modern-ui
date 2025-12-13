import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_config.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/modern_dialog.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_transition_builder.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_animation_type.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_animation_direction.dart';

// Export animation types for public use
export 'dialog/dialog_animation_type.dart';
export 'dialog/dialog_animation_direction.dart';

/// A modern, customizable dialog with glassmorphism design.
///
/// This class provides a static method to display beautiful dialogs with:
/// - Glassmorphism effects with backdrop blur
/// - Multiple animation types
/// - Customizable colors, icons, and buttons
/// - Loading states for async operations
/// - Dark mode support
///
/// Example:
/// ```dart
/// SavePointsDialog.show(
///   context,
///   title: 'Success',
///   message: 'Your changes have been saved!',
///   icon: Icons.check_circle,
///   iconColor: Colors.green,
///   onConfirm: () => print('Confirmed'),
/// );
/// ```
class SavePointsDialog {
  /// Shows a modern dialog with optional icon and buttons.
  ///
  /// Returns `true` if the dialog was confirmed, `false` if cancelled,
  /// or `null` if dismissed without action.
  ///
  /// Throws an [AssertionError] if [title] or [message] is empty.
  ///
  /// Example:
  /// ```dart
  /// final result = await SavePointsDialog.show(
  ///   context,
  ///   title: 'Confirm',
  ///   message: 'Are you sure?',
  ///   showCancelButton: true,
  /// );
  /// if (result == true) {
  ///   // User confirmed
  /// }
  /// ```
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    IconData? icon,
    Color? iconColor,
    Color? backgroundColor,
    Color? confirmButtonColor,
    Color? cancelButtonColor,
    bool? showCancelButton,
    VoidCallback? onConfirm,
    Future<bool> Function()? onConfirmAsync,
    VoidCallback? onCancel,
    bool? barrierDismissible,
    DialogAnimationType? animationType, // For backward compatibility
    DialogAnimationDirection? startAnimation,
    DialogAnimationDirection? endAnimation,
    bool isLoading = false,
    ValueNotifier<bool>? loadingNotifier,
    bool hideLikeCircle = false,
  }) {
    // Validate required parameters
    assert(title.isNotEmpty, 'Title cannot be empty');
    assert(message.isNotEmpty, 'Message cannot be empty');

    final config = SavePointsConfig().dialog;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final finalConfirmText = confirmText ?? config.defaultConfirmText;
    final finalCancelText = cancelText ?? config.defaultCancelText;
    final finalShowCancelButton =
        showCancelButton ?? config.defaultShowCancelButton;
    final finalBarrierDismissible =
        barrierDismissible ?? config.defaultBarrierDismissible;
    final finalBackgroundColor =
        backgroundColor ?? config.defaultBackgroundColor;
    final finalConfirmButtonColor =
        confirmButtonColor ?? config.defaultConfirmButtonColor;
    final finalCancelButtonColor =
        cancelButtonColor ?? config.defaultCancelButtonColor;

    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: finalBarrierDismissible,
      barrierLabel: config.barrierLabel,
      barrierColor: config.barrierColor,
      transitionDuration: config.transitionDuration,
      pageBuilder: (_, _, _) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final finalAnimationType =
            (startAnimation == null && endAnimation == null)
            ? (animationType ?? config.defaultAnimation)
            : null;
        return DialogTransitionBuilder(
          animation: animation,
          animationType: finalAnimationType,
          startAnimation: startAnimation,
          endAnimation: endAnimation,
          hideLikeCircle: hideLikeCircle,
          dialog: ModernDialog(
            title: title,
            message: message,
            confirmText: finalConfirmText,
            cancelText: finalCancelText,
            icon: icon,
            iconColor: iconColor,
            backgroundColor: finalBackgroundColor,
            confirmButtonColor: finalConfirmButtonColor,
            cancelButtonColor: finalCancelButtonColor,
            showCancelButton: finalShowCancelButton,
            onConfirm: onConfirm,
            onConfirmAsync: onConfirmAsync,
            onCancel: onCancel,
            isDark: isDark,
            isLoading: isLoading,
            loadingNotifier: loadingNotifier,
          ),
        );
      },
    );
  }
}
