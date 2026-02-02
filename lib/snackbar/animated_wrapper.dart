import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_enums.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/clamped_animation.dart';

/// Wrapper for entrance and exit animations
class AnimatedWrapper extends StatelessWidget {
  const AnimatedWrapper({
    super.key,
    required this.animation,
    required this.animationType,
    required this.position,
    required this.child,
  });
  final Animation<double> animation;
  final SnackbarAnimation animationType;
  final SnackbarPosition position;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Use different curves for forward (entrance) and reverse (exit)
    final forwardCurve = _getForwardCurve();
    final reverseCurve = Curves.easeInCubic;

    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: forwardCurve,
      reverseCurve: reverseCurve,
    );

    final clampedAnimation = ClampedAnimation(curvedAnimation);

    return RepaintBoundary(child: _buildAnimation(clampedAnimation));
  }

  Curve _getForwardCurve() {
    switch (animationType) {
      case SnackbarAnimation.fadeSlide:
        return Curves.easeOutCubic;
      case SnackbarAnimation.scale:
        return Curves.easeOutBack;
      case SnackbarAnimation.slide:
        return Curves.easeOutCubic;
      case SnackbarAnimation.bounce:
        return Curves.bounceOut;
      case SnackbarAnimation.rotate:
        return Curves.easeOutBack;
      case SnackbarAnimation.elastic:
        return Curves.elasticOut;
      case SnackbarAnimation.slideRotate:
        return Curves.easeOutCubic;
      case SnackbarAnimation.none:
        return Curves.linear;
    }
  }

  Widget _buildAnimation(Animation<double> clampedAnimation) {
    switch (animationType) {
      case SnackbarAnimation.fadeSlide:
        return FadeTransition(
          opacity: clampedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, position == SnackbarPosition.top ? -0.3 : 0.3),
              end: Offset.zero,
            ).animate(clampedAnimation),
            child: child,
          ),
        );
      case SnackbarAnimation.scale:
        return FadeTransition(
          opacity: clampedAnimation,
          child: ScaleTransition(scale: clampedAnimation, child: child),
        );
      case SnackbarAnimation.slide:
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(position == SnackbarPosition.top ? 0 : 0, -1),
            end: Offset.zero,
          ).animate(clampedAnimation),
          child: child,
        );
      case SnackbarAnimation.bounce:
        return FadeTransition(
          opacity: clampedAnimation,
          child: ScaleTransition(
            scale: clampedAnimation,
            child: child,
          ),
        );
      case SnackbarAnimation.rotate:
        final rotationAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
          clampedAnimation,
        );
        return FadeTransition(
          opacity: clampedAnimation,
          child: RotationTransition(
            turns: rotationAnimation,
            child: ScaleTransition(scale: clampedAnimation, child: child),
          ),
        );
      case SnackbarAnimation.elastic:
        return FadeTransition(
          opacity: clampedAnimation,
          child: ScaleTransition(
            scale: clampedAnimation,
            child: child,
          ),
        );
      case SnackbarAnimation.slideRotate:
        final rotationAnimation = Tween<double>(begin: 0.1, end: 0.0).animate(
          clampedAnimation,
        );
        return FadeTransition(
          opacity: clampedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(
                position == SnackbarPosition.top ? 0 : 0,
                position == SnackbarPosition.top ? -0.5 : 0.5,
              ),
              end: Offset.zero,
            ).animate(clampedAnimation),
            child: RotationTransition(turns: rotationAnimation, child: child),
          ),
        );
      case SnackbarAnimation.none:
        return child;
    }
  }
}
