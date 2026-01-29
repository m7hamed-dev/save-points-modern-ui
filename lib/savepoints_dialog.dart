/// SavePoints Dialog Library
///
/// Provides modern, customizable dialog widgets with glassmorphism design.
library;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_animation_direction.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_animation_type.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_transition_builder.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/modern_dialog.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_config.dart';

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
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    // Validate required parameters
    assert(title.isNotEmpty, 'Title cannot be empty');
    assert(message.isNotEmpty, 'Message cannot be empty');

    // Dismiss keyboard when showing dialog to prevent UI overlap
    _dismissKeyboard(context);

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

    final ImageFilter? barrierFilter =
        backdropFilter ??
        (blur != null && blur <= 0
            ? null
            : ImageFilter.blur(sigmaX: blur ?? 20.0, sigmaY: blur ?? 20.0));
    final useBarrierBlur = barrierFilter != null;

    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: finalBarrierDismissible,
      barrierLabel: config.barrierLabel,
      barrierColor: useBarrierBlur ? Colors.transparent : config.barrierColor,
      transitionDuration: config.transitionDuration,
      pageBuilder: (_, _, _) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final finalAnimationType =
            (startAnimation == null && endAnimation == null)
            ? (animationType ?? config.defaultAnimation)
            : null;
        final dialogWidget = DialogTransitionBuilder(
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
            blur: blur,
            backdropFilter: backdropFilter,
          ),
        );

        if (useBarrierBlur) {
          return Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                onTap: finalBarrierDismissible
                    ? () => Navigator.of(context).pop()
                    : null,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: barrierFilter,
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.25),
                    ),
                  ),
                ),
              ),
              Center(child: dialogWidget),
            ],
          );
        }

        return Center(child: dialogWidget);
      },
    );
  }

  /// Dismisses the keyboard if currently focused
  static void _dismissKeyboard(BuildContext context) {
    final focusNode = FocusScope.of(context);
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
  }
}
