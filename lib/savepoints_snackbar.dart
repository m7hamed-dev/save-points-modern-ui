/// SavePoints Snackbar Library
///
/// Provides modern, customizable snackbar widgets with enhanced UI/UX.
library;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_config.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/top_snackbar_overlay.dart';

// Export enums for public use
export 'snackbar/snackbar_enums.dart';
export 'snackbar/snackbar_animation_direction.dart';

/// Modern, customizable snackbar widget with enhanced UI/UX.
///
/// This class provides methods to display beautiful snackbars with:
/// - Multiple types (success, error, warning, info)
/// - Rich animations
/// - Progress indicators
/// - Gradient backgrounds
/// - Top or bottom positioning
/// - Dark mode support
///
/// Example:
/// ```dart
/// SavePointsSnackbar.showSuccess(
///   context,
///   title: 'Success!',
///   subtitle: 'Operation completed',
/// );
/// ```
class SavePointsSnackbar {
  /// Shows a modern floating snackbar with enhanced features.
  ///
  /// Returns a [ScaffoldFeatureController] that can be used to programmatically
  /// dismiss the snackbar.
  ///
  /// Throws an [AssertionError] if [title] is empty.
  ///
  /// Example:
  /// ```dart
  /// final controller = SavePointsSnackbar.show(
  ///   context,
  ///   title: 'Notification',
  ///   subtitle: 'This is a snackbar',
  ///   type: SnackbarType.info,
  /// );
  /// ```
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context, {
    required String title,
    String? subtitle,
    Color? background,
    Gradient? gradient,
    Duration? duration,
    IconData? icon,
    Color? iconColor,
    VoidCallback? onActionPressed,
    String? actionLabel,
    SnackbarType? type,
    SnackbarPosition? position,
    SnackbarAnimation? animation, // For backward compatibility
    SnackbarAnimationDirection? startAnimation,
    SnackbarAnimationDirection? endAnimation,
    bool? showProgressIndicator,
    bool hideLikeCircle = false,
    bool? dismissible,
    bool? enableHapticFeedback,
    bool? dismissOnTap,
    double? maxWidth,
    EdgeInsets? margin,
    BorderRadius? borderRadius,
    Color? borderColor,
    double? borderWidth,
    VoidCallback? onDismissed,
    VoidCallback? onTap,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    // Validate required parameters
    assert(title.isNotEmpty, 'Title cannot be empty');

    final config = SavePointsConfig().snackbar;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final finalType = type ?? config.defaultType;

    final colorConfig = SnackbarColorConfig(
      theme: theme,
      isDark: isDark,
      background: background,
      gradient: gradient,
      iconColor: iconColor,
      type: finalType,
      config: config,
    );

    final finalIcon = icon ?? colorConfig.defaultIcon;
    final finalIconColor = iconColor ?? colorConfig.iconColor;
    final finalPosition = position ?? config.defaultPosition;
    // Use new animation system if startAnimation or endAnimation is provided
    final finalAnimation = (startAnimation == null && endAnimation == null)
        ? (animation ?? config.defaultAnimation)
        : null;
    final finalDuration = duration ?? config.defaultDuration;
    final finalMargin =
        margin ?? config.defaultMargin ?? _getMargin(context, finalPosition);
    final finalBorderRadius =
        borderRadius ??
        config.defaultBorderRadius ??
        BorderRadius.circular(SnackbarConstants.borderRadius);
    final finalMaxWidth =
        maxWidth ?? config.maxWidth ?? SnackbarConstants.maxWidth;
    final finalShowProgressIndicator =
        showProgressIndicator ?? config.defaultShowProgressIndicator;
    final finalDismissible = dismissible ?? config.defaultDismissible;
    final finalEnableHapticFeedback =
        enableHapticFeedback ?? config.defaultEnableHapticFeedback;
    final finalDismissOnTap = dismissOnTap ?? config.defaultDismissOnTap;
    final finalBorderWidth = borderWidth ?? config.defaultBorderWidth;
    final finalBorderColor =
        borderColor ??
        config.defaultBorderColor ??
        finalIconColor.withValues(alpha: 0.3);

    if (finalEnableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    // Use overlay for top position (SnackBar doesn't support top positioning well)
    if (finalPosition == SnackbarPosition.top) {
      TopSnackbarOverlay.show(
        context,
        title: title,
        subtitle: subtitle,
        icon: finalIcon,
        iconColor: finalIconColor,
        backgroundColor: colorConfig.backgroundColor,
        gradient: colorConfig.gradient,
        duration: finalDuration,
        animation: finalAnimation,
        startAnimation: startAnimation,
        endAnimation: endAnimation,
        type: finalType,
        dismissible: finalDismissible,
        dismissOnTap: finalDismissOnTap,
        showProgressIndicator: finalShowProgressIndicator,
        borderRadius: finalBorderRadius,
        maxWidth: finalMaxWidth,
        borderColor: finalBorderWidth > 0 ? finalBorderColor : null,
        borderWidth: finalBorderWidth,
        onTap: onTap,
        onDismissed: onDismissed,
        blur: blur,
        backdropFilter: backdropFilter,
      );
      // Return a dummy controller for top position (overlay handles display)
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: SizedBox.shrink(),
          duration: Duration(milliseconds: 1),
          behavior: .fixed,
        ),
      );
    }

    // Remove any existing snackbar before showing a new one
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();

    // Use standard SnackBar for bottom position
    final controller = scaffoldMessenger.showSnackBar(
      SnackBar(
        behavior: .floating,
        duration: finalDuration,
        margin: finalMargin,
        shape: RoundedRectangleBorder(
          borderRadius: finalBorderRadius,
          side: finalBorderWidth > 0
              ? BorderSide(color: finalBorderColor, width: finalBorderWidth)
              : BorderSide.none,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        dismissDirection: finalDismissible
            ? DismissDirection.horizontal
            : DismissDirection.none,
        content: ModernSnackbarContent(
          title: title,
          subtitle: subtitle,
          icon: finalIcon,
          iconColor: finalIconColor,
          backgroundColor: colorConfig.backgroundColor,
          gradient: colorConfig.gradient,
          showProgressIndicator: finalShowProgressIndicator,
          duration: finalDuration,
          type: finalType,
          position: finalPosition,
          animation: finalAnimation ?? SnackbarAnimation.fadeSlide,
          borderRadius: finalBorderRadius,
          maxWidth: finalMaxWidth,
          dismissOnTap: finalDismissOnTap,
          onTap: onTap,
          blur: blur,
          backdropFilter: backdropFilter,
        ),
        action: onActionPressed != null && actionLabel != null
            ? SnackBarAction(
                label: actionLabel.toUpperCase(),
                textColor: Colors.white,
                onPressed: () {
                  if (finalEnableHapticFeedback) {
                    HapticFeedback.mediumImpact();
                  }
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  onActionPressed();
                },
              )
            : null,
      ),
    );

    controller.closed.then((reason) {
      onDismissed?.call();
    });

    return controller;
  }

  /// Quick method to show success snackbar
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSuccess(
    BuildContext context, {
    required String title,
    String? subtitle,
    Duration? duration,
    VoidCallback? onActionPressed,
    String? actionLabel,
    SnackbarPosition? position,
    bool showProgressIndicator = false,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    return show(
      context,
      title: title,
      subtitle: subtitle,
      type: SnackbarType.success,
      duration: duration,
      onActionPressed: onActionPressed,
      actionLabel: actionLabel,
      position: position,
      showProgressIndicator: showProgressIndicator,
      blur: blur,
      backdropFilter: backdropFilter,
    );
  }

  /// Quick method to show error snackbar
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showError(
    BuildContext context, {
    required String title,
    String? subtitle,
    Duration? duration,
    VoidCallback? onActionPressed,
    String? actionLabel,
    SnackbarPosition? position,
    bool showProgressIndicator = false,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    return show(
      context,
      title: title,
      subtitle: subtitle,
      type: SnackbarType.error,
      duration: duration,
      onActionPressed: onActionPressed,
      actionLabel: actionLabel,
      position: position,
      showProgressIndicator: showProgressIndicator,
      blur: blur,
      backdropFilter: backdropFilter,
    );
  }

  /// Quick method to show warning snackbar
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showWarning(
    BuildContext context, {
    required String title,
    String? subtitle,
    Duration? duration,
    VoidCallback? onActionPressed,
    String? actionLabel,
    SnackbarPosition? position,
    bool showProgressIndicator = false,
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    return show(
      context,
      title: title,
      subtitle: subtitle,
      type: SnackbarType.warning,
      duration: duration,
      onActionPressed: onActionPressed,
      actionLabel: actionLabel,
      position: position,
      showProgressIndicator: showProgressIndicator,
      blur: blur,
      backdropFilter: backdropFilter,
    );
  }

  /// Calculates appropriate margin based on snackbar position
  ///
  /// Takes into account safe areas, AppBar height, and potential FAB placement
  /// to ensure the snackbar is always visible and properly positioned.
  static EdgeInsets _getMargin(
    BuildContext context,
    SnackbarPosition position,
  ) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;

    switch (position) {
      case SnackbarPosition.top:
        return _calculateTopMargin(topPadding);
      case SnackbarPosition.bottom:
        return _calculateBottomMargin(mediaQuery, bottomPadding);
    }
  }

  /// Calculates margin for top-positioned snackbars
  static EdgeInsets _calculateTopMargin(double topPadding) {
    const appBarHeight = 56.0; // Standard AppBar height (kToolbarHeight)
    const horizontalPadding = 16.0;
    const extraPadding = 12.0;
    const minTopMargin = 70.0;

    final topMargin = topPadding + appBarHeight + extraPadding;
    return EdgeInsets.only(
      left: horizontalPadding,
      top: topMargin.clamp(minTopMargin, double.infinity),
      right: horizontalPadding,
    );
  }

  /// Calculates margin for bottom-positioned snackbars
  static EdgeInsets _calculateBottomMargin(
    MediaQueryData mediaQuery,
    double bottomPadding,
  ) {
    const horizontalPadding = 16.0;
    const baseMargin = 16.0;
    const fabSpaceThreshold = 700.0;
    const fabSpace = 80.0;
    const maxBottomMargin = 120.0;

    final screenHeight = mediaQuery.size.height;
    final baseBottomMargin = baseMargin + bottomPadding;
    final fabSpaceToAdd = screenHeight > fabSpaceThreshold ? fabSpace : 0.0;
    final bottomMargin = (baseBottomMargin + fabSpaceToAdd).clamp(
      baseMargin,
      maxBottomMargin,
    );

    return EdgeInsets.fromLTRB(
      horizontalPadding,
      baseMargin,
      horizontalPadding,
      bottomMargin,
    );
  }
}
