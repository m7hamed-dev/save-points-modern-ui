/// SavePoints Bottom Sheet Library
///
/// Provides modern, customizable bottom sheet widgets with glassmorphism design.
library;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_animation_direction.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_transition_builder.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/modern_bottomsheet.dart';

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
    double? blur,
    ImageFilter? backdropFilter,
  }) {
    // Dismiss keyboard when showing bottom sheet to prevent UI overlap
    _dismissKeyboard(context);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final finalIsDismissible = isDismissible ?? true;
    final finalEnableDrag = enableDrag ?? true;
    final finalShowHandle = showHandle ?? true;

    // When using blur/backdropFilter, barrier must be transparent so the route
    // is visible and can be blurred; we paint the blur in the transition.
    final ImageFilter? barrierFilter =
        backdropFilter ??
        (blur != null && blur <= 0
            ? null
            : ImageFilter.blur(sigmaX: blur ?? 20.0, sigmaY: blur ?? 20.0));
    final useBarrierBlur = barrierFilter != null;

    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: finalIsDismissible,
      barrierLabel: 'Close bottom sheet',
      barrierColor: useBarrierBlur
          ? Colors.transparent
          : Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, _, _) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, _) {
        return _BottomsheetTransitionScope(
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
          blur: blur,
          backdropFilter: backdropFilter,
          child: child,
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

/// Caches sheet content so it is built once per show, reducing rebuilds during animation.
class _BottomsheetTransitionScope extends StatefulWidget {
  const _BottomsheetTransitionScope({
    required this.animation,
    this.startAnimation,
    this.endAnimation,
    this.hideLikeCircle = false,
    required this.useBarrierBlur,
    this.barrierFilter,
    required this.barrierDismissible,
    this.title,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    required this.isDark,
    required this.isLoading,
    this.loadingNotifier,
    required this.showHandle,
    required this.isDismissible,
    required this.enableDrag,
    this.maxHeight,
    required this.isScrollControlled,
    this.blur,
    this.backdropFilter,
    this.child,
  });

  final Animation<double> animation;
  final BottomsheetAnimationDirection? startAnimation;
  final BottomsheetAnimationDirection? endAnimation;
  final bool hideLikeCircle;
  final bool useBarrierBlur;
  final ImageFilter? barrierFilter;
  final bool barrierDismissible;
  final String? title;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool isDark;
  final bool isLoading;
  final ValueNotifier<bool>? loadingNotifier;
  final bool showHandle;
  final bool isDismissible;
  final bool enableDrag;
  final double? maxHeight;
  final bool isScrollControlled;
  final double? blur;
  final ImageFilter? backdropFilter;
  final Widget? child;

  @override
  State<_BottomsheetTransitionScope> createState() =>
      _BottomsheetTransitionScopeState();
}

class _BottomsheetTransitionScopeState
    extends State<_BottomsheetTransitionScope> {
  Widget? _cachedSheet;

  static const _barrierDimColor = Color(0x40000000);

  @override
  Widget build(BuildContext context) {
    _cachedSheet ??= BottomsheetTransitionBuilder(
      animation: widget.animation,
      startAnimation: widget.startAnimation,
      endAnimation: widget.endAnimation,
      hideLikeCircle: widget.hideLikeCircle,
      bottomsheet: GestureDetector(
        onTap: () {},
        child: ModernBottomsheet(
          title: widget.title,
          icon: widget.icon,
          iconColor: widget.iconColor,
          backgroundColor: widget.backgroundColor,
          isDark: widget.isDark,
          isLoading: widget.isLoading,
          loadingNotifier: widget.loadingNotifier,
          showHandle: widget.showHandle,
          isDismissible: widget.isDismissible,
          enableDrag: widget.enableDrag,
          maxHeight: widget.maxHeight,
          isScrollControlled: widget.isScrollControlled,
          blur: widget.blur,
          backdropFilter: widget.backdropFilter,
          child: widget.child,
        ),
      ),
    );

    if (widget.useBarrierBlur && widget.barrierFilter != null) {
      final filter = widget.barrierFilter!;
      return Stack(
        fit: StackFit.expand,
        children: [
          RepaintBoundary(
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
          Align(alignment: Alignment.bottomCenter, child: _cachedSheet),
        ],
      );
    }

    return Align(alignment: Alignment.bottomCenter, child: _cachedSheet);
  }
}
