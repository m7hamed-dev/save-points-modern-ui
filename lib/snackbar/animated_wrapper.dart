import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_enums.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/clamped_animation.dart';

/// Wrapper for entrance animations
class AnimatedWrapper extends StatelessWidget {
  final Animation<double> animation;
  final SnackbarAnimation animationType;
  final SnackbarPosition position;
  final Widget child;

  const AnimatedWrapper({
    super.key,
    required this.animation,
    required this.animationType,
    required this.position,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Clamp all animations to prevent values outside [0, 1] range
    final clampedAnimation = ClampedAnimation(animation);

    return RepaintBoundary(child: _buildAnimation(clampedAnimation));
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
            scale: ClampedAnimation(
              CurvedAnimation(parent: animation, curve: Curves.bounceOut),
            ),
            child: child,
          ),
        );
      case SnackbarAnimation.rotate:
        final rotationAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
          ClampedAnimation(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
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
            scale: ClampedAnimation(
              CurvedAnimation(parent: animation, curve: Curves.elasticOut),
            ),
            child: child,
          ),
        );
      case SnackbarAnimation.slideRotate:
        final rotationAnimation = Tween<double>(begin: 0.1, end: 0.0).animate(
          ClampedAnimation(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
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
