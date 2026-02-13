import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_animation_direction.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_animation_type.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_transition_builder.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/modern_dialog.dart';

/// Caches dialog content so it is built once per show, reducing rebuilds during animation.
class DialogTransitionScope extends StatefulWidget {
  const DialogTransitionScope({
    super.key,
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
    this.child,
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
  final Widget? child;

  @override
  State<DialogTransitionScope> createState() => _DialogTransitionScopeState();
}

class _DialogTransitionScopeState extends State<DialogTransitionScope> {
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
        child: widget.child,
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
