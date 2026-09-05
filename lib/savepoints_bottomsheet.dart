/// SavePoints Bottom Sheet Library
///
/// Provides modern, customizable bottom sheet widgets with glassmorphism design.
library;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_animation_direction.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_transition_scope.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_theme.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/utils/keyboard_utils.dart';

// Export animation direction for public use
export 'bottomsheet/bottomsheet_animation_direction.dart';

/// A modern, customizable bottom sheet with glassmorphism design.
///
/// This class provides a static method to display beautiful bottom sheets with:
/// - Glassmorphism effects with backdrop blur
/// - Drag handles and gestures
/// - Scrollable content support
/// - Loading states
/// - Custom animations
/// - Dark mode support
///
/// Example:
/// ```dart
/// SavePointsBottomsheet.show(
///   context: context,
///   title: 'Options',
///   child: YourContentWidget(),
/// );
/// ```
class SavePointsBottomsheet {
  /// Barrier blur sigma used when no `blur` is given by the call or the
  /// enclosing [SavePointsTheme].
  ///
  /// Bottom sheets blur their barrier by default; `blur: 0` opts out.
  static const double defaultBarrierBlurSigma = 20.0;

  /// Global fallback design style for [show] calls that don't pass one.
  ///
  /// Prefer wrapping your app in a [SavePointsTheme] instead: it scopes the
  /// default to a subtree, rebuilds descendants when it changes, and sets the
  /// same default for dialogs and snackbars at the same time. A mutable
  /// static like this one is process-wide and notifies nothing.
  @Deprecated(
    'Use SavePointsTheme(data: SavePointsThemeData(designStyle: ...)) instead. '
    'This static will be removed in a future major release.',
  )
  static ContentDesignStyle? defaultDesignStyle;

  /// Shows a modern bottom sheet.
  ///
  /// Returns the result value when the bottom sheet is dismissed,
  /// or `null` if dismissed without a result.
  ///
  /// Example:
  /// ```dart
  /// final result = await SavePointsBottomsheet.show<String>(
  ///   context: context,
  ///   title: 'Select Option',
  ///   child: OptionsList(),
  /// );
  /// ```
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    Widget? child,
    IconData? icon,
    Color? iconColor,
    Color? backgroundColor,
    bool? isDismissible,
    bool? enableDrag,
    bool? showHandle,
    double? maxHeight,
    bool isScrollControlled = false,
    BottomsheetAnimationDirection? startAnimation,
    BottomsheetAnimationDirection? endAnimation,
    bool isLoading = false,
    ValueNotifier<bool>? loadingNotifier,
    bool hideLikeCircle = false,
    ContentDesignStyle? designStyle,

    /// Backdrop blur sigma for the barrier behind the sheet.
    ///
    /// Falls back to the enclosing [SavePointsTheme], then to
    /// [SavePointsBottomsheet.defaultBarrierBlurSigma]. The barrier is blurred by
    /// default — pass `blur: 0` to turn it off and get a plain dim barrier.
    ///
    /// Note this differs from [SavePointsSnackbar.show]'s `blur`, which has
    /// no barrier to blur and so applies no blur when left unset.
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    // Dismiss keyboard when showing bottom sheet to prevent UI overlap
    KeyboardUtils.dismissIfFocused(context);

    final spTheme = SavePointsTheme.maybeOf(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final finalIsDismissible = isDismissible ?? true;
    final finalEnableDrag = enableDrag ?? true;
    final finalShowHandle = showHandle ?? true;
    final finalBlur = blur ?? spTheme?.blur;

    // When using blur/backdropFilter, barrier must be transparent so the route
    // is visible and can be blurred; we paint the blur in the transition.
    final barrierSigma = finalBlur ?? defaultBarrierBlurSigma;
    final ImageFilter? barrierFilter = backdropFilter ??
        (barrierSigma <= 0
            ? null
            : ImageFilter.blur(sigmaX: barrierSigma, sigmaY: barrierSigma));
    final useBarrierBlur = barrierFilter != null;

    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: finalIsDismissible,
      barrierLabel: 'Close bottom sheet',
      barrierColor: useBarrierBlur
          ? Colors.transparent
          : Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, _) {
        return BottomsheetTransitionScope(
          animation: animation,
          startAnimation: startAnimation,
          endAnimation: endAnimation,
          hideLikeCircle: hideLikeCircle,
          useBarrierBlur: useBarrierBlur,
          barrierFilter: barrierFilter,
          barrierDismissible: finalIsDismissible,
          title: title,
          icon: icon,
          iconColor: iconColor,
          backgroundColor: backgroundColor,
          isDark: isDark,
          isLoading: isLoading,
          loadingNotifier: loadingNotifier,
          showHandle: finalShowHandle,
          isDismissible: finalIsDismissible,
          enableDrag: finalEnableDrag,
          maxHeight: maxHeight,
          isScrollControlled: isScrollControlled,
          designStyle:
              designStyle ?? spTheme?.designStyle ?? defaultDesignStyle,
          blur: finalBlur,
          backdropFilter: backdropFilter,
          child: child,
        );
      },
    );
  }
}
