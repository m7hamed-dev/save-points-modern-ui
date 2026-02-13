import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_animation_direction.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_animation_type.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_transition_builder.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_transition_scope.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/header_dialog.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_config.dart';

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
    ContentDesignStyle? designStyle,
    double? blur,
    ImageFilter? backdropFilter,
    Widget? child,
  }) {
    // Validate required parameters
    assert(title.isNotEmpty, 'Title cannot be empty');
    assert(message.isNotEmpty, 'Message cannot be empty');

    // Dismiss keyboard when showing dialog to prevent UI overlap
    _dismissKeyboard(context);

    final config = SnackDiaBottomConfig().dialog;
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
    final finalDesignStyle = designStyle ?? config.defaultDesignStyle;

    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: finalBarrierDismissible,
      barrierLabel: config.barrierLabel,
      barrierColor: useBarrierBlur ? Colors.transparent : config.barrierColor,
      transitionDuration: config.transitionDuration,
      pageBuilder: (_, _, _) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return DialogTransitionScope(
          animation: animation,
          animationType: (startAnimation == null && endAnimation == null)
              ? (animationType ?? config.defaultAnimation)
              : null,
          startAnimation: startAnimation,
          endAnimation: endAnimation,
          hideLikeCircle: hideLikeCircle,
          useBarrierBlur: useBarrierBlur,
          barrierFilter: barrierFilter,
          barrierDismissible: finalBarrierDismissible,
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
          designStyle: finalDesignStyle,
          blur: blur,
          backdropFilter: backdropFilter,
          child: child,
        );
      },
    );
  }

  /// Shows a custom dialog with header bar and close button outside the box.
  ///
  /// This dialog style features:
  /// - Close button positioned outside (top-left) the dialog
  /// - A colored header with title
  /// - Custom content area (your widget)
  /// - Primary and optional secondary action buttons
  ///
  /// Example:
  /// ```dart
  /// SavePointsDialog.showCustom(
  ///   context,
  ///   headerTitle: 'Payment Details',
  ///   headerColor: Colors.deepPurple,
  ///   primaryButtonText: 'Confirm',
  ///   secondaryButtonText: 'Cancel',
  ///   child: YourCustomContent(),
  /// );
  /// ```
  static Future<T?> showCustom<T>({
    required BuildContext context,
    required String headerTitle,
    required Widget child,
    Color? headerColor,
    Color? headerTextColor,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    Color? primaryButtonColor,
    Color? secondaryButtonColor,
    bool showCloseButton = true,
    VoidCallback? onClose,
    bool barrierDismissible = true,
    DialogAnimationDirection? startAnimation,
    DialogAnimationDirection? endAnimation,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    // Dismiss keyboard when showing dialog
    _dismissKeyboard(context);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final ImageFilter? barrierFilter =
        backdropFilter ??
        (blur != null && blur <= 0
            ? null
            : ImageFilter.blur(sigmaX: blur ?? 20.0, sigmaY: blur ?? 20.0));
    final useBarrierBlur = barrierFilter != null;

    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Close dialog',
      barrierColor: useBarrierBlur ? Colors.transparent : Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, _, _) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, _) {
        final dialog = HeaderDialog(
          headerTitle: headerTitle,
          headerColor: headerColor,
          headerTextColor: headerTextColor,
          primaryButtonText: primaryButtonText,
          secondaryButtonText: secondaryButtonText,
          onPrimaryPressed: onPrimaryPressed,
          onSecondaryPressed: onSecondaryPressed,
          primaryButtonColor: primaryButtonColor,
          secondaryButtonColor: secondaryButtonColor,
          showCloseButton: showCloseButton,
          onClose: onClose,
          isDark: isDark,
          blur: blur,
          backdropFilter: backdropFilter,
          child: child,
        );

        final transitionedDialog = DialogTransitionBuilder(
          animation: animation,
          startAnimation: startAnimation,
          endAnimation: endAnimation,
          dialog: dialog,
        );

        if (useBarrierBlur) {
          return Stack(
            fit: StackFit.expand,
            children: [
              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Opacity(opacity: animation.value, child: child);
                  },
                  child: GestureDetector(
                    onTap: barrierDismissible
                        ? () => Navigator.of(context).pop()
                        : null,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: barrierFilter,
                        child: Container(color: const Color(0x40000000)),
                      ),
                    ),
                  ),
                ),
              ),
              Center(child: transitionedDialog),
            ],
          );
        }

        return Center(child: transitionedDialog);
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
