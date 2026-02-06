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
    const reverseCurve = Curves.easeInCubic;

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
      case .fadeSlide:
        return Curves.easeOutCubic;
      case .scale:
        return Curves.easeOutBack;
      case .slide:
        return Curves.easeOutCubic;
      case .bounce:
        return Curves.bounceOut;
      case .rotate:
        return Curves.easeOutBack;
      case .elastic:
        return Curves.elasticOut;
      case .slideRotate:
        return Curves.easeOutCubic;
      case .none:
        return Curves.linear;
    }
  }

  Widget _buildAnimation(Animation<double> clampedAnimation) {
    switch (animationType) {
      case .fadeSlide:
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
      case .scale:
        return FadeTransition(
          opacity: clampedAnimation,
          child: ScaleTransition(scale: clampedAnimation, child: child),
        );
      case .slide:
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(position == SnackbarPosition.top ? 0 : 0, -1),
            end: Offset.zero,
          ).animate(clampedAnimation),
          child: child,
        );
      case .bounce:
        return FadeTransition(
          opacity: clampedAnimation,
          child: ScaleTransition(scale: clampedAnimation, child: child),
        );
      case .rotate:
        final rotationAnimation = Tween<double>(
          begin: -0.1,
          end: 0.0,
        ).animate(clampedAnimation);
        return FadeTransition(
          opacity: clampedAnimation,
          child: RotationTransition(
            turns: rotationAnimation,
            child: ScaleTransition(scale: clampedAnimation, child: child),
          ),
        );
      case .elastic:
        return FadeTransition(
          opacity: clampedAnimation,
          child: ScaleTransition(scale: clampedAnimation, child: child),
        );
      case .slideRotate:
        final rotationAnimation = Tween<double>(
          begin: 0.1,
          end: 0.0,
        ).animate(clampedAnimation);
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
      case .none:
        return child;
    }
  }
}
