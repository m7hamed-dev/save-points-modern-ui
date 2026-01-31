/// SavePoints Dialog Library
///
/// Provides modern, customizable dialog widgets with glassmorphism design.
library;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
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
    ContentDesignStyle? designStyle,
    double? blur,
    ImageFilter? backdropFilter,
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
        return _DialogTransitionScope(
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
        );
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

/// Caches dialog content so it is built once per show, reducing rebuilds during animation.
class _DialogTransitionScope extends StatefulWidget {
  const _DialogTransitionScope({
    required this.animation,
    this.animationType,
    this.startAnimation,
    this.endAnimation,
    this.hideLikeCircle = false,
    required this.useBarrierBlur,
    this.barrierFilter,
    required this.barrierDismissible,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.confirmButtonColor,
    this.cancelButtonColor,
    required this.showCancelButton,
    this.onConfirm,
    this.onConfirmAsync,
    this.onCancel,
    required this.isDark,
    required this.isLoading,
    this.loadingNotifier,
    this.designStyle,
    this.blur,
    this.backdropFilter,
  });

  final Animation<double> animation;
  final DialogAnimationType? animationType;
  final DialogAnimationDirection? startAnimation;
  final DialogAnimationDirection? endAnimation;
  final bool hideLikeCircle;
  final bool useBarrierBlur;
  final ImageFilter? barrierFilter;
  final bool barrierDismissible;
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;
  final bool showCancelButton;
  final VoidCallback? onConfirm;
  final Future<bool> Function()? onConfirmAsync;
  final VoidCallback? onCancel;
  final bool isDark;
  final bool isLoading;
  final ValueNotifier<bool>? loadingNotifier;
  final ContentDesignStyle? designStyle;
  final double? blur;
  final ImageFilter? backdropFilter;

  @override
  State<_DialogTransitionScope> createState() => _DialogTransitionScopeState();
}

class _DialogTransitionScopeState extends State<_DialogTransitionScope> {
  Widget? _cachedDialog;

  static const _barrierDimColor = Color(0x40000000);

  @override
  Widget build(BuildContext context) {
    _cachedDialog ??= DialogTransitionBuilder(
      animation: widget.animation,
      animationType: widget.animationType,
      startAnimation: widget.startAnimation,
      endAnimation: widget.endAnimation,
      hideLikeCircle: widget.hideLikeCircle,
      dialog: ModernDialog(
        title: widget.title,
        message: widget.message,
        confirmText: widget.confirmText,
        cancelText: widget.cancelText,
        icon: widget.icon,
        iconColor: widget.iconColor,
        backgroundColor: widget.backgroundColor,
        confirmButtonColor: widget.confirmButtonColor,
        cancelButtonColor: widget.cancelButtonColor,
        showCancelButton: widget.showCancelButton,
        onConfirm: widget.onConfirm,
        onConfirmAsync: widget.onConfirmAsync,
        onCancel: widget.onCancel,
        isDark: widget.isDark,
        isLoading: widget.isLoading,
        loadingNotifier: widget.loadingNotifier,
        designStyle: widget.designStyle,
        blur: widget.blur,
        backdropFilter: widget.backdropFilter,
      ),
    );

    if (widget.useBarrierBlur && widget.barrierFilter != null) {
      final filter = widget.barrierFilter!;
      return Stack(
        fit: StackFit.expand,
        children: [
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: widget.animation,
              builder: (context, child) {
                return Opacity(opacity: widget.animation.value, child: child);
              },
              child: GestureDetector(
                onTap: widget.barrierDismissible
                    ? () => Navigator.of(context).pop()
                    : null,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: filter,
                    child: Container(color: _barrierDimColor),
                  ),
                ),
              ),
            ),
          ),
          Center(child: _cachedDialog),
        ],
      );
    }

    return Center(child: _cachedDialog);
  }
}
