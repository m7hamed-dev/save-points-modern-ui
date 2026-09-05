/// SavePoints Snackbar Library
///
/// Provides modern, customizable snackbar widgets with enhanced UI/UX.
library;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_config.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_theme.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/top_snackbar_overlay.dart';

export 'content_design_style.dart';
export 'snackbar/snackbar_animation_direction.dart';
// Export enums for public use
export 'snackbar/snackbar_enums.dart';

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
  /// Returns a [ScaffoldFeatureController] whose `close()` dismisses the
  /// snackbar and whose `closed` future completes when it goes away — for
  /// both [SnackbarPosition.bottom] and [SnackbarPosition.top].
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

    /// Reveals and hides the snackbar with an expanding circular clip.
    /// Only honoured for [SnackbarPosition.top], which is overlay-based;
    /// bottom snackbars are laid out by Flutter's [ScaffoldMessenger] and
    /// cannot be clipped this way.
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

    /// Design style: [ContentDesignStyle.solid] (filled) or [ContentDesignStyle.outlined] (light bg + border).
    ContentDesignStyle? designStyle,

    /// Backdrop blur sigma for glassmorphism behind the snackbar.
    ///
    /// When null, the value falls back to the enclosing [SavePointsTheme];
    /// if that is null too, no blur is applied. Pass `0` to force blur off
    /// under a theme that enables it.
    double? blur,

    /// Optional custom [ImageFilter] for the backdrop. When set, overrides [blur].
    ImageFilter? backdropFilter,
  }) {
    // Validate required parameters
    assert(title.isNotEmpty, 'Title cannot be empty');

    final config = SnackDiaBottomConfig().snackbar;
    final spTheme = SavePointsTheme.maybeOf(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final finalType = type ?? config.defaultType;
    final finalDesignStyle =
        designStyle ?? spTheme?.designStyle ?? config.defaultDesignStyle;
    final finalBlur = blur ?? spTheme?.blur;

    final colorConfig = SnackbarColorConfig(
      theme: theme,
      isDark: isDark,
      background: background,
      gradient: gradient,
      iconColor: iconColor,
      type: finalType,
      config: config,
      designStyle: finalDesignStyle,
    );

    final finalIcon = icon ?? colorConfig.defaultIcon;
    final finalIconColor = iconColor ?? colorConfig.iconColor;
    final finalPosition =
        position ?? spTheme?.snackbarPosition ?? config.defaultPosition;
    // Use new animation system if startAnimation or endAnimation is provided
    final finalAnimation = (startAnimation == null && endAnimation == null)
        ? (animation ?? config.defaultAnimation)
        : null;
    final finalDuration =
        duration ?? spTheme?.snackbarDuration ?? config.defaultDuration;
    final finalMargin = margin ?? config.defaultMargin ?? _bottomMargin();
    final finalBorderRadius = borderRadius ??
        config.defaultBorderRadius ??
        BorderRadius.circular(SnackbarConstants.borderRadius);
    final finalMaxWidth =
        maxWidth ?? config.maxWidth ?? SnackbarConstants.maxWidth;
    final finalShowProgressIndicator =
        showProgressIndicator ?? config.defaultShowProgressIndicator;
    final finalDismissible = dismissible ?? config.defaultDismissible;
    final finalEnableHapticFeedback = enableHapticFeedback ??
        spTheme?.enableHapticFeedback ??
        config.defaultEnableHapticFeedback;
    final finalDismissOnTap = dismissOnTap ?? config.defaultDismissOnTap;
    final finalBorderWidth = borderWidth ?? config.defaultBorderWidth;
    final finalBorderColor = borderColor ??
        config.defaultBorderColor ??
        finalIconColor.withValues(alpha: 0.3);

    assert(
      ScaffoldMessenger.maybeOf(context) != null,
      'SavePointsSnackbar.show requires a ScaffoldMessenger ancestor. Wrap '
      'your app in a MaterialApp, or the calling subtree in a Scaffold.',
    );

    if (finalEnableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    // Use overlay for top position (SnackBar doesn't support top positioning well)
    if (finalPosition == SnackbarPosition.top) {
      final messenger = ScaffoldMessenger.of(context);

      // Retire the previous toast *before* touching the messenger. Its
      // dismissal closes that toast's placeholder, and a placeholder can only
      // be closed while it is still the messenger's current snack bar.
      TopSnackbarOverlay.hide();
      messenger.hideCurrentSnackBar();

      // The toast itself is an overlay entry, but Flutter still requires a
      // SnackBar on screen for a floating one not to be "presented off
      // screen". This transparent, zero-height placeholder holds the
      // messenger slot for exactly as long as the toast is up, which is what
      // makes the returned controller's `close()` and `closed` truthful.
      final controller = messenger.showSnackBar(
        SnackBar(
          content: const IgnorePointer(child: SizedBox.shrink()),
          // This placeholder is the toast's clock: the toast itself runs
          // with autoDismiss off. Two independent timers would race, and
          // whichever lost would call close() on a snack bar the messenger
          // had already dropped — "Bad state: No element".
          duration: finalDuration,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          margin: _bottomMargin(),
          dismissDirection: DismissDirection.none,
        ),
      );

      var settled = false;

      final token = TopSnackbarOverlay.show(
        context,
        autoDismiss: false,
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
        borderColor: finalDesignStyle == ContentDesignStyle.outlined
            ? colorConfig.borderColor
            : (finalBorderWidth > 0 ? finalBorderColor : null),
        borderWidth: finalDesignStyle == ContentDesignStyle.outlined
            ? 2
            : finalBorderWidth,
        onTap: onTap,
        hideLikeCircle: hideLikeCircle,
        onDismissed: () {
          if (settled) return;
          settled = true;
          onDismissed?.call();
          // User dismissed the toast (swipe / tap / close button): retire the
          // placeholder so `closed` completes at the right moment. Safe
          // because this only runs after the toast's exit animation, by which
          // point a placeholder that had expired on its own would already
          // have flipped `settled` above.
          controller.close();
        },
        blur: finalBlur,
        backdropFilter: backdropFilter,
        designStyle: finalDesignStyle,
        titleColor: colorConfig.titleColor,
        subtitleColor: colorConfig.subtitleColor,
        showCloseButton: finalDesignStyle == ContentDesignStyle.outlined ||
            finalDesignStyle == ContentDesignStyle.leftAccent ||
            finalDesignStyle == ContentDesignStyle.tonal ||
            finalDismissible,
      );

      // Placeholder retired first — the normal path, since it holds the
      // clock — or the caller invoked `close()`. Take the toast down with it.
      controller.closed.then((_) {
        if (settled) return;
        settled = true;
        TopSnackbarOverlay.hide(token);
        onDismissed?.call();
      });

      return controller;
    }

    // Remove any existing snackbar before showing a new one
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();

    // Use standard SnackBar for bottom position
    final controller = scaffoldMessenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: finalDuration,
        margin: finalMargin,
        shape: RoundedRectangleBorder(
          borderRadius: finalBorderRadius,
          side: finalDesignStyle != ContentDesignStyle.outlined &&
                  finalBorderWidth > 0
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
          blur: finalBlur,
          backdropFilter: backdropFilter,
          designStyle: finalDesignStyle,
          titleColor: colorConfig.titleColor,
          subtitleColor: colorConfig.subtitleColor,
          borderColor: finalDesignStyle == ContentDesignStyle.outlined
              ? colorConfig.borderColor
              : null,
          showCloseButton: finalDesignStyle == ContentDesignStyle.outlined ||
              finalDesignStyle == ContentDesignStyle.leftAccent ||
              finalDesignStyle == ContentDesignStyle.tonal ||
              finalDismissible,
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
    ContentDesignStyle? designStyle,
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
      designStyle: designStyle,
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
    ContentDesignStyle? designStyle,
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
      designStyle: designStyle,
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
    ContentDesignStyle? designStyle,
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
      designStyle: designStyle,
      blur: blur,
      backdropFilter: backdropFilter,
    );
  }

  /// Margin for a bottom-positioned snackbar.
  ///
  /// Deliberately does *not* try to reserve room for a
  /// [FloatingActionButton] or for the bottom safe area: [Scaffold] already
  /// lifts a [SnackBarBehavior.floating] snackbar clear of both. Adding our
  /// own offset on top double-counted that space — measurably so, since
  /// Scaffold's own FAB lift is 72dp — which pushed the snackbar too high on
  /// screens with a FAB and left a dead gap on screens without one.
  static EdgeInsets _bottomMargin() =>
      const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
}
