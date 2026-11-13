import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/animated_barrier.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/pulse_scope.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_animation_direction.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_animation_type.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_transition_builder.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_transition_scope.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/header_dialog.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_config.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_theme.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/utils/keyboard_utils.dart';

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
  /// Barrier blur sigma used when no `blur` is given by the call, the
  /// enclosing [SavePointsTheme], or the config.
  ///
  /// Dialogs blur their barrier by default; `blur: 0` opts out.
  static const double defaultBarrierBlurSigma = 20.0;

  /// Shows a modern dialog with optional icon and buttons.
  ///
  /// Returns `true` if the dialog was confirmed, `false` if cancelled,
  /// or `null` if dismissed without action.
  ///
  /// Throws an [AssertionError] in debug builds if [title] is empty.
  /// [message] may be empty — pass a [child] instead to supply the body.
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

    /// Backdrop blur sigma for the barrier behind the dialog.
    ///
    /// Falls back to the enclosing [SavePointsTheme], then to
    /// [SavePointsDialog.defaultBarrierBlurSigma]. The barrier is blurred by
    /// default — pass `blur: 0` to turn it off and get a plain dim barrier.
    ///
    /// Note this differs from [SavePointsSnackbar.show]'s `blur`, which has
    /// no barrier to blur and so applies no blur when left unset.
    double? blur,

    /// Loops a subtle scale + glow pulse on the icon.
    ///
    /// Off by default: the pulse never ends, so it costs a repaint every frame
    /// for as long as the dialog is up and makes `pumpAndSettle()` hang in
    /// tests. Set it here for one call, or via [SavePointsTheme] for a
    /// subtree.
    bool? enablePulse,
    ImageFilter? backdropFilter,
    Widget? child,
  }) {
    // Validate required parameters
    assert(title.isNotEmpty, 'Title cannot be empty');
    // Message can be empty if a custom child is provided

    // Dismiss keyboard when showing dialog to prevent UI overlap
    KeyboardUtils.dismissIfFocused(context);

    final config = SnackDiaBottomConfig().dialog;
    final spTheme = SavePointsTheme.maybeOf(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final finalConfirmText = confirmText ?? config.defaultConfirmText;
    final finalCancelText = cancelText ?? config.defaultCancelText;
    final finalShowCancelButton =
        showCancelButton ?? config.defaultShowCancelButton;
    final finalBarrierDismissible = barrierDismissible ??
        spTheme?.barrierDismissible ??
        config.defaultBarrierDismissible;
    final finalBlur = blur ?? spTheme?.blur;
    final finalBackgroundColor =
        backgroundColor ?? config.defaultBackgroundColor;
    final finalConfirmButtonColor =
        confirmButtonColor ?? config.defaultConfirmButtonColor;
    final finalCancelButtonColor =
        cancelButtonColor ?? config.defaultCancelButtonColor;

    final barrierSigma = finalBlur ?? defaultBarrierBlurSigma;
    final ImageFilter? barrierFilter = backdropFilter ??
        (barrierSigma <= 0
            ? null
            : ImageFilter.blur(sigmaX: barrierSigma, sigmaY: barrierSigma));
    final useBarrierBlur = barrierFilter != null;
    final finalDesignStyle =
        designStyle ?? spTheme?.designStyle ?? config.defaultDesignStyle;

    // Capture child parameter before it's shadowed by transitionBuilder
    final customChild = child;

    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: finalBarrierDismissible,
      barrierLabel: config.barrierLabel,
      barrierColor: useBarrierBlur ? Colors.transparent : config.barrierColor,
      transitionDuration: config.transitionDuration,
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return pulseScope(
          spTheme,
          enablePulse,
          DialogTransitionScope(
            animation: animation,
            animationType: (startAnimation == null && endAnimation == null)
                ? (animationType ?? config.defaultAnimation)
                : null,
            startAnimation: startAnimation,
            endAnimation: endAnimation,
            hideLikeCircle: hideLikeCircle,
            useBarrierBlur: useBarrierBlur,
            barrierFilter: barrierFilter,
            // A caller-supplied filter cannot be interpolated, so only our
            // own blur gets ramped; theirs is held constant.
            barrierSigma: backdropFilter == null ? barrierSigma : null,
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
            blur: finalBlur,
            backdropFilter: backdropFilter,
            child: customChild,
          ),
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
    KeyboardUtils.dismissIfFocused(context);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final barrierSigma = blur ?? defaultBarrierBlurSigma;
    final ImageFilter? barrierFilter = backdropFilter ??
        (barrierSigma <= 0
            ? null
            : ImageFilter.blur(sigmaX: barrierSigma, sigmaY: barrierSigma));
    final useBarrierBlur = barrierFilter != null;

    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Close dialog',
      barrierColor: useBarrierBlur ? Colors.transparent : Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
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
              AnimatedBarrier(
                animation: animation,
                dimColor: const Color(0x40000000),
                sigma: backdropFilter == null ? barrierSigma : null,
                filter: backdropFilter == null ? null : barrierFilter,
                onTap: barrierDismissible
                    ? () => Navigator.of(context).pop()
                    : null,
              ),
              Center(child: transitionedDialog),
            ],
          );
        }

        return Center(child: transitionedDialog);
      },
    );
  }
}
