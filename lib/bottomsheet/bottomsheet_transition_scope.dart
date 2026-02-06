import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_animation_direction.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_transition_builder.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/modern_bottomsheet.dart';

/// Caches sheet content so it is built once per show, reducing rebuilds during animation.
class BottomsheetTransitionScope extends StatefulWidget {
  const BottomsheetTransitionScope({
    super.key,
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
    this.designStyle,
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
  final ContentDesignStyle? designStyle;
  final double? blur;
  final ImageFilter? backdropFilter;
  final Widget? child;

  @override
  State<BottomsheetTransitionScope> createState() =>
      _BottomsheetTransitionScopeState();
}

class _BottomsheetTransitionScopeState
    extends State<BottomsheetTransitionScope> {
  Widget? _cachedSheet;
  double _lastKeyboardHeight = 0;

  static const _barrierDimColor = Color(0x40000000);

  @override
  Widget build(BuildContext context) {
    // Get current keyboard height to detect changes
    final currentKeyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    // Rebuild sheet when keyboard state changes (appears/disappears)
    if (_cachedSheet == null ||
        (currentKeyboardHeight > 0) != (_lastKeyboardHeight > 0)) {
      _lastKeyboardHeight = currentKeyboardHeight;
      _cachedSheet = BottomsheetTransitionBuilder(
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
            designStyle: widget.designStyle,
            blur: widget.blur,
            backdropFilter: widget.backdropFilter,
            child: widget.child,
          ),
        ),
      );
    }

    // Get keyboard height to position bottom sheet above it
    final keyboardHeight = currentKeyboardHeight;

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
          Positioned(
            left: 0,
            right: 0,
            bottom: keyboardHeight,
            child: _cachedSheet!,
          ),
        ],
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Barrier for dismissing
        if (widget.barrierDismissible)
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.transparent),
          ),
        Positioned(
          left: 0,
          right: 0,
          bottom: keyboardHeight,
          child: _cachedSheet!,
        ),
      ],
    );
  }
}
